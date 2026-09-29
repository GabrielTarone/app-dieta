import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth_service.dart';

class SupabaseAuthService implements AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<void> criarConta({
    required String nome,
    required String email,
    required String senha,
  }) async {
    final resposta = await _client.auth.signUp(
      email: email,
      password: senha,
      data: {
        'nome': nome,
      },
    );

    final usuario = resposta.user;

    if (usuario == null) {
      throw Exception('Não foi possível criar o usuário.');
    }
  }

  @override
  Future<void> fazerLogin({
    required String email,
    required String senha,
  }) async {
    await _client.auth.signInWithPassword(
      email: email,
      password: senha,
    );
  }

  @override
  Future<void> sair() async {
    await _client.auth.signOut();
  }
}