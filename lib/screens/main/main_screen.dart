import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/recipe.dart';
import '../../models/recipe_data.dart';
import '../home/home_page.dart';
import '../receitas/receitas_page.dart';
import '../favoritos/favoritos_page.dart';
import '../perfil/perfil_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/supabase/supabase_recipe_service.dart';
import '../../services/supabase/supabase_storage_service.dart';

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

  final _recipeService = SupabaseRecipeService();

  bool _carregandoReceitas = true;

  String _categoriaSelecionada = 'Todos';

  final List<Recipe> _favoritos = [];

  late List<Recipe> _todasReceitas;

  late List<Recipe> _minhasReceitas;

  @override
  void initState() {
    super.initState();

    // Receitas demonstrativas do aplicativo.
    _todasReceitas = List<Recipe>.from(receitas);

    // Será preenchida com as receitas do usuário.
    _minhasReceitas = [];

    _carregarReceitas();
  }

  Future<void> _carregarReceitas() async {
    try {
      final receitasSupabase =
          await _recipeService.listarReceitas();

      final usuarioId =
          Supabase.instance.client.auth.currentUser?.id;

      if (!mounted) return;

      setState(() {
        // Mantém as receitas demonstrativas
        // e adiciona as receitas do banco.
        _todasReceitas = [
          ...receitas,
          ...receitasSupabase,
        ];

        // Somente receitas publicadas pelo usuário.
        _minhasReceitas = receitasSupabase
            .where(
              (receita) => receita.userId == usuarioId,
            )
            .toList();

        _carregandoReceitas = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _carregandoReceitas = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Não foi possível carregar as receitas: $e',
          ),
        ),
      );
    }
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

  Future<void> _removerMinhaReceita(
    Recipe recipe,
  ) async {
    final id = recipe.id;

    if (id == null) {
      throw Exception(
        'Esta receita não possui um ID válido.',
      );
    }

    // Guarda o caminho da foto antes de excluir.
    final caminhoImagem = recipe.imagePath;

    // Primeiro exclui a receita do Supabase.
    await _recipeService.excluirReceita(id);

    // Atualiza as listas locais após a confirmação.
    if (mounted) {
      setState(() {
        _minhasReceitas.removeWhere(
          (item) => item.id == id,
        );

        _todasReceitas.removeWhere(
          (item) => item.id == id,
        );

        _favoritos.removeWhere(
          (item) => item.id == id,
        );
      });
    }

    // Depois tenta excluir a foto do Storage.
    if (caminhoImagem != null &&
        caminhoImagem.isNotEmpty &&
        !caminhoImagem.startsWith('assets/')) {
      try {
        await SupabaseStorageService().excluirImagem(
          caminhoImagem,
        );
      } catch (e) {
        // A receita já foi excluída do banco.
        // Falha na limpeza da foto não desfaz a exclusão.
        debugPrint(
          'Receita excluída, mas não foi possível remover a foto: $e',
        );
      }
    }
  }

  Future<void> _editarMinhaReceita(
    Recipe receitaAntiga,
    Recipe receitaEditada,
  ) async {
    final id = receitaAntiga.id;

    if (id == null) {
      throw Exception('Esta receita não possui um ID válido.');
    }

    final storageService = SupabaseStorageService();

    String? novaImagemPath;

    try {
      // Mantém a imagem antiga por padrão.
      String? caminhoImagem = receitaAntiga.imagePath;

      // Só envia uma foto quando o usuário escolheu outra.
      if (receitaEditada.imageBytes != null) {
        final extensao = storageService.identificarExtensao(
          receitaEditada.imageBytes!,
        );

        novaImagemPath = await storageService.enviarImagem(
          receitaEditada.imageBytes!,
          extensao: extensao,
        );

        caminhoImagem = novaImagemPath;
      }

      // Monta a receita com o caminho definitivo da foto.
      final receitaAtualizada = Recipe(
        id: id,
        userId: receitaAntiga.userId,
        title: receitaEditada.title,
        category: receitaEditada.category,
        imagePath: caminhoImagem,
        imageBytes: null,
        time: receitaEditada.time,
        timeMinutes: receitaEditada.timeMinutes,
        difficulty: receitaEditada.difficulty,
        calories: receitaEditada.calories,
        caloriesValue: receitaEditada.caloriesValue,
        diets: receitaEditada.diets,
        ingredients: receitaEditada.ingredients,
        preparation: receitaEditada.preparation,
      );

      // Atualiza o banco somente após o upload.
      await _recipeService.atualizarReceita(
        id,
        receitaAtualizada,
      );

      if (mounted) {
        setState(() {
          final indexMinhasReceitas =
              _minhasReceitas.indexOf(receitaAntiga);

          if (indexMinhasReceitas != -1) {
            _minhasReceitas[indexMinhasReceitas] =
                receitaAtualizada;
          }

          final indexTodasReceitas =
              _todasReceitas.indexOf(receitaAntiga);

          if (indexTodasReceitas != -1) {
            _todasReceitas[indexTodasReceitas] =
                receitaAtualizada;
          }

          final indexFavorito =
              _favoritos.indexOf(receitaAntiga);

          if (indexFavorito != -1) {
            _favoritos[indexFavorito] =
                receitaAtualizada;
          }
        });
      }

      // Só tenta remover a foto antiga depois
      // de confirmar a atualização do banco.
      final imagemAntiga = receitaAntiga.imagePath;

      if (novaImagemPath != null &&
          imagemAntiga != null &&
          imagemAntiga != novaImagemPath &&
          !imagemAntiga.startsWith('assets/')) {
        try {
          await storageService.excluirImagem(imagemAntiga);
        } catch (e) {
          debugPrint('Não foi possível remover a foto antiga: $e');
        }
      }
    } catch (e) {
      // Se a atualização falhar, remove a nova imagem
      // que foi enviada, evitando arquivo sem uso.
      if (novaImagemPath != null) {
        try {
          await storageService.excluirImagem(novaImagemPath);
        } catch (erroLimpeza) {
          debugPrint(
            'Não foi possível limpar a nova imagem: $erroLimpeza',
          );
        }
      }

      rethrow;
    }
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
      body: _carregandoReceitas
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : screens[_currentIndex],

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