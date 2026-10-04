import 'dart:typed_data';

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

    return resposta['nome']?.toString() ?? '';
  }

  @override
  Future<String?> buscarAvatarUsuarioAtual() async {
    final usuario = _client.auth.currentUser;

    if (usuario == null) {
      throw Exception('Nenhum usuário autenticado.');
    }

    final resposta = await _client
        .from('profiles')
        .select('avatar_url')
        .eq('id', usuario.id)
        .single();

    final avatarUrl = resposta['avatar_url']?.toString();

    if (avatarUrl == null || avatarUrl.isEmpty) {
      return null;
    }

    return avatarUrl;
  }

  @override
  Future<String> atualizarAvatar({
    required Uint8List imagemBytes,
    required String extensao,
  }) async {
    final usuario = _client.auth.currentUser;

    if (usuario == null) {
      throw Exception('Nenhum usuário autenticado.');
    }

    final extensaoNormalizada = extensao.toLowerCase();

    final caminho =
        '${usuario.id}/avatar.$extensaoNormalizada';

    String contentType;

    switch (extensaoNormalizada) {
      case 'png':
        contentType = 'image/png';
        break;

      case 'webp':
        contentType = 'image/webp';
        break;

      default:
        contentType = 'image/jpeg';
    }

    await _client.storage.from('avatars').uploadBinary(
          caminho,
          imagemBytes,
          fileOptions: FileOptions(
            contentType: contentType,
            upsert: true,
          ),
        );

    final urlPublica =
        _client.storage.from('avatars').getPublicUrl(caminho);

    final urlComCacheBuster =
        '$urlPublica?v=${DateTime.now().millisecondsSinceEpoch}';

    await _client
        .from('profiles')
        .update({
          'avatar_url': urlComCacheBuster,
        })
        .eq('id', usuario.id);

    return urlComCacheBuster;
  }

  @override
  Future<void> removerAvatar() async {
    final usuario = _client.auth.currentUser;

    if (usuario == null) {
      throw Exception('Nenhum usuário autenticado.');
    }

    final resposta = await _client
        .from('profiles')
        .select('avatar_url')
        .eq('id', usuario.id)
        .single();

    final avatarUrl = resposta['avatar_url']?.toString();

    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      final uri = Uri.parse(avatarUrl);
      final segmentos = uri.pathSegments;

      final indiceAvatars = segmentos.indexOf('avatars');

      if (indiceAvatars != -1 &&
          indiceAvatars + 2 < segmentos.length) {
        final caminho =
            '${segmentos[indiceAvatars + 1]}/${segmentos[indiceAvatars + 2]}';

        await _client.storage.from('avatars').remove([
          caminho,
        ]);
      }
    }

    await _client
        .from('profiles')
        .update({
          'avatar_url': null,
        })
        .eq('id', usuario.id);
  }
}