import '../models/recipe.dart';
import '../models/recipe_collection.dart';

abstract class CollectionService {
  Future<List<RecipeCollection>> buscarColecoes({
    required List<Recipe> receitasDisponiveis,
  });

  Future<RecipeCollection> criarColecao({
    required String nome,
    required List<Recipe> receitas,
  });

  Future<RecipeCollection> atualizarColecao({
    required RecipeCollection colecao,
    required String nome,
    required List<Recipe> receitas,
  });

  Future<void> excluirColecao({
    required RecipeCollection colecao,
  });
}