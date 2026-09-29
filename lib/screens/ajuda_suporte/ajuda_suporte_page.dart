import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class AjudaSuportePage extends StatelessWidget {
  const AjudaSuportePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Ajuda e suporte',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),

            const SizedBox(height: AppTheme.spacingLg),

            Text(
              'Perguntas frequentes',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: AppTheme.spacingMd),

            _buildQuestion(
              context,
              question: 'Como favoritar uma receita?',
              answer:
                  'Toque no ícone de coração de uma receita. '
                  'Ela será adicionada à sua lista de favoritos.',
            ),

            _buildQuestion(
              context,
              question: 'Onde encontro minhas receitas favoritas?',
              answer:
                  'Acesse a aba Favoritos pelo menu inferior ou '
                  'entre em Perfil e toque em Receitas favoritas.',
            ),

            _buildQuestion(
              context,
              question: 'Como pesquisar uma receita?',
              answer:
                  'Utilize o campo Buscar receitas na Home ou na '
                  'tela Explorar para pesquisar pelo nome ou categoria.',
            ),

            _buildQuestion(
              context,
              question: 'Como alterar o tema do aplicativo?',
              answer:
                  'Acesse Perfil, depois Configurações e toque em Tema. '
                  'Você pode escolher entre Sistema, Claro ou Escuro.',
            ),

            const SizedBox(height: AppTheme.spacingLg),

            Text(
              'Suporte',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: AppTheme.spacingMd),

            _buildSupportItem(
              context,
              icon: Icons.email_outlined,
              title: 'Falar com o suporte',
              subtitle: 'Entre em contato com a equipe NutriGo',
              onTap: () {
                _mostrarSuporte(context);
              },
            ),

            const SizedBox(height: AppTheme.spacingMd),

            _buildSupportItem(
              context,
              icon: Icons.info_outline,
              title: 'Sobre o NutriGo',
              subtitle: 'Conheça mais sobre o aplicativo',
              onTap: () {
                _mostrarSobre(context);
              },
            ),

            const SizedBox(height: AppTheme.spacingLg),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.help_outline,
            size: 48,
            color: AppTheme.verdePrincipal,
          ),

          const SizedBox(height: AppTheme.spacingMd),

          Text(
            'Como podemos ajudar?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),

          const SizedBox(height: AppTheme.spacingSm),

          Text(
            'Encontre respostas para as principais dúvidas sobre o NutriGo.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: AppTheme.verdePrincipal,
        collapsedIconColor:
            Theme.of(context).colorScheme.onSurfaceVariant,
        title: Text(
          question,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spacingMd,
              0,
              AppTheme.spacingMd,
              AppTheme.spacingMd,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                answer,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.verdeClaro,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: AppTheme.verdePrincipal,
              ),
            ),

            const SizedBox(width: AppTheme.spacingMd),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style:
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarSuporte(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Falar com o suporte'),
          content: const Text(
            'Para este protótipo, o contato com o suporte '
            'é apenas demonstrativo.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarSobre(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sobre o NutriGo'),
          content: const Text(
            'O NutriGo ajuda você a descobrir, organizar '
            'e acompanhar receitas de forma simples e prática.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}