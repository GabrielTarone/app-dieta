import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../services/supabase/supabase_favorite_service.dart';

class CurtidasRecebidasPage extends StatefulWidget {
  const CurtidasRecebidasPage({super.key});

  @override
  State<CurtidasRecebidasPage> createState() =>
      _CurtidasRecebidasPageState();
}

class _CurtidasRecebidasPageState
    extends State<CurtidasRecebidasPage> {
  final SupabaseFavoriteService _favoriteService =
      SupabaseFavoriteService();

  bool _carregando = true;
  String? _erro;

  List<Map<String, dynamic>> _receitas = [];

  @override
  void initState() {
    super.initState();
    _carregarReceitas();
  }

  Future<void> _carregarReceitas() async {
    try {
      final receitas =
          await _favoriteService.listarMinhasReceitasCurtidas();

      if (!mounted) return;

      setState(() {
        _receitas = receitas;
        _erro = null;
        _carregando = false;
      });
    } catch (e) {
      debugPrint(
        'ERRO AO CARREGAR RECEITAS CURTIDAS: $e',
      );

      if (!mounted) return;

      setState(() {
        _erro =
            'Não foi possível carregar suas curtidas.';
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Curtidas recebidas'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_carregando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(
            AppTheme.spacingLg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _erro!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: AppTheme.spacingMd,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _carregando = true;
                    _erro = null;
                  });

                  _carregarReceitas();
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_receitas.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(
            AppTheme.spacingLg,
          ),
          child: Text(
            'Suas receitas ainda não receberam curtidas.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final totalCurtidas = _receitas.fold<int>(
      0,
      (total, receita) =>
          total +
          (int.tryParse(
                receita['total_curtidas'].toString(),
              ) ??
              0),
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(
            AppTheme.spacingLg,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.favorite,
                color: AppTheme.verdePrincipal,
              ),
              const SizedBox(
                width: AppTheme.spacingSm,
              ),
              Text(
                '$totalCurtidas '
                '${totalCurtidas == 1 ? 'curtida recebida' : 'curtidas recebidas'}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(
              AppTheme.spacingLg,
            ),
            itemCount: _receitas.length,
            separatorBuilder: (context, index) =>
                const Divider(),
            itemBuilder: (context, index) {
              return _buildReceita(
                _receitas[index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReceita(
    Map<String, dynamic> receita,
  ) {
    final titulo =
        receita['titulo']?.toString() ?? 'Receita';

    final total =
        int.tryParse(
          receita['total_curtidas'].toString(),
        ) ??
        0;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.verdeClaro,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.restaurant_menu,
          color: AppTheme.cinzaEscuro,
        ),
      ),
      title: Text(
        titulo,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      subtitle: Text(
        '$total ${total == 1 ? 'curtida' : 'curtidas'}',
      ),
      trailing: const Icon(
        Icons.chevron_right,
      ),
      onTap: () {
        _abrirQuemCurtiu(receita);
      },
    );
  }

  Future<void> _abrirQuemCurtiu(
    Map<String, dynamic> receita,
  ) async {
    final recipeId =
        receita['recipe_id']?.toString();

    final titulo =
        receita['titulo']?.toString() ?? 'Receita';

    if (recipeId == null) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _QuemCurtiuSheet(
          recipeId: recipeId,
          titulo: titulo,
          favoriteService: _favoriteService,
        );
      },
    );
  }
}

class _QuemCurtiuSheet extends StatefulWidget {
  final String recipeId;
  final String titulo;
  final SupabaseFavoriteService favoriteService;

  const _QuemCurtiuSheet({
    required this.recipeId,
    required this.titulo,
    required this.favoriteService,
  });

  @override
  State<_QuemCurtiuSheet> createState() =>
      _QuemCurtiuSheetState();
}

class _QuemCurtiuSheetState
    extends State<_QuemCurtiuSheet> {
  bool _carregando = true;
  String? _erro;

  List<Map<String, dynamic>> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    try {
      final usuarios =
          await widget.favoriteService.listarQuemCurtiu(
        widget.recipeId,
      );

      if (!mounted) return;

      setState(() {
        _usuarios = usuarios;
        _erro = null;
        _carregando = false;
      });
    } catch (e) {
      debugPrint(
        'ERRO AO CARREGAR QUEM CURTIU: $e',
      );

      if (!mounted) return;

      setState(() {
        _erro =
            'Não foi possível carregar as curtidas.';
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height:
            MediaQuery.of(context).size.height * 0.65,
        child: Column(
          children: [
            const SizedBox(height: 12),

            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
                borderRadius:
                    BorderRadius.circular(10),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(
                AppTheme.spacingLg,
              ),
              child: Column(
                children: [
                  Text(
                    widget.titulo,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Quem curtiu'),
                ],
              ),
            ),

            const Divider(height: 1),

            Expanded(
              child: _buildConteudo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConteudo() {
    if (_carregando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_erro != null) {
      return Center(
        child: Text(_erro!),
      );
    }

    if (_usuarios.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma curtida encontrada.',
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(
        AppTheme.spacingLg,
      ),
      itemCount: _usuarios.length,
      separatorBuilder: (context, index) =>
          const Divider(),
      itemBuilder: (context, index) {
        final usuario = _usuarios[index];

        final nome =
            usuario['nome']?.toString() ??
                'Usuário NutriGo';

        final avatarUrl =
            usuario['avatar_url']?.toString();

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: AppTheme.verdeClaro,
            backgroundImage:
                avatarUrl != null &&
                        avatarUrl.isNotEmpty
                    ? NetworkImage(avatarUrl)
                    : null,
            child:
                avatarUrl == null ||
                        avatarUrl.isEmpty
                    ? const Icon(
                        Icons.person,
                        color: AppTheme.cinzaEscuro,
                      )
                    : null,
          ),
          title: Text(nome),
        );
      },
    );
  }
}