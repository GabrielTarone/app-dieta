import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  final SupabaseClient _client = Supabase.instance.client;

  static const String _bucket = 'receitas';

  Future<String> enviarImagem(
    Uint8List imagemBytes, {
    required String extensao,
  }) async {
    final usuario = _client.auth.currentUser;

    if (usuario == null) {
      throw Exception('Usuário não autenticado.');
    }

    const tamanhoMaximo = 5 * 1024 * 1024;

    if (imagemBytes.isEmpty ||
        imagemBytes.lengthInBytes > tamanhoMaximo) {
      throw Exception(
        'A imagem deve ter até 5 MB.',
      );
    }

    final extensaoNormalizada =
        extensao.toLowerCase().replaceFirst('.', '');

    final contentType = switch (extensaoNormalizada) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => throw Exception(
          'Formato inválido. Use JPG, PNG ou WebP.',
        ),
    };

    final nomeArquivo =
        '${DateTime.now().microsecondsSinceEpoch}_'
        '${imagemBytes.lengthInBytes}.$extensaoNormalizada';

    // A primeira pasta precisa ser o UUID do usuário,
    // conforme as políticas RLS configuradas.
    final caminho = '${usuario.id}/$nomeArquivo';

    await _client.storage.from(_bucket).uploadBinary(
      caminho,
      imagemBytes,
      fileOptions: FileOptions(
        contentType: contentType,
        upsert: false,
      ),
    );

    // Retornamos o caminho para salvar em recipes.image_path.
    return caminho;
  }

  String obterUrlPublica(String caminho) {
    return _client.storage
        .from(_bucket)
        .getPublicUrl(caminho);
  }

  Future<void> excluirImagem(String caminho) async {
    final usuario = _client.auth.currentUser;

    if (usuario == null) {
      throw Exception('Usuário não autenticado.');
    }

    // Evita solicitar exclusão fora da pasta do usuário.
    if (!caminho.startsWith('${usuario.id}/')) {
      throw Exception(
        'Você não tem permissão para excluir esta imagem.',
      );
    }

    final imagensRemovidas =
        await _client.storage.from(_bucket).remove([
      caminho,
    ]);

    // Verifica se o Storage confirmou a remoção.
    final imagemExcluida = imagensRemovidas.any(
      (imagem) => imagem.name == caminho,
    );

    if (!imagemExcluida) {
      throw Exception(
        'O Supabase não confirmou a exclusão da imagem: $caminho',
      );
    }
  }

  String identificarExtensao(Uint8List bytes) {
    if (bytes.length < 12) {
      throw Exception('Imagem inválida.');
    }

    // PNG
    if (bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'png';
    }

    // JPEG
    if (bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF) {
      return 'jpg';
    }

    // WebP
    if (bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return 'webp';
    }

    throw Exception(
      'Formato de imagem não suportado. Use JPG, PNG ou WebP.',
    );
  }
}