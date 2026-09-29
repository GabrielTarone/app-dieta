import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key});

  @override
  State<NotificacoesPage> createState() =>
      _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  final List<Map<String, dynamic>> _notificacoes = [
    {
      'titulo': 'Sua receita recebeu uma curtida',
      'descricao':
          'Seu Bowl de Frango com Quinoa recebeu uma nova curtida.',
      'horario': 'Há 10 min',
      'icone': Icons.favorite_outline,
      'lida': false,
    },
    {
      'titulo': 'Nova receita recomendada',
      'descricao':
          'Encontramos uma receita saudável que combina com você.',
      'horario': 'Há 1 h',
      'icone': Icons.restaurant_outlined,
      'lida': false,
    },
    {
      'titulo': 'Sua receita está fazendo sucesso!',
      'descricao':
          'Seu Bowl de Frango com Quinoa está recebendo novas visualizações.',
      'horario': 'Ontem',
      'icone': Icons.trending_up,
      'lida': true,
    },
  ];

  void _marcarComoLida(int index) {
    setState(() {
      _notificacoes[index]['lida'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      ),

      body: _notificacoes.isEmpty
          ? _buildEmptyState(context)
          : ListView.separated(
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
                  index: index,
                  titulo: notificacao['titulo'],
                  descricao: notificacao['descricao'],
                  horario: notificacao['horario'],
                  icone: notificacao['icone'],
                  lida: notificacao['lida'],
                );
              },
            ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required int index,
    required String titulo,
    required String descricao,
    required String horario,
    required IconData icone,
    required bool lida,
  }) {
    return InkWell(
      onTap: () {
        _marcarComoLida(index);
      },
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
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.verdeClaro,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icone,
                color: AppTheme.verdePrincipal,
                size: 23,
              ),
            ),

            const SizedBox(width: AppTheme.spacingMd),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          titulo,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge,
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
                            color:
                                AppTheme.verdePrincipal,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(
                    height: AppTheme.spacingSm,
                  ),

                  Text(
                    descricao,
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
                    horario,
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
              'Suas notificações aparecerão aqui.',
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