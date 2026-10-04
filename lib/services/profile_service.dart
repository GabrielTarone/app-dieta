import 'dart:typed_data';

abstract interface class ProfileService {
  Future<String> buscarNomeUsuarioAtual();

  Future<String?> buscarAvatarUsuarioAtual();

  Future<String> atualizarAvatar({
    required Uint8List imagemBytes,
    required String extensao,
  });

  Future<void> removerAvatar();
}