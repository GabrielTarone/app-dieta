import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/recipe.dart';

class SupabaseFavoriteService {
  final SupabaseClient _client = Supabase.instance.client;

  String get _usuarioId {
    final usuario = _client.auth.currentUser;

    if (usuario == null) {
      throw Exception('Usuário não autenticado.');
    }

    return usuario.id;
  }

  // Identifica receitas demonstrativas de forma estável.
  // A chave será baseada na posição no catálogo original.
  String _chaveDemonstrativa(
    Recipe recipe,
    List<Recipe> receitasDemonstrativas,
  ) {
    final indice = receitasDemonstrativas.indexOf(recipe);

    if (indice == -1) {
      throw Exception(
        'Receita demonstrativa não encontrada.',
      );
    }

    return 'demo_$indice';
  }

  // Carrega os favoritos do usuário.
  Future<List<Map<String, dynamic>>> listarFavoritos() async {
    final resultado = await _client
        .from('favorites')
        .select('recipe_id, demo_recipe_key')
        .eq('user_id', _usuarioId);

    return List<Map<String, dynamic>>.from(resultado);
  }

  // Adiciona um favorito.
  Future<void> adicionarFavorito(
    Recipe recipe,
    List<Recipe> receitasDemonstrativas,
  ) async {
    final dados = <String, dynamic>{
      'user_id': _usuarioId,
    };

    if (recipe.id != null) {
      dados['recipe_id'] = recipe.id;
    } else {
      dados['demo_recipe_key'] = _chaveDemonstrativa(
        recipe,
        receitasDemonstrativas,
      );
    }

    await _client.from('favorites').insert(dados);
  }

  // Remove um favorito.
  Future<void> removerFavorito(
    Recipe recipe,
    List<Recipe> receitasDemonstrativas,
  ) async {
    var consulta = _client
        .from('favorites')
        .delete()
        .eq('user_id', _usuarioId);

    if (recipe.id != null) {
      consulta = consulta.eq('recipe_id', recipe.id!);
    } else {
      consulta = consulta.eq(
        'demo_recipe_key',
        _chaveDemonstrativa(
          recipe,
          receitasDemonstrativas,
        ),
      );
    }

    await consulta;
  }

  // Lista as receitas do usuário atual que receberam curtidas.
  Future<List<Map<String, dynamic>>>
      listarMinhasReceitasCurtidas() async {
    final resultado = await _client.rpc(
      'get_my_liked_recipes',
    );

    return List<Map<String, dynamic>>.from(
      resultado as List,
    );
  }

  // Lista os usuários que curtiram uma receita do usuário atual.
  Future<List<Map<String, dynamic>>> listarQuemCurtiu(
    String recipeId,
  ) async {
    final resultado = await _client.rpc(
      'get_recipe_likers',
      params: {
        'p_recipe_id': recipeId,
      },
    );

    return List<Map<String, dynamic>>.from(
      resultado as List,
    );
  }
}