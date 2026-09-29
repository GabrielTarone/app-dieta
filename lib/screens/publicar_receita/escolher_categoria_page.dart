import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'publicar_receita_page.dart';
import '../../models/recipe.dart';

class EscolherCategoriaPage extends StatelessWidget {
  const EscolherCategoriaPage({
    super.key,
  });

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
          'Nova receita',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(
            AppTheme.spacingLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'O que você quer preparar?',
                style:
                    Theme.of(context).textTheme.headlineLarge,
              ),

              const SizedBox(
                height: AppTheme.spacingSm,
              ),

              Text(
                'Escolha uma categoria para começar.',
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
                height: AppTheme.spacingLg,
              ),

              _buildCategoria(
                context,
                icon: Icons.free_breakfast_outlined,
                titulo: 'Café da manhã',
              ),

              const SizedBox(
                height: AppTheme.spacingMd,
              ),

              _buildCategoria(
                context,
                icon: Icons.restaurant_outlined,
                titulo: 'Almoço',
              ),

              const SizedBox(
                height: AppTheme.spacingMd,
              ),

              _buildCategoria(
                context,
                icon: Icons.bakery_dining_outlined,
                titulo: 'Lanche',
              ),

              const SizedBox(
                height: AppTheme.spacingMd,
              ),

              _buildCategoria(
                context,
                icon: Icons.nightlight_outlined,
                titulo: 'Jantar',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoria(
    BuildContext context, {
    required IconData icon,
    required String titulo,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),

      onTap: () async {
        final novaReceita = await Navigator.push<Recipe>(
          context,
          MaterialPageRoute(
            builder: (context) => PublicarReceitaPage(
              categoria: titulo,
            ),
          ),
        );

        if (novaReceita != null && context.mounted) {
          Navigator.pop(
            context,
            novaReceita,
          );
        }
      },

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(
          AppTheme.spacingMd,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                Theme.of(context).colorScheme.outlineVariant,
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.verdePrincipal.withValues(
                  alpha: 0.12,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppTheme.verdePrincipal,
              ),
            ),

            const SizedBox(
              width: AppTheme.spacingMd,
            ),

            Expanded(
              child: Text(
                titulo,
                style:
                    Theme.of(context).textTheme.titleMedium,
              ),
            ),

            Icon(
              Icons.chevron_right,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}