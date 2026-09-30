import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_theme.dart';
import '../../models/recipe.dart';
import '../publicar_receita/publicar_receita_page.dart';
import '../../services/supabase/supabase_storage_service.dart';
import '../../services/supabase/supabase_recipe_service.dart';

class DetalhesReceitaPage extends StatefulWidget {
  final Recipe recipe;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  final bool podeEditar;
  final Future<void> Function(Recipe)? onEditarReceita;

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

    if (!mounted || receitaEditada == null) return;

    try {
      final salvar = widget.onEditarReceita;

      if (salvar == null) {
        throw Exception('Não foi possível acessar a edição.');
      }

      // Salva a edição no Supabase.
      await salvar(receitaEditada);

      // Busca a receita com o caminho atualizado da foto.
      final receitasAtualizadas =
          await SupabaseRecipeService().listarReceitas();

      final receitaAtualizada = receitasAtualizadas.firstWhere(
        (receita) => receita.id == _recipe.id,
        orElse: () => throw Exception(
          'Não foi possível localizar a receita atualizada.',
        ),
      );

      if (!mounted) return;

      setState(() {
        _recipe = receitaAtualizada;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Receita atualizada com sucesso!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar receita: $e'),
        ),
      );
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
    Widget imagem;

    // 1. Imagem temporária da galeria.
    if (_recipe.imageBytes != null) {
      imagem = Image.memory(
        _recipe.imageBytes!,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
      );
    }

    // 2. Receita sem imagem.
    else if (_recipe.imagePath == null ||
        _recipe.imagePath!.isEmpty) {
      imagem = const Center(
        child: Icon(
          Icons.restaurant,
          size: 70,
          color: AppTheme.verdePrincipal,
        ),
      );
    }

    // 3. Imagem demonstrativa dos assets.
    else if (_recipe.imagePath!.startsWith('assets/')) {
      imagem = Image.asset(
        _recipe.imagePath!,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
      );
    }

    // 4. Imagem armazenada no Supabase Storage.
    else {
      final url = SupabaseStorageService()
          .obterUrlPublica(_recipe.imagePath!);

      imagem = Image.network(
        url,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.broken_image_outlined,
              size: 60,
            ),
          );
        },
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: 220,
        color: AppTheme.verdeClaro,
        child: imagem,
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