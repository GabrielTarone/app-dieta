import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/recipe.dart';
import '../../models/recipe_collection.dart';
import '../collection_service.dart';

class SupabaseCollectionService implements CollectionService {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<RecipeCollection> criarColecao({
    required String nome,
    required List<Recipe> receitas,
  }) async {
    final usuario = _client.auth.currentUser;

    if (usuario == null) {
      throw Exception('Usuário não autenticado.');
    }

    final resposta = await _client
        .from('collections')
        .insert({
          'user_id': usuario.id,
          'name': nome,
        })
        .select('id, name')
        .single();

    final collectionId = resposta['id'].toString();

    final receitasDaColecao = receitas.map((recipe) {
      if (recipe.id != null) {
        return {
          'collection_id': collectionId,
          'recipe_id': recipe.id,
          'demo_recipe_key': null,
        };
      }

      return {
        'collection_id': collectionId,
        'recipe_id': null,
        'demo_recipe_key': recipe.title,
      };
    }).toList();

    if (receitasDaColecao.isNotEmpty) {
      await _client
          .from('collection_recipes')
          .insert(receitasDaColecao);
    }

    return RecipeCollection(
      id: collectionId,
      name: resposta['name'].toString(),
      recipes: receitas,
    );
  }

  @override
  Future<List<RecipeCollection>> buscarColecoes({
    required List<Recipe> receitasDisponiveis,
  }) async {
    final usuario = _client.auth.currentUser;

    if (usuario == null) {
      throw Exception('Usuário não autenticado.');
    }

    final resposta = await _client
        .from('collections')
        .select(
          'id, name, collection_recipes(recipe_id, demo_recipe_key)',
        )
        .eq('user_id', usuario.id)
        .order('created_at');

    return resposta.map<RecipeCollection>((dadosColecao) {
      final vinculos =
          List<Map<String, dynamic>>.from(
        dadosColecao['collection_recipes'] ?? [],
      );

      final receitasDaColecao = <Recipe>[];

      for (final vinculo in vinculos) {
        final recipeId =
            vinculo['recipe_id']?.toString();

        final demoRecipeKey =
            vinculo['demo_recipe_key']?.toString();

        Recipe? receitaEncontrada;

        if (recipeId != null) {
          for (final recipe in receitasDisponiveis) {
            if (recipe.id == recipeId) {
              receitaEncontrada = recipe;
              break;
            }
          }
        } else if (demoRecipeKey != null) {
          for (final recipe in receitasDisponiveis) {
            if (recipe.id == null &&
                recipe.title == demoRecipeKey) {
              receitaEncontrada = recipe;
              break;
            }
          }
        }

        if (receitaEncontrada != null) {
          receitasDaColecao.add(
            receitaEncontrada,
          );
        }
      }

      return RecipeCollection(
        id: dadosColecao['id'].toString(),
        name: dadosColecao['name'].toString(),
        recipes: receitasDaColecao,
      );
    }).toList();
  }

  @override
  Future<RecipeCollection> atualizarColecao({
    required RecipeCollection colecao,
    required String nome,
    required List<Recipe> receitas,
  }) async {
    final collectionId = colecao.id;

    if (collectionId == null) {
      throw Exception('Coleção sem ID.');
    }

    await _client
        .from('collections')
        .update({
          'name': nome,
        })
        .eq('id', collectionId);

    await _client
        .from('collection_recipes')
        .delete()
        .eq('collection_id', collectionId);

    final receitasDaColecao = receitas.map((recipe) {
      if (recipe.id != null) {
        return {
          'collection_id': collectionId,
          'recipe_id': recipe.id,
          'demo_recipe_key': null,
        };
      }

      return {
        'collection_id': collectionId,
        'recipe_id': null,
        'demo_recipe_key': recipe.title,
      };
    }).toList();

    if (receitasDaColecao.isNotEmpty) {
      await _client
          .from('collection_recipes')
          .insert(receitasDaColecao);
    }

    return RecipeCollection(
      id: collectionId,
      name: nome,
      recipes: receitas,
    );
  }

  @override
  Future<void> excluirColecao({
    required RecipeCollection colecao,
  }) async {
    final collectionId = colecao.id;

    if (collectionId == null) {
      throw Exception('Coleção sem ID.');
    }

    await _client
        .from('collections')
        .delete()
        .eq('id', collectionId);
  }
}