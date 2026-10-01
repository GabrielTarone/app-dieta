import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/recipe_card.dart';
import '../../models/recipe.dart';
import '../../models/recipe_collection.dart';
import '../detalhes_receita/detalhes_receita_page.dart';
import 'criar_colecao_page.dart';
import 'detalhes_colecao_page.dart';
import '../../services/supabase/supabase_collection_service.dart';

class FavoritosPage extends StatefulWidget {
  final List<Recipe> favoritos;
  final void Function(Recipe) onFavoriteTap;
  final bool mostrarVoltar;
  final List<Recipe> receitasDisponiveis;

  const FavoritosPage({
    super.key,
    required this.favoritos,
    required this.onFavoriteTap,
    this.mostrarVoltar = false,
    required this.receitasDisponiveis,
  });

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  String _abaSelecionada = 'Receitas';

  final _collectionService = SupabaseCollectionService();

  final List<RecipeCollection> _colecoes = [];

  @override
  void initState() {
    super.initState();
    _carregarColecoes();
  }

  Future<void> _carregarColecoes() async {
    try {
      final colecoes =
          await _collectionService.buscarColecoes(
        receitasDisponiveis: widget.receitasDisponiveis,
      );

      if (!mounted) return;

      setState(() {
        _colecoes
          ..clear()
          ..addAll(colecoes);
      });
    } catch (e) {
      debugPrint(
        'ERRO AO CARREGAR COLEÇÕES: $e',
      );
    }
  }

  Future<void> _abrirCriarColecao() async {
    final novaColecao = await Navigator.push<RecipeCollection>(
      context,
      MaterialPageRoute(
        builder: (context) => CriarColecaoPage(
          favoritos: widget.favoritos,
        ),
      ),
    );

    if (novaColecao == null) return;

    try {
      final colecaoSalva =
          await _collectionService.criarColecao(
        nome: novaColecao.name,
        receitas: novaColecao.recipes,
      );

      if (!mounted) return;

      setState(() {
        _colecoes.add(colecaoSalva);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Coleção criada com sucesso!',
          ),
        ),
      );
    } catch (e) {
      debugPrint(
        'ERRO AO CRIAR COLEÇÃO: $e',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível criar a coleção.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: widget.mostrarVoltar
          ? AppBar(
              backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              title: Text(
                'Meus favoritos',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          : null,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: widget.mostrarVoltar ? 16 : 32,
                ),

                if (!widget.mostrarVoltar)
                  _buildHeader(context),

                if (!widget.mostrarVoltar)
                  const SizedBox(
                    height: AppTheme.spacingLg,
                  ),

                _buildTabs(context),

                const SizedBox(height: AppTheme.spacingLg),

                _abaSelecionada == 'Receitas'
                    ? _buildFavorites(context)
                    : _buildCollections(context),

                const SizedBox(height: AppTheme.spacingLg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      'Meus favoritos',
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Row(
      children: [
        _buildTab(
          context,
          label: 'Receitas',
        ),

        const SizedBox(width: AppTheme.spacingLg),

        _buildTab(
          context,
          label: 'Coleções',
        ),
      ],
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String label,
  }) {
    final bool selected = _abaSelecionada == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _abaSelecionada = label;
        });
      },
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: selected
                      ? AppTheme.verdePrincipal
                      : Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                ),
          ),

          const SizedBox(height: 6),

          Container(
            width: 70,
            height: 2,
            color: selected
                ? AppTheme.verdePrincipal
                : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildFavorites(BuildContext context) {
    if (widget.favoritos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppTheme.spacingLg,
          ),
          child: Text(
            'Nenhuma receita favoritada',
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
          ),
        ),
      );
    }

    return Column(
      children: widget.favoritos.map((recipe) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: AppTheme.spacingMd,
          ),
          child: RecipeCard(
            recipe: recipe,
            isFavorite: true,
            onFavoriteTap: () {
              widget.onFavoriteTap(recipe);
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetalhesReceitaPage(
                    recipe: recipe,
                    isFavorite:
                        widget.favoritos.contains(recipe),
                    onFavoriteTap: () {
                      widget.onFavoriteTap(recipe);
                    },
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCollections(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _abrirCriarColecao,
            icon: const Icon(
              Icons.add,
            ),
            label: const Text(
              'Nova coleção',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.verdePrincipal,
              side: const BorderSide(
                color: AppTheme.verdePrincipal,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
            ),
          ),
        ),

        const SizedBox(height: AppTheme.spacingLg),

        if (_colecoes.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppTheme.spacingLg,
              ),
              child: Text(
                'Nenhuma coleção criada',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
              ),
            ),
          )
        else
          ..._colecoes.map(
            (colecao) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: AppTheme.spacingMd,
                ),
                child: _buildCollectionCard(
                  context,
                  colecao,
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildCollectionCard(
    BuildContext context,
    RecipeCollection colecao,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingSm,
        ),

        onTap: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalhesColecaoPage(
                colecao: colecao,
                favoritos: widget.favoritos,
                onFavoriteTap: widget.onFavoriteTap,
              ),
            ),
          );

          if (resultado == true) {
            setState(() {
              _colecoes.remove(colecao);
            });

            return;
          }

          if (resultado is RecipeCollection) {
            final index = _colecoes.indexOf(colecao);

            if (index != -1) {
              setState(() {
                _colecoes[index] = resultado;
              });
            }
          }
        },

        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.verdePrincipal.withValues(
              alpha: 0.12,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.bookmark_border,
            color: AppTheme.verdePrincipal,
          ),
        ),

        title: Text(
          colecao.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),

        subtitle: Text(
          colecao.recipes.length == 1
              ? '1 receita'
              : '${colecao.recipes.length} receitas',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:
                    Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),

        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}