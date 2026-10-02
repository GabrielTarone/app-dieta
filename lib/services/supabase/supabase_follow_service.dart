import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFollowService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<bool> estaSeguindo(String usuarioId) async {
    final usuarioAtual = _client.auth.currentUser;

    if (usuarioAtual == null) {
      return false;
    }

    final resposta = await _client
        .from('follows')
        .select('id')
        .eq('follower_id', usuarioAtual.id)
        .eq('following_id', usuarioId)
        .maybeSingle();

    return resposta != null;
  }

  Future<void> seguir(String usuarioId) async {
    final usuarioAtual = _client.auth.currentUser;

    if (usuarioAtual == null) {
      throw Exception('Usuário não autenticado.');
    }

    if (usuarioAtual.id == usuarioId) {
      return;
    }

    await _client.from('follows').insert({
      'follower_id': usuarioAtual.id,
      'following_id': usuarioId,
    });
  }

  Future<void> deixarDeSeguir(String usuarioId) async {
    final usuarioAtual = _client.auth.currentUser;

    if (usuarioAtual == null) {
      throw Exception('Usuário não autenticado.');
    }

    await _client
        .from('follows')
        .delete()
        .eq('follower_id', usuarioAtual.id)
        .eq('following_id', usuarioId);
  }

  Future<String> buscarNomeUsuario(String usuarioId) async {
    final perfil = await _client
        .from('profiles')
        .select('nome')
        .eq('id', usuarioId)
        .maybeSingle();

    return perfil?['nome']?.toString() ?? 'Usuário NutriGo';
  }
}