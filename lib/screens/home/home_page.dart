import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/recipe_card.dart';
import '../../core/widgets/search_field.dart';
import '../../models/recipe.dart';
import '../detalhes_receita/detalhes_receita_page.dart';
import '../../services/supabase/supabase_profile_service.dart';

class HomePage extends StatefulWidget {
  final List<Recipe> receitas;
  final List<Recipe> favoritos;
  final void Function(Recipe) onFavoriteTap;
  final VoidCallback onVerTodasReceitas;
  final VoidCallback onVerTodasCategorias;
  final void Function(String) onCategoryTap;

  const HomePage({
    super.key,
    required this.receitas,
    required this.favoritos,
    required this.onFavoriteTap,
    required this.onVerTodasReceitas,
    required this.onVerTodasCategorias,
    required this.onCategoryTap,
  });

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _profileService = SupabaseProfileService();

  String _busca = '';
  String _nomeUsuario = '';

  @override
  void initState() {
    super.initState();
    _carregarNomeUsuario();
  }

  Future<void> _carregarNomeUsuario() async {
    try {
      final nome = await _profileService.buscarNomeUsuarioAtual();

      if (!mounted) return;

      setState(() {
        _nomeUsuario = nome;
      });
    } catch (e) {
      debugPrint('ERRO AO CARREGAR PERFIL: $e');
    }
  }

  String _normalizarTexto(String texto) {
    return texto
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('â', 'a')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ç', 'c');
  }

  @override
  Widget build(BuildContext context) {
    final buscaNormalizada =
        _normalizarTexto(_busca);

    final receitasFiltradas =
        widget.receitas.where((recipe) {
      final tituloNormalizado =
          _normalizarTexto(recipe.title);

      final categoriaNormalizada =
          _normalizarTexto(recipe.category);

      return tituloNormalizado
              .contains(buscaNormalizada) ||
          categoriaNormalizada
              .contains(buscaNormalizada);
    }).toList();

    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLg,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),

                _buildHeader(context),

                const SizedBox(
                  height: AppTheme.spacingLg,
                ),

                SearchField(
                  onChanged: (value) {
                    setState(() {
                      _busca = value;
                    });
                  },
                ),

                const SizedBox(
                  height: AppTheme.spacingLg,
                ),

                _buildCategoriesHeader(context),

                const SizedBox(
                  height: AppTheme.spacingMd,
                ),

                _buildCategories(context),

                const SizedBox(
                  height: AppTheme.spacingLg,
                ),

                _buildRecipesHeader(context),

                const SizedBox(
                  height: AppTheme.spacingMd,
                ),

                if (receitasFiltradas.isEmpty)
                  _buildEmptySearch(context)
                else
                  ...receitasFiltradas
                      .take(3)
                      .map(
                    (recipe) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom:
                              AppTheme.spacingMd,
                        ),
                        child: RecipeCard(
                          recipe: recipe,
                          isFavorite: widget
                              .favoritos
                              .contains(recipe),

                          onFavoriteTap: () {
                            widget.onFavoriteTap(
                              recipe,
                            );
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
                                      .contains(
                                        recipe,
                                      ),
                                  onFavoriteTap:
                                      () {
                                    widget
                                        .onFavoriteTap(
                                      recipe,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                const SizedBox(
                  height: AppTheme.spacingLg,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          _nomeUsuario.isEmpty
              ? 'Olá!'
              : 'Olá, $_nomeUsuario!',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(
                color:
                    AppTheme.verdePrincipal,
              ),
        ),

        const SizedBox(
          height: AppTheme.spacingSm,
        ),

        Text(
          'O que você quer\ncozinhar hoje?',
          style: Theme.of(context)
              .textTheme
              .headlineLarge,
        ),
      ],
    );
  }

  Widget _buildCategoriesHeader(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Categorias',
          style: Theme.of(context)
              .textTheme
              .headlineMedium,
        ),

        TextButton(
          onPressed:
              widget.onVerTodasCategorias,
          child: Text(
            'Ver todas',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
                  color:
                      AppTheme.verdePrincipal,
                  fontWeight:
                      FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategories(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        _buildCategoryItem(
          context,
          icon: Icons.eco_outlined,
          label: 'Saudáveis',
          onTap: () {
            widget.onCategoryTap(
              'Saudáveis',
            );
          },
        ),

        _buildCategoryItem(
          context,
          icon:
              Icons.free_breakfast_outlined,
          label: 'Café da\nmanhã',
          onTap: () {
            widget.onCategoryTap(
              'Café da manhã',
            );
          },
        ),

        _buildCategoryItem(
          context,
          icon:
              Icons.lunch_dining_outlined,
          label: 'Almoço',
          onTap: () {
            widget.onCategoryTap(
              'Almoço',
            );
          },
        ),

        _buildCategoryItem(
          context,
          icon: Icons.cookie_outlined,
          label: 'Lanches',
          onTap: () {
            widget.onCategoryTap(
              'Lanches',
            );
          },
        ),

        _buildCategoryItem(
          context,
          icon:
              Icons.dinner_dining_outlined,
          label: 'Jantar',
          onTap: () {
            widget.onCategoryTap(
              'Jantar',
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            width: 51,
            height: 51,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surface,
              borderRadius:
                  BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color:
                  AppTheme.verdePrincipal,
              size: 24,
            ),
          ),

          const SizedBox(
            height: AppTheme.spacingSm,
          ),

          SizedBox(
            width: 55,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipesHeader(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _busca.isEmpty
              ? 'Receitas para você'
              : 'Resultados da busca',
          style: Theme.of(context)
              .textTheme
              .headlineMedium,
        ),

        TextButton(
          onPressed:
              widget.onVerTodasReceitas,
          child: Text(
            'Ver todas',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
                  color:
                      AppTheme.verdePrincipal,
                  fontWeight:
                      FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptySearch(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          vertical: AppTheme.spacingLg,
        ),
        child: Text(
          'Nenhuma receita encontrada',
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
    );
  }
}