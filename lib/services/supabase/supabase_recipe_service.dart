import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../../models/recipe.dart';
import '../recipe_service.dart';

class SupabaseRecipeService implements RecipeService {
  final SupabaseClient _client = Supabase.instance.client;

  // Converte os dados do Supabase para o model Recipe.
  Recipe _fromMap(Map<String, dynamic> dados) {
    return Recipe(
      id: dados['id'] as String,
      userId: dados['user_id'] as String,
      title: dados['title'] as String,
      category: dados['category'] as String,
      imagePath: dados['image_path'] as String?,
      time: dados['time'] as String,
      timeMinutes: dados['time_minutes'] as int,
      difficulty: dados['difficulty'] as String,
      calories: dados['calories'] as String,
      caloriesValue: dados['calories_value'] as int,
      servings: (dados['servings'] as num?)?.toInt() ?? 1,
      diets: List<String>.from(dados['diets'] ?? []),
      ingredients: List<String>.from(dados['ingredients'] ?? []),
      preparation: List<String>.from(dados['preparation'] ?? []),
    );
  }

  // Converte uma receita Flutter para os campos do PostgreSQL.
  Map<String, dynamic> _toMap(Recipe receita) {
    return {
      'title': receita.title,
      'category': receita.category,
      'image_path': receita.imagePath,
      'time': receita.time,
      'time_minutes': receita.timeMinutes,
      'difficulty': receita.difficulty,
      'calories': receita.calories,
      'calories_value': receita.caloriesValue,
      'servings': receita.servings,
      'diets': receita.diets,
      'ingredients': receita.ingredients,
      'preparation': receita.preparation,
    };
  }

  // LISTAR: busca receitas publicadas no Supabase.
  @override
  Future<List<Recipe>> listarReceitas() async {
    final resposta = await _client
        .from('recipes')
        .select()
        .order('created_at', ascending: false);

    return resposta.map((dados) => _fromMap(dados)).toList();
  }

  // CRIAR: associa a receita ao usuário autenticado.
  @override
  Future<void> criarReceita(Recipe receita) async {
  final usuario = _client.auth.currentUser;

  if (usuario == null) {
    throw Exception('É necessário estar autenticado.');
  }

  final dados = {
    ..._toMap(receita),
    'user_id': usuario.id,
  };

  final resposta = await _client
      .from('recipes')
      .insert(dados)
      .select('id, title, servings')
      .single();

  debugPrint(
    'DEBUG SUPABASE RESPOSTA → '
    'title=${resposta['title']} | '
    'servings=${resposta['servings']}',
  );
}

  // ATUALIZAR: modifica uma receita existente.
  @override
  Future<void> atualizarReceita(
    String id,
    Recipe receita,
  ) async {
    final usuario = _client.auth.currentUser;

    if (usuario == null) {
      throw Exception('É necessário estar autenticado.');
    }

    final resposta = await _client
        .from('recipes')
        .update(_toMap(receita))
        .eq('id', id)
        .eq('user_id', usuario.id)
        .select('id');

    if (resposta.isEmpty) {
      throw Exception(
        'Receita não encontrada ou sem permissão para editar.',
      );
    }
  }

  // EXCLUIR: remove uma receita existente.
  @override
  Future<void> excluirReceita(String id) async {
    final usuario = _client.auth.currentUser;

    if (usuario == null) {
      throw Exception('É necessário estar autenticado.');
    }

    final resposta = await _client
        .from('recipes')
        .delete()
        .eq('id', id)
        .eq('user_id', usuario.id)
        .select('id');

    if (resposta.isEmpty) {
      throw Exception(
        'Receita não encontrada ou sem permissão para excluir.',
      );
    }
  }
}