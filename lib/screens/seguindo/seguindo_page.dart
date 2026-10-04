import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../services/supabase/supabase_follow_service.dart';

class SeguindoPage extends StatefulWidget {
  const SeguindoPage({super.key});

  @override
  State<SeguindoPage> createState() => _SeguindoPageState();
}

class _SeguindoPageState extends State<SeguindoPage>
    with SingleTickerProviderStateMixin {
  final SupabaseFollowService _followService =
      SupabaseFollowService();

  late final TabController _tabController;

  bool _carregando = true;
  String? _erro;

  List<Map<String, dynamic>> _seguidores = [];
  List<Map<String, dynamic>> _seguindo = [];

  final Set<String> _idsQueEuSigo = {};

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 1,
    );

    _carregarConexoes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _carregarConexoes() async {
    try {
      final resultados = await Future.wait([
        _followService.buscarSeguidores(),
        _followService.buscarUsuariosSeguindo(),
      ]);

      final seguidores = resultados[0];
      final seguindo = resultados[1];

      if (!mounted) return;

      setState(() {
        _seguidores = seguidores;
        _seguindo = seguindo;

        _idsQueEuSigo
          ..clear()
          ..addAll(
            seguindo
                .map(
                  (usuario) => usuario['id']?.toString(),
                )
                .whereType<String>(),
          );

        _erro = null;
        _carregando = false;
      });
    } catch (e) {
      debugPrint('ERRO AO CARREGAR CONEXÕES: $e');

      if (!mounted) return;

      setState(() {
        _erro = 'Não foi possível carregar as conexões.';
        _carregando = false;
      });
    }
  }

  Future<void> _alternarSeguir(
    Map<String, dynamic> usuario,
  ) async {
    final usuarioId = usuario['id']?.toString();

    if (usuarioId == null) return;

    final estaSeguindo =
        _idsQueEuSigo.contains(usuarioId);

    try {
      if (estaSeguindo) {
        await _followService.deixarDeSeguir(usuarioId);
      } else {
        await _followService.seguir(usuarioId);
      }

      await _carregarConexoes();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            estaSeguindo
                ? 'Você deixou de seguir este usuário.'
                : 'Agora você está seguindo este usuário.',
          ),
        ),
      );
    } catch (e) {
      debugPrint('ERRO AO ALTERAR RELACIONAMENTO: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível atualizar o relacionamento.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Conexões'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.verdePrincipal,
          labelColor: AppTheme.verdePrincipal,
          unselectedLabelColor:
              Theme.of(context).colorScheme.onSurfaceVariant,
          tabs: [
            Tab(
              text: 'Seguidores (${_seguidores.length})',
            ),
            Tab(
              text: 'Seguindo (${_seguindo.length})',
            ),
          ],
        ),
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

                  _carregarConexoes();
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildLista(
          usuarios: _seguidores,
          mensagemVazia:
              'Você ainda não possui seguidores.',
        ),
        _buildLista(
          usuarios: _seguindo,
          mensagemVazia:
              'Você ainda não segue ninguém.',
        ),
      ],
    );
  }

  Widget _buildLista({
    required List<Map<String, dynamic>> usuarios,
    required String mensagemVazia,
  }) {
    if (usuarios.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(
            AppTheme.spacingLg,
          ),
          child: Text(
            mensagemVazia,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(
        AppTheme.spacingLg,
      ),
      itemCount: usuarios.length,
      separatorBuilder: (context, index) =>
          const Divider(),
      itemBuilder: (context, index) {
        return _buildUsuario(
          usuarios[index],
        );
      },
    );
  }

  Widget _buildUsuario(
    Map<String, dynamic> usuario,
  ) {
    final usuarioId =
        usuario['id']?.toString();

    final nome =
        usuario['nome']?.toString() ??
            'Usuário NutriGo';

    final avatarUrl =
        usuario['avatar_url']?.toString();

    final estaSeguindo =
        usuarioId != null &&
            _idsQueEuSigo.contains(usuarioId);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 24,
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
      title: Text(
        nome,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      trailing: OutlinedButton(
        onPressed: () {
          _alternarSeguir(usuario);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: estaSeguindo
              ? Theme.of(context)
                  .colorScheme
                  .onSurface
              : AppTheme.verdePrincipal,
        ),
        child: Text(
          estaSeguindo
              ? 'Seguindo'
              : 'Seguir',
        ),
      ),
    );
  }
}