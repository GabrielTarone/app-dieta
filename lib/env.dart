import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class Env {
  static String _ler(String chave) {
    if (!dotenv.isInitialized) return '';
    return dotenv.env[chave] ?? '';
  }

  static String get supabaseUrl => _ler('SUPABASE_URL');

  static String get supabaseAnonKey => _ler('SUPABASE_ANON_KEY');

  static bool get supabaseConfigurado =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}