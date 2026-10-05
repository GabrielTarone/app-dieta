import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/recipe_card.dart';
import '../../models/recipe.dart';
import '../detalhes_receita/detalhes_receita_page.dart';
import '../publicar_receita/escolher_categoria_page.dart';
import '../../services/supabase/supabase_recipe_service.dart';
import '../../services/supabase/supabase_storage_service.dart';


class MinhasReceitasPage extends StatefulWidget {
  final List<Recipe> favoritos;
  final void Function(Recipe) onFavoriteTap;

  final List<Recipe> minhasReceitas;
  final void Function(Recipe) onAdicionarMinhaReceita;
  final Future<void> Function(Recipe) onRemoverMinhaReceita;

  final Future<void> Function(
    Recipe receitaAntiga,
    Recipe receitaEditada,
  ) onEditarMinhaReceita;

  const MinhasReceitasPage({
    super.key,
    required this.favoritos,
    required this.onFavoriteTap,
    required this.minhasReceitas,
    required this.onAdicionarMinhaReceita,
    required this.onRemoverMinhaReceita,
    required this.onEditarMinhaReceita,
  });

  @override
  State<MinhasReceitasPage> createState() =>
      _MinhasReceitasPageState();
}

class _MinhasReceitasPageState
    extends State<MinhasReceitasPage> {
  final _recipeService = SupabaseRecipeService();
  final _storageService = SupabaseStorageService();

  Future<void> _novaReceita() async {
    final novaReceita = await Navigator.push<Recipe>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const EscolherCategoriaPage(),
      ),
    );

    if (!mounted || novaReceita == null) return;

    String? caminhoImagemEnviada;

    try {
      // Inicialmente mantém o caminho da receita.
      String? caminhoImagem = novaReceita.imagePath;

      // Se o usuário escolheu uma foto,
      // envia os bytes para o Supabase Storage.
      if (novaReceita.imageBytes != null) {
        final bytes = novaReceita.imageBytes!;

        final extensao =
            _storageService.identificarExtensao(bytes);

        caminhoImagemEnviada =
            await _storageService.enviarImagem(
          bytes,
          extensao: extensao,
        );

        caminhoImagem = caminhoImagemEnviada;
      }

      // Cria a receita com a referência da imagem.
      final receitaParaSalvar = Recipe(
        title: novaReceita.title,
        category: novaReceita.category,
        imagePath: caminhoImagem,
        imageBytes: novaReceita.imageBytes,
        time: novaReceita.time,
        timeMinutes: novaReceita.timeMinutes,
        difficulty: novaReceita.difficulty,
        calories: novaReceita.calories,
        caloriesValue: novaReceita.caloriesValue,
        servings: novaReceita.servings,
        diets: novaReceita.diets,
        ingredients: novaReceita.ingredients,
        preparation: novaReceita.preparation,
      );

      // Salva os dados no PostgreSQL.
      await _recipeService.criarReceita(
        receitaParaSalvar,
      );

      // Cadastro concluído: a imagem agora pertence
      // à receita e não deve ser removida.
      caminhoImagemEnviada = null;

      // Recupera as receitas com seus IDs.
      final receitasSalvas =
          await _recipeService.listarReceitas();

      if (!mounted) return;

      final usuarioId =
          Supabase.instance.client.auth.currentUser?.id;

      final minhasReceitasSalvas = receitasSalvas
          .where(
            (receita) => receita.userId == usuarioId,
          )
          .toList();

      for (final receita in minhasReceitasSalvas) {
        final jaExiste = widget.minhasReceitas.any(
          (item) => item.id == receita.id,
        );

        if (!jaExiste) {
          widget.onAdicionarMinhaReceita(receita);
        }
      }

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Receita e imagem publicadas com sucesso!',
          ),
        ),
      );
    } catch (e) {
      // Se o upload funcionou, mas o cadastro falhou,
      // tenta remover a imagem que ficou sem receita.
      if (caminhoImagemEnviada != null) {
        try {
          await _storageService.excluirImagem(
            caminhoImagemEnviada,
          );
        } catch (_) {
          // A limpeza pode ser tentada novamente depois.
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao publicar receita: $e',
          ),
        ),
      );
    }
  }

  Future<void> _abrirDetalhes(
    Recipe recipe,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetalhesReceitaPage(
          recipe: recipe,
          isFavorite:
              widget.favoritos.contains(recipe),

          onFavoriteTap: () {
            widget.onFavoriteTap(
              recipe,
            );
          },

          podeEditar: true,

          onEditarReceita: (receitaEditada) async {
            await widget.onEditarMinhaReceita(
              recipe,
              receitaEditada,
            );
          },
        ),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _confirmarExclusao(
    Recipe recipe,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Excluir receita?',
          ),
          content: Text(
            'Tem certeza que deseja excluir '
            '"${recipe.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Cancelar',
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text(
                'Excluir',
              ),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      try {
        await widget.onRemoverMinhaReceita(recipe);

        if (!mounted) return;

        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Receita excluída com sucesso!',
            ),
          ),
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao excluir receita: $e',
            ),
          ),
        );
      }
    }
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
          'Minhas receitas',
          style:
              Theme.of(context).textTheme.titleMedium,
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spacingLg,
              AppTheme.spacingMd,
              AppTheme.spacingLg,
              0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _novaReceita,
                icon: const Icon(
                  Icons.add,
                ),
                label: const Text(
                  'Nova receita',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppTheme.verdePrincipal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: AppTheme.spacingMd,
          ),

          Expanded(
            child: widget.minhasReceitas.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppTheme.spacingLg,
                      0,
                      AppTheme.spacingLg,
                      AppTheme.spacingLg,
                    ),
                    itemCount:
                        widget.minhasReceitas.length,
                    itemBuilder: (
                      context,
                      index,
                    ) {
                      final recipe =
                          widget.minhasReceitas[index];

                      return Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom:
                              AppTheme.spacingLg,
                        ),
                        child: Column(
                          children: [
                            RecipeCard(
                              recipe: recipe,
                              showCategory: true,
                              isFavorite: widget
                                  .favoritos
                                  .contains(recipe),

                              onFavoriteTap: () {
                                widget.onFavoriteTap(
                                  recipe,
                                );

                                setState(() {});
                              },

                              onTap: () {
                                _abrirDetalhes(
                                  recipe,
                                );
                              },
                            ),

                            const SizedBox(
                              height:
                                  AppTheme.spacingSm,
                            ),

                            Align(
                              alignment:
                                  Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () {
                                  _confirmarExclusao(
                                    recipe,
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                ),
                                label: const Text(
                                  'Excluir',
                                ),
                                style:
                                    TextButton.styleFrom(
                                  foregroundColor:
                                      Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppTheme.spacingLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 56,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),

            const SizedBox(
              height: AppTheme.spacingMd,
            ),

            Text(
              'Nenhuma receita publicada',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium,
            ),

            const SizedBox(
              height: AppTheme.spacingSm,
            ),

            Text(
              'Suas receitas aparecerão aqui.',
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