abstract interface class AuthService {
  Future<void> criarConta({
    required String nome,
    required String email,
    required String senha,
  });

  Future<void> fazerLogin({
    required String email,
    required String senha,
  });

  Future<void> fazerLoginComGoogle();

  Future<void> sair();
}