import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/recipe_card.dart';
import '../../models/recipe.dart';
import '../../models/recipe_collection.dart';
import '../detalhes_receita/detalhes_receita_page.dart';
import 'criar_colecao_page.dart';
import '../../services/supabase/supabase_collection_service.dart';

class DetalhesColecaoPage extends StatefulWidget {
  final RecipeCollection colecao;
  final List<Recipe> favoritos;
  final void Function(Recipe) onFavoriteTap;

  const DetalhesColecaoPage({
    super.key,
    required this.colecao,
    required this.favoritos,
    required this.onFavoriteTap,
  });

  @override
  State<DetalhesColecaoPage> createState() =>
      _DetalhesColecaoPageState();
}

class _DetalhesColecaoPageState
    extends State<DetalhesColecaoPage> {
  final _collectionService = SupabaseCollectionService();
  late RecipeCollection _colecao;

  @override
  void initState() {
    super.initState();

    _colecao = widget.colecao;
  }

  Future<void> _editarColecao() async {
    final colecaoEditada =
        await Navigator.push<RecipeCollection>(
      context,
      MaterialPageRoute(
        builder: (context) => CriarColecaoPage(
          favoritos: widget.favoritos,
          colecaoExistente: _colecao,
        ),
      ),
    );

    if (colecaoEditada == null) return;

    try {
      final colecaoSalva =
          await _collectionService.atualizarColecao(
        colecao: _colecao,
        nome: colecaoEditada.name,
        receitas: colecaoEditada.recipes,
      );

      if (!mounted) return;

      setState(() {
        _colecao = colecaoSalva;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Coleção atualizada com sucesso!',
          ),
        ),
      );
    } catch (e) {
      debugPrint(
        'ERRO AO ATUALIZAR COLEÇÃO: $e',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível atualizar a coleção.',
          ),
        ),
      );
    }
  }

  Future<void> _confirmarExclusao() async {
    final excluir = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Excluir coleção?',
          ),
          content: Text(
            'A coleção "${_colecao.name}" será excluída. '
            'As receitas continuarão disponíveis nos favoritos.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                'Cancelar',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'Excluir',
              ),
            ),
          ],
        );
      },
    );

    if (excluir != true || !mounted) return;

    try {
      await _collectionService.excluirColecao(
        colecao: _colecao,
      );

      if (!mounted) return;

      Navigator.pop(
        context,
        true,
      );
    } catch (e) {
      debugPrint(
        'ERRO AO EXCLUIR COLEÇÃO: $e',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível excluir a coleção.',
          ),
        ),
      );
    }
  }

  void _voltar() {
    Navigator.pop(
      context,
      _colecao,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _voltar();
        }
      },

      child: Scaffold(
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor,

        appBar: AppBar(
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,

          leading: IconButton(
            onPressed: _voltar,
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),

          title: Text(
            _colecao.name,
            style:
                Theme.of(context).textTheme.titleMedium,
          ),

          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'editar') {
                  _editarColecao();
                }

                if (value == 'excluir') {
                  _confirmarExclusao();
                }
              },

              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: 'editar',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Editar coleção',
                        ),
                      ],
                    ),
                  ),

                  const PopupMenuItem(
                    value: 'excluir',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Excluir coleção',
                        ),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],
        ),

        body: SafeArea(
          child: _colecao.recipes.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: const EdgeInsets.all(
                    AppTheme.spacingLg,
                  ),
                  itemCount: _colecao.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe =
                        _colecao.recipes[index];

                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppTheme.spacingMd,
                      ),
                      child: RecipeCard(
                        recipe: recipe,
                        showCategory: true,
                        isFavorite:
                            widget.favoritos.contains(recipe),

                        onFavoriteTap: () {
                          setState(() {
                            widget.onFavoriteTap(recipe);
                          });
                        },

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetalhesReceitaPage(
                                recipe: recipe,
                                isFavorite: widget
                                    .favoritos
                                    .contains(recipe),
                                onFavoriteTap: () {
                                  setState(() {
                                    widget.onFavoriteTap(
                                      recipe,
                                    );
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 56,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),

            const SizedBox(
              height: AppTheme.spacingMd,
            ),

            Text(
              'Esta coleção está vazia',
              style:
                  Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(
              height: AppTheme.spacingSm,
            ),

            Text(
              'Adicione receitas para encontrá-las aqui.',
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