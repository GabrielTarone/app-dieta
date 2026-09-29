import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_theme.dart';
import '../../models/recipe.dart';
import '../publicar_receita/publicar_receita_page.dart';

class DetalhesReceitaPage extends StatefulWidget {
  final Recipe recipe;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  final bool podeEditar;
  final void Function(Recipe)? onEditarReceita;

  const DetalhesReceitaPage({
    super.key,
    required this.recipe,
    required this.isFavorite,
    required this.onFavoriteTap,
    this.podeEditar = false,
    this.onEditarReceita,
  });

  @override
  State<DetalhesReceitaPage> createState() =>
      _DetalhesReceitaPageState();
}

class _DetalhesReceitaPageState
    extends State<DetalhesReceitaPage> {
  late bool _isFavorite;
  late Recipe _recipe;

  @override
  void initState() {
    super.initState();

    _isFavorite = widget.isFavorite;
    _recipe = widget.recipe;
  }

  Future<void> _editarReceita() async {
    final receitaEditada = await Navigator.push<Recipe>(
      context,
      MaterialPageRoute(
        builder: (context) => PublicarReceitaPage(
          categoria: _recipe.category,
          receitaParaEditar: _recipe,
        ),
      ),
    );

    if (receitaEditada != null) {
      widget.onEditarReceita?.call(
        receitaEditada,
      );

      if (mounted) {
        setState(() {
          _recipe = receitaEditada;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Receita atualizada com sucesso!',
            ),
          ),
        );
      }
    }
  }

  void _compartilharReceita() {
    final texto = '''
🍽️ ${_recipe.title}

⏱️ Tempo: ${_recipe.time}
📊 Dificuldade: ${_recipe.difficulty}
🔥 Por porção: ${_recipe.calories}

Ingredientes:
${_recipe.ingredients.map((item) => '• $item').join('\n')}

Modo de preparo:
${_recipe.preparation.asMap().entries.map(
          (entry) => '${entry.key + 1}. ${entry.value}',
        ).join('\n')}
''';

    SharePlus.instance.share(
      ShareParams(
        text: texto,
      ),
    );
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
          'Detalhes da receita',
          style:
              Theme.of(context).textTheme.titleMedium,
        ),

        actions: [
          if (widget.podeEditar)
            IconButton(
              onPressed: _editarReceita,
              tooltip: 'Editar receita',
              icon: Icon(
                Icons.edit_outlined,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),

          IconButton(
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });

              widget.onFavoriteTap();
            },
            icon: Icon(
              _isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: _isFavorite
                  ? AppTheme.verdePrincipal
                  : Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
            ),
          ),

          IconButton(
            onPressed: _compartilharReceita,
            icon: Icon(
              Icons.share_outlined,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),

          const SizedBox(
            width: AppTheme.spacingSm,
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLg,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: AppTheme.spacingMd,
              ),

              _buildRecipeImage(),

              const SizedBox(
                height: AppTheme.spacingLg,
              ),

              Text(
                _recipe.title,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge,
              ),

              const SizedBox(
                height: AppTheme.spacingLg,
              ),

              _buildRecipeInfo(context),

              const SizedBox(
                height: AppTheme.spacingLg,
              ),

              _buildIngredients(context),

              const SizedBox(
                height: AppTheme.spacingLg,
              ),

              _buildPreparation(context),

              const SizedBox(
                height: AppTheme.spacingLg,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeImage() {
    // Foto escolhida pelo usuário.
    if (_recipe.imageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.memory(
          _recipe.imageBytes!,
          width: double.infinity,
          height: 220,
          fit: BoxFit.cover,
        ),
      );
    }

    // Imagem original das receitas do app.
    if (_recipe.imagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          _recipe.imagePath!,
          width: double.infinity,
          height: 220,
          fit: BoxFit.cover,
        ),
      );
    }

    // Receita sem imagem.
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: AppTheme.verdeClaro,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(
        Icons.restaurant,
        size: 70,
        color: AppTheme.verdePrincipal,
      ),
    );
  }

  Widget _buildRecipeInfo(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoItem(
          context,
          icon: Icons.access_time,
          label: 'Tempo',
          value: _recipe.time,
        ),

        _buildInfoItem(
          context,
          icon: Icons.signal_cellular_alt,
          label: 'Dificuldade',
          value: _recipe.difficulty,
        ),

        _buildInfoItem(
          context,
          icon:
              Icons.local_fire_department_outlined,
          label: 'Por porção',
          value: _recipe.calories,
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            size: 22,
            color: AppTheme.verdePrincipal,
          ),

          const SizedBox(
            height: AppTheme.spacingSm,
          ),

          Text(
            label,
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

          const SizedBox(height: 4),

          Text(
            value,
            textAlign: TextAlign.center,
            style:
                Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildIngredients(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredientes',
          style: Theme.of(context)
              .textTheme
              .headlineMedium,
        ),

        const SizedBox(
          height: AppTheme.spacingMd,
        ),

        ..._recipe.ingredients.map(
          (ingredient) => _buildIngredientItem(
            context,
            ingredient,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientItem(
    BuildContext context,
    String ingredient,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppTheme.spacingSm,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 18,
            color: AppTheme.verdePrincipal,
          ),

          const SizedBox(
            width: AppTheme.spacingSm,
          ),

          Expanded(
            child: Text(
              ingredient,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreparation(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Modo de preparo',
          style: Theme.of(context)
              .textTheme
              .headlineMedium,
        ),

        const SizedBox(
          height: AppTheme.spacingMd,
        ),

        ..._recipe.preparation
            .asMap()
            .entries
            .map(
              (entry) =>
                  _buildPreparationItem(
                context,
                entry.key + 1,
                entry.value,
              ),
            ),
      ],
    );
  }

  Widget _buildPreparationItem(
    BuildContext context,
    int number,
    String step,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppTheme.spacingMd,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppTheme.verdePrincipal,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(
                    color: AppTheme.branco,
                  ),
            ),
          ),

          const SizedBox(
            width: AppTheme.spacingMd,
          ),

          Expanded(
            child: Text(
              step,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}