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

  Future<List<Map<String, dynamic>>> buscarUsuariosSeguindo() async {
    final usuarioAtual = _client.auth.currentUser;

    if (usuarioAtual == null) {
      throw Exception('Usuário não autenticado.');
    }

    final relacionamentos = await _client
        .from('follows')
        .select('following_id')
        .eq('follower_id', usuarioAtual.id);

    if (relacionamentos.isEmpty) {
      return [];
    }

    final idsUsuarios = relacionamentos
        .map<String>(
          (item) => item['following_id'].toString(),
        )
        .toList();

    final perfis = await _client
        .from('profiles')
        .select('id, nome, avatar_url')
        .inFilter('id', idsUsuarios);

    return List<Map<String, dynamic>>.from(perfis);
  }

  Future<List<Map<String, dynamic>>> buscarSeguidores() async {
    final usuarioAtual = _client.auth.currentUser;

    if (usuarioAtual == null) {
      throw Exception('Usuário não autenticado.');
    }

    final relacionamentos = await _client
        .from('follows')
        .select('follower_id')
        .eq('following_id', usuarioAtual.id);

    if (relacionamentos.isEmpty) {
      return [];
    }

    final idsUsuarios = relacionamentos
        .map<String>(
          (item) => item['follower_id'].toString(),
        )
        .toList();

    final perfis = await _client
        .from('profiles')
        .select('id, nome, avatar_url')
        .inFilter('id', idsUsuarios);

    return List<Map<String, dynamic>>.from(perfis);
  }
}