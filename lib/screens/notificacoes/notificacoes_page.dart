import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../services/supabase/supabase_notification_service.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key});

  @override
  State<NotificacoesPage> createState() =>
      _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  final SupabaseNotificationService _notificationService =
      SupabaseNotificationService();

  List<Map<String, dynamic>> _notificacoes = [];

  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarNotificacoes();
  }

  Future<void> _carregarNotificacoes() async {
    if (mounted) {
      setState(() {
        _carregando = true;
        _erro = null;
      });
    }

    try {
      final notificacoes =
          await _notificationService.listarNotificacoes();

      if (!mounted) return;

      setState(() {
        _notificacoes = notificacoes;
      });
    } catch (e) {
      debugPrint('ERRO AO CARREGAR NOTIFICAÇÕES: $e');

      if (!mounted) return;

      setState(() {
        _erro = 'Não foi possível carregar as notificações.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  Future<void> _marcarComoLida(
    Map<String, dynamic> notificacao,
  ) async {
    final jaLida = notificacao['is_read'] == true;

    if (jaLida) return;

    final id = notificacao['id']?.toString();

    if (id == null) return;

    setState(() {
      notificacao['is_read'] = true;
    });

    try {
      await _notificationService.marcarComoLida(id);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        notificacao['is_read'] = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível atualizar a notificação.',
          ),
        ),
      );
    }
  }

  Future<void> _marcarTodasComoLidas() async {
    final possuiNaoLidas = _notificacoes.any(
      (notificacao) => notificacao['is_read'] != true,
    );

    if (!possuiNaoLidas) return;

    try {
      await _notificationService.marcarTodasComoLidas();

      if (!mounted) return;

      setState(() {
        for (final notificacao in _notificacoes) {
          notificacao['is_read'] = true;
        }
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível marcar as notificações como lidas.',
          ),
        ),
      );
    }
  }

  String _nomeAtor(Map<String, dynamic> notificacao) {
    final ator = notificacao['actor'];

    if (ator is Map) {
      final nome = ator['nome']?.toString().trim();

      if (nome != null && nome.isNotEmpty) {
        return nome;
      }
    }

    return 'Alguém';
  }

  String? _avatarAtor(Map<String, dynamic> notificacao) {
    final ator = notificacao['actor'];

    if (ator is Map) {
      final avatar = ator['avatar_url']?.toString().trim();

      if (avatar != null && avatar.isNotEmpty) {
        return avatar;
      }
    }

    return null;
  }

  String? _tituloReceita(Map<String, dynamic> notificacao) {
    final receita = notificacao['recipe'];

    if (receita is Map) {
      final titulo = receita['title']?.toString().trim();

      if (titulo != null && titulo.isNotEmpty) {
        return titulo;
      }
    }

    return null;
  }

  String _tituloNotificacao(
    Map<String, dynamic> notificacao,
  ) {
    switch (notificacao['type']) {
      case 'follow':
        return 'Novo seguidor';

      case 'recipe_like':
        return 'Nova curtida';

      default:
        return 'Notificação';
    }
  }

  String _descricaoNotificacao(
    Map<String, dynamic> notificacao,
  ) {
    final nome = _nomeAtor(notificacao);

    switch (notificacao['type']) {
      case 'follow':
        return '$nome começou a seguir você.';

      case 'recipe_like':
        final receita = _tituloReceita(notificacao);

        if (receita != null) {
          return '$nome curtiu sua receita "$receita".';
        }

        return '$nome curtiu uma receita sua.';

      default:
        return 'Você recebeu uma nova notificação.';
    }
  }

  IconData _iconeNotificacao(
    Map<String, dynamic> notificacao,
  ) {
    switch (notificacao['type']) {
      case 'follow':
        return Icons.person_add_alt_1_outlined;

      case 'recipe_like':
        return Icons.favorite_outline;

      default:
        return Icons.notifications_none;
    }
  }

  String _formatarHorario(dynamic valor) {
    if (valor == null) return '';

    final data = DateTime.tryParse(
      valor.toString(),
    )?.toLocal();

    if (data == null) return '';

    final agora = DateTime.now();
    final diferenca = agora.difference(data);

    if (diferenca.inMinutes < 1) {
      return 'Agora';
    }

    if (diferenca.inMinutes < 60) {
      return 'Há ${diferenca.inMinutes} min';
    }

    if (diferenca.inHours < 24) {
      return 'Há ${diferenca.inHours} h';
    }

    if (diferenca.inDays == 1) {
      return 'Ontem';
    }

    if (diferenca.inDays < 7) {
      return 'Há ${diferenca.inDays} dias';
    }

    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');

    return '$dia/$mes/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    final possuiNaoLidas = _notificacoes.any(
      (notificacao) => notificacao['is_read'] != true,
    );

    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Notificações',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          if (!_carregando &&
              _notificacoes.isNotEmpty &&
              possuiNaoLidas)
            TextButton(
              onPressed: _marcarTodasComoLidas,
              child: const Text(
                'Ler todas',
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _carregarNotificacoes,
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_carregando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_erro != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(
          AppTheme.spacingLg,
        ),
        children: [
          const SizedBox(height: 120),
          Icon(
            Icons.error_outline,
            size: 56,
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Text(
            _erro!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Center(
            child: FilledButton(
              onPressed: _carregarNotificacoes,
              child: const Text('Tentar novamente'),
            ),
          ),
        ],
      );
    }

    if (_notificacoes.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.65,
            child: _buildEmptyState(context),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(
        AppTheme.spacingLg,
      ),
      itemCount: _notificacoes.length,
      separatorBuilder: (context, index) =>
          const SizedBox(
        height: AppTheme.spacingMd,
      ),
      itemBuilder: (context, index) {
        final notificacao = _notificacoes[index];

        return _buildNotificationItem(
          context,
          notificacao: notificacao,
        );
      },
    );
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required Map<String, dynamic> notificacao,
  }) {
    final lida = notificacao['is_read'] == true;
    final avatarUrl = _avatarAtor(notificacao);

    return InkWell(
      onTap: () => _marcarComoLida(notificacao),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(
          AppTheme.spacingMd,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: lida
                ? Theme.of(context).colorScheme.outline
                : AppTheme.verdePrincipal,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatarOuIcone(
              notificacao,
              avatarUrl,
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          _tituloNotificacao(notificacao),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                fontWeight: lida
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                              ),
                        ),
                      ),
                      if (!lida)
                        Container(
                          width: 8,
                          height: 8,
                          margin:
                              const EdgeInsets.only(top: 4),
                          decoration:
                              const BoxDecoration(
                            color: AppTheme.verdePrincipal,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: AppTheme.spacingSm,
                  ),
                  Text(
                    _descricaoNotificacao(notificacao),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(
                    height: AppTheme.spacingSm,
                  ),
                  Text(
                    _formatarHorario(
                      notificacao['created_at'],
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                          color: AppTheme.verdePrincipal,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarOuIcone(
    Map<String, dynamic> notificacao,
    String? avatarUrl,
  ) {
    if (avatarUrl != null) {
      return CircleAvatar(
        radius: 22,
        backgroundColor: AppTheme.verdeClaro,
        backgroundImage: NetworkImage(avatarUrl),
      );
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.verdeClaro,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        _iconeNotificacao(notificacao),
        color: AppTheme.verdePrincipal,
        size: 23,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppTheme.spacingLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_none,
              size: 56,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'Nenhuma notificação',
              style:
                  Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Quando alguém seguir você ou curtir uma receita sua, a notificação aparecerá aqui.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}