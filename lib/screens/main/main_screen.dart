import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/recipe.dart';
import '../../models/recipe_data.dart';
import '../home/home_page.dart';
import '../receitas/receitas_page.dart';
import '../favoritos/favoritos_page.dart';
import '../perfil/perfil_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  String _categoriaSelecionada = 'Todos';

  final List<Recipe> _favoritos = [];

  late List<Recipe> _todasReceitas;

  late List<Recipe> _minhasReceitas;

  @override
  void initState() {
    super.initState();

    // Criamos uma cópia da lista original.
    // Essa será a lista principal usada pelo app.
    _todasReceitas = List<Recipe>.from(
      receitas,
    );

    // Por enquanto, as 3 primeiras receitas
    // representam as receitas publicadas pelo Ricardo.
    _minhasReceitas =
        _todasReceitas.take(3).toList();
  }

  void _toggleFavorito(Recipe recipe) {
    setState(() {
      if (_favoritos.contains(recipe)) {
        _favoritos.remove(recipe);
      } else {
        _favoritos.add(recipe);
      }
    });
  }

  void _adicionarMinhaReceita(
    Recipe recipe,
  ) {
    setState(() {
      // Adiciona em Minhas receitas.
      _minhasReceitas.add(recipe);

      // Também adiciona na lista geral,
      // usada pela Home e pelo Explorar.
      _todasReceitas.add(recipe);
    });
  }

  void _removerMinhaReceita(
    Recipe recipe,
  ) {
    setState(() {
      // Remove de Minhas receitas.
      _minhasReceitas.remove(recipe);

      // Remove da lista geral.
      _todasReceitas.remove(recipe);

      // Se estiver favoritada,
      // também remove dos favoritos.
      _favoritos.remove(recipe);
    });
  }

  void _editarMinhaReceita(
    Recipe receitaAntiga,
    Recipe receitaEditada,
  ) {
    setState(() {
      // Atualiza em Minhas receitas.
      final indexMinhasReceitas =
          _minhasReceitas.indexOf(
        receitaAntiga,
      );

      if (indexMinhasReceitas != -1) {
        _minhasReceitas[
            indexMinhasReceitas] = receitaEditada;
      }

      // Atualiza na lista geral.
      final indexTodasReceitas =
          _todasReceitas.indexOf(
        receitaAntiga,
      );

      if (indexTodasReceitas != -1) {
        _todasReceitas[
            indexTodasReceitas] = receitaEditada;
      }

      // Se estiver nos favoritos,
      // também troca pela versão editada.
      final indexFavorito =
          _favoritos.indexOf(
        receitaAntiga,
      );

      if (indexFavorito != -1) {
        _favoritos[indexFavorito] =
            receitaEditada;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomePage(
        receitas: _todasReceitas,
        favoritos: _favoritos,
        onFavoriteTap: _toggleFavorito,

        onVerTodasReceitas: () {
          setState(() {
            _categoriaSelecionada = 'Todos';
            _currentIndex = 1;
          });
        },

        onVerTodasCategorias: () {
          setState(() {
            _categoriaSelecionada = 'Todos';
            _currentIndex = 1;
          });
        },

        onCategoryTap: (categoria) {
          setState(() {
            _categoriaSelecionada = categoria;
            _currentIndex = 1;
          });
        },
      ),

      ReceitasPage(
        receitas: _todasReceitas,
        favoritos: _favoritos,
        onFavoriteTap: _toggleFavorito,
        categoriaInicial:
            _categoriaSelecionada,
      ),

      FavoritosPage(
        favoritos: _favoritos,
        onFavoriteTap: _toggleFavorito,
      ),

      PerfilPage(
        favoritos: _favoritos,
        onFavoriteTap: _toggleFavorito,
        minhasReceitas: _minhasReceitas,
        onAdicionarMinhaReceita:
            _adicionarMinhaReceita,
        onRemoverMinhaReceita:
            _removerMinhaReceita,
        onEditarMinhaReceita:
            _editarMinhaReceita,
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex],

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: _currentIndex,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        type:
            BottomNavigationBarType.fixed,

        backgroundColor:
            Theme.of(context)
                .colorScheme
                .surface,

        selectedItemColor:
            AppTheme.verdePrincipal,

        unselectedItemColor:
            Theme.of(context)
                .colorScheme
                .onSurfaceVariant,

        selectedLabelStyle:
            Theme.of(context)
                .textTheme
                .bodyLarge,

        unselectedLabelStyle:
            Theme.of(context)
                .textTheme
                .bodyMedium,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            activeIcon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search_outlined,
            ),
            activeIcon: Icon(
              Icons.search,
            ),
            label: 'Explorar',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_border,
            ),
            activeIcon: Icon(
              Icons.favorite,
            ),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            activeIcon: Icon(
              Icons.person,
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}