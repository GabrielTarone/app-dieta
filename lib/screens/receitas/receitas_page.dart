import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/search_field.dart';
import '../../core/widgets/recipe_card.dart';
import '../../models/recipe.dart';
import '../detalhes_receita/detalhes_receita_page.dart';

class ReceitasPage extends StatefulWidget {
  final List<Recipe> receitas;
  final List<Recipe> favoritos;
  final void Function(Recipe) onFavoriteTap;
  final String categoriaInicial;

  const ReceitasPage({
    super.key,
    required this.receitas,
    required this.favoritos,
    required this.onFavoriteTap,
    this.categoriaInicial = 'Todos',
  });

  @override
  State<ReceitasPage> createState() =>
      _ReceitasPageState();
}

class _ReceitasPageState
    extends State<ReceitasPage> {
  late String _filtroSelecionado;

  String _busca = '';

  int? _tempoMaximo;

  String? _dificuldadeSelecionada;

  int? _caloriasMaximas;

  String? _dietaSelecionada;

  @override
  void initState() {
    super.initState();

    _filtroSelecionado =
        widget.categoriaInicial;
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

  void _mostrarFiltroTempo(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(
              AppTheme.spacingLg,
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Tempo de preparo',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium,
                ),

                const SizedBox(
                  height:
                      AppTheme.spacingMd,
                ),

                ListTile(
                  title:
                      const Text('Todos'),
                  onTap: () {
                    setState(() {
                      _tempoMaximo = null;
                    });

                    Navigator.pop(
                      context,
                    );
                  },
                ),

                ListTile(
                  title: const Text(
                    'Até 15 minutos',
                  ),
                  onTap: () {
                    setState(() {
                      _tempoMaximo = 15;
                    });

                    Navigator.pop(
                      context,
                    );
                  },
                ),

                ListTile(
                  title: const Text(
                    'Até 30 minutos',
                  ),
                  onTap: () {
                    setState(() {
                      _tempoMaximo = 30;
                    });

                    Navigator.pop(
                      context,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostrarFiltroDificuldade(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(
              AppTheme.spacingLg,
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Dificuldade',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium,
                ),

                const SizedBox(
                  height:
                      AppTheme.spacingMd,
                ),

                ListTile(
                  title:
                      const Text('Todos'),
                  onTap: () {
                    setState(() {
                      _dificuldadeSelecionada =
                          null;
                    });

                    Navigator.pop(
                      context,
                    );
                  },
                ),

                ListTile(
                  title:
                      const Text('Fácil'),
                  onTap: () {
                    setState(() {
                      _dificuldadeSelecionada =
                          'Fácil';
                    });

                    Navigator.pop(
                      context,
                    );
                  },
                ),

                ListTile(
                  title:
                      const Text('Médio'),
                  onTap: () {
                    setState(() {
                      _dificuldadeSelecionada =
                          'Médio';
                    });

                    Navigator.pop(
                      context,
                    );
                  },
                ),

                ListTile(
                  title:
                      const Text('Difícil'),
                  onTap: () {
                    setState(() {
                      _dificuldadeSelecionada =
                          'Difícil';
                    });

                    Navigator.pop(
                      context,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostrarFiltroCalorias(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(
              AppTheme.spacingLg,
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Calorias',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium,
                ),

                const SizedBox(
                  height:
                      AppTheme.spacingMd,
                ),

                ListTile(
                  title:
                      const Text('Todos'),
                  onTap: () {
                    setState(() {
                      _caloriasMaximas =
                          null;
                    });

                    Navigator.pop(
                      context,
                    );
                  },
                ),

                ListTile(
                  title: const Text(
                    'Até 300 kcal',
                  ),
                  onTap: () {
                    setState(() {
                      _caloriasMaximas =
                          300;
                    });

                    Navigator.pop(
                      context,
                    );
                  },
                ),

                ListTile(
                  title: const Text(
                    'Até 400 kcal',
                  ),
                  onTap: () {
                    setState(() {
                      _caloriasMaximas =
                          400;
                    });

                    Navigator.pop(
                      context,
                    );
                  },
                ),

                ListTile(
                  title: const Text(
                    'Até 500 kcal',
                  ),
                  onTap: () {
                    setState(() {
                      _caloriasMaximas =
                          500;
                    });

                    Navigator.pop(
                      context,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostrarFiltroDietas(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(
              AppTheme.spacingLg,
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Dietas',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium,
                ),

                const SizedBox(
                  height:
                      AppTheme.spacingMd,
                ),

                ListTile(
                  title:
                      const Text('Todos'),
                  onTap: () {
                    setState(() {
                      _dietaSelecionada =
                          null;
                    });

                    Navigator.pop(
                      context,
                    );
                  },
                ),

                ListTile(
                  title: const Text(
                    'Vegetariana',
                  ),
                  onTap: () {
                    setState(() {
                      _dietaSelecionada =
                          'Vegetariana';
                    });

                    Navigator.pop(
                      context,
                    );
                  },
                ),

                ListTile(
                  title: const Text(
                    'Sem glúten',
                  ),
                  onTap: () {
                    setState(() {
                      _dietaSelecionada =
                          'Sem glúten';
                    });

                    Navigator.pop(
                      context,
                    );
                  },
                ),

                ListTile(
                  title: const Text(
                    'Sem lactose',
                  ),
                  onTap: () {
                    setState(() {
                      _dietaSelecionada =
                          'Sem lactose';
                    });

                    Navigator.pop(
                      context,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal:
                  AppTheme.spacingLg,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 32,
                ),

                _buildHeader(context),

                const SizedBox(
                  height:
                      AppTheme.spacingLg,
                ),

                SearchField(
                  onChanged: (value) {
                    setState(() {
                      _busca = value;
                    });
                  },
                ),

                const SizedBox(
                  height:
                      AppTheme.spacingLg,
                ),

                _buildFilters(context),

                const SizedBox(
                  height:
                      AppTheme.spacingLg,
                ),

                _buildAdvancedFilters(
                  context,
                ),

                const SizedBox(
                  height:
                      AppTheme.spacingLg,
                ),

                _buildRecipes(context),
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
    return Text(
      'Explorar receitas',
      style: Theme.of(context)
          .textTheme
          .headlineLarge,
    );
  }

  Widget _buildFilters(
    BuildContext context,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterItem(
            context,
            label: 'Todos',
          ),

          const SizedBox(
            width: AppTheme.spacingSm,
          ),

          _buildFilterItem(
            context,
            label: 'Saudáveis',
          ),

          const SizedBox(
            width: AppTheme.spacingSm,
          ),

          _buildFilterItem(
            context,
            label: 'Café da manhã',
          ),

          const SizedBox(
            width: AppTheme.spacingSm,
          ),

          _buildFilterItem(
            context,
            label: 'Almoço',
          ),

          const SizedBox(
            width: AppTheme.spacingSm,
          ),

          _buildFilterItem(
            context,
            label: 'Lanches',
          ),

          const SizedBox(
            width: AppTheme.spacingSm,
          ),

          _buildFilterItem(
            context,
            label: 'Jantar',
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedFilters(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Filtros',
          style: Theme.of(context)
              .textTheme
              .headlineMedium,
        ),

        const SizedBox(
          height: AppTheme.spacingMd,
        ),

        SingleChildScrollView(
          scrollDirection:
              Axis.horizontal,
          child: Row(
            children: [
              _buildAdvancedFilterItem(
                context,
                label:
                    _tempoMaximo == null
                        ? 'Tempo'
                        : 'Até $_tempoMaximo min',
                onTap: () {
                  _mostrarFiltroTempo(
                    context,
                  );
                },
              ),

              const SizedBox(
                width:
                    AppTheme.spacingMd,
              ),

              _buildAdvancedFilterItem(
                context,
                label:
                    _dificuldadeSelecionada ??
                        'Dificuldade',
                onTap: () {
                  _mostrarFiltroDificuldade(
                    context,
                  );
                },
              ),

              const SizedBox(
                width:
                    AppTheme.spacingMd,
              ),

              _buildAdvancedFilterItem(
                context,
                label:
                    _caloriasMaximas ==
                            null
                        ? 'Calorias'
                        : 'Até $_caloriasMaximas kcal',
                onTap: () {
                  _mostrarFiltroCalorias(
                    context,
                  );
                },
              ),

              const SizedBox(
                width:
                    AppTheme.spacingMd,
              ),

              _buildAdvancedFilterItem(
                context,
                label:
                    _dietaSelecionada ??
                        'Dietas',
                onTap: () {
                  _mostrarFiltroDietas(
                    context,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedFilterItem(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal:
              AppTheme.spacingMd,
          vertical:
              AppTheme.spacingSm,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surface,
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium,
        ),
      ),
    );
  }

  Widget _buildFilterItem(
    BuildContext context, {
    required String label,
  }) {
    final bool selected =
        _filtroSelecionado == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _filtroSelecionado =
              label;
        });
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal:
              AppTheme.spacingMd,
          vertical:
              AppTheme.spacingSm,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.verdePrincipal
              : Theme.of(context)
                  .colorScheme
                  .surface,
          borderRadius:
              BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
                color: selected
                    ? AppTheme.branco
                    : Theme.of(context)
                        .colorScheme
                        .onSurface,
                fontWeight: selected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
        ),
      ),
    );
  }

  Widget _buildRecipes(
    BuildContext context,
  ) {
    final receitasFiltradas =
        widget.receitas.where((recipe) {
      final correspondeFiltro =
          _filtroSelecionado ==
                  'Todos' ||
              recipe.category ==
                  _filtroSelecionado;

      final buscaNormalizada =
          _normalizarTexto(_busca);

      final tituloNormalizado =
          _normalizarTexto(
        recipe.title,
      );

      final categoriaNormalizada =
          _normalizarTexto(
        recipe.category,
      );

      final correspondeBusca =
          tituloNormalizado.contains(
                buscaNormalizada,
              ) ||
              categoriaNormalizada
                  .contains(
                buscaNormalizada,
              );

      final correspondeTempo =
          _tempoMaximo == null ||
              recipe.timeMinutes <=
                  _tempoMaximo!;

      final correspondeDificuldade =
          _dificuldadeSelecionada ==
                  null ||
              recipe.difficulty ==
                  _dificuldadeSelecionada;

      final correspondeCalorias =
          _caloriasMaximas == null ||
              recipe.caloriesValue <=
                  _caloriasMaximas!;

      final correspondeDieta =
          _dietaSelecionada == null ||
              recipe.diets.contains(
                _dietaSelecionada,
              );

      return correspondeFiltro &&
          correspondeBusca &&
          correspondeTempo &&
          correspondeDificuldade &&
          correspondeCalorias &&
          correspondeDieta;
    }).toList();

    if (receitasFiltradas.isEmpty) {
      return Center(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            vertical:
                AppTheme.spacingLg,
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

    return Column(
      children:
          receitasFiltradas.map(
        (recipe) {
          return Padding(
            padding:
                const EdgeInsets.only(
              bottom:
                  AppTheme.spacingMd,
            ),
            child: RecipeCard(
              recipe: recipe,
              showCategory: true,

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

                      onFavoriteTap: () {
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
      ).toList(),
    );
  }
}