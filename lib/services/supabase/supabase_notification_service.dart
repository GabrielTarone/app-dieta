import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseNotificationService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> listarNotificacoes() async {
    final usuario = _client.auth.currentUser;

    if (usuario == null) {
      throw Exception('Usuário não autenticado.');
    }

    // 1. Busca somente as notificações.
    final resultadoNotificacoes = await _client
        .from('notifications')
        .select(
          'id, user_id, actor_id, type, recipe_id, is_read, created_at',
        )
        .eq('user_id', usuario.id)
        .order('created_at', ascending: false);

    final notificacoes =
        List<Map<String, dynamic>>.from(resultadoNotificacoes);

    if (notificacoes.isEmpty) {
      return [];
    }

    // 2. Descobre quais usuários aparecem como autores
    // das notificações.
    final actorIds = notificacoes
        .map((notificacao) => notificacao['actor_id'])
        .where((id) => id != null)
        .map((id) => id.toString())
        .toSet()
        .toList();

    // 3. Descobre quais receitas aparecem nas notificações.
    final recipeIds = notificacoes
        .map((notificacao) => notificacao['recipe_id'])
        .where((id) => id != null)
        .map((id) => id.toString())
        .toSet()
        .toList();

    final Map<String, Map<String, dynamic>> perfisPorId = {};
    final Map<String, Map<String, dynamic>> receitasPorId = {};

    // 4. Busca os perfis separadamente.
    if (actorIds.isNotEmpty) {
      final resultadoPerfis = await _client
          .from('profiles')
          .select(
            'id, nome, avatar_url',
          )
          .inFilter(
            'id',
            actorIds,
          );

      for (final perfil
          in List<Map<String, dynamic>>.from(resultadoPerfis)) {
        final id = perfil['id']?.toString();

        if (id != null) {
          perfisPorId[id] = perfil;
        }
      }
    }

    // 5. Busca as receitas separadamente.
    if (recipeIds.isNotEmpty) {
      final resultadoReceitas = await _client
          .from('recipes')
          .select(
            'id, title',
          )
          .inFilter(
            'id',
            recipeIds,
          );

      for (final receita
          in List<Map<String, dynamic>>.from(resultadoReceitas)) {
        final id = receita['id']?.toString();

        if (id != null) {
          receitasPorId[id] = receita;
        }
      }
    }

    // 6. Junta os dados no Flutter.
    for (final notificacao in notificacoes) {
      final actorId = notificacao['actor_id']?.toString();
      final recipeId = notificacao['recipe_id']?.toString();

      notificacao['actor'] =
          actorId == null ? null : perfisPorId[actorId];

      notificacao['recipe'] =
          recipeId == null ? null : receitasPorId[recipeId];
    }

    return notificacoes;
  }

  Future<void> marcarComoLida(
    String notificationId,
  ) async {
    final usuario = _client.auth.currentUser;

    if (usuario == null) {
      throw Exception('Usuário não autenticado.');
    }

    await _client
        .from('notifications')
        .update({
          'is_read': true,
        })
        .eq(
          'id',
          notificationId,
        )
        .eq(
          'user_id',
          usuario.id,
        );
  }

  Future<void> marcarTodasComoLidas() async {
    final usuario = _client.auth.currentUser;

    if (usuario == null) {
      throw Exception('Usuário não autenticado.');
    }

    await _client
        .from('notifications')
        .update({
          'is_read': true,
        })
        .eq(
          'user_id',
          usuario.id,
        )
        .eq(
          'is_read',
          false,
        );
  }
}