import 'package:supabase_flutter/supabase_flutter.dart';

import '../profile_service.dart';

class SupabaseProfileService implements ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<String> buscarNomeUsuarioAtual() async {
    final usuario = _client.auth.currentUser;

    if (usuario == null) {
      throw Exception('Nenhum usuário autenticado.');
    }

    final resposta = await _client
        .from('profiles')
        .select('nome')
        .eq('id', usuario.id)
        .single();

    return resposta['nome'] as String;
  }
}