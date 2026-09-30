import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../services/supabase/supabase_auth_service.dart';
import '../login/login_page.dart';

class RedefinirSenhaPage extends StatefulWidget {
  const RedefinirSenhaPage({super.key});

  @override
  State<RedefinirSenhaPage> createState() => _RedefinirSenhaPageState();
}

class _RedefinirSenhaPageState extends State<RedefinirSenhaPage> {
  final _authService = SupabaseAuthService();

  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;
  bool _carregando = false;

  @override
  void dispose() {
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _salvarNovaSenha() async {
    final novaSenha = _senhaController.text;
    final confirmarSenha = _confirmarSenhaController.text;

    if (novaSenha.isEmpty || confirmarSenha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha os dois campos de senha.'),
        ),
      );
      return;
    }

    if (novaSenha.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A senha deve possuir pelo menos 6 caracteres.'),
        ),
      );
      return;
    }

    if (novaSenha != confirmarSenha) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não coincidem.'),
        ),
      );
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      await _authService.atualizarSenha(
        novaSenha: novaSenha,
      );

      await _authService.sair();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha alterada com sucesso! Faça login novamente.'),
        ),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (route) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;

      debugPrint('ERRO AO ALTERAR SENHA: ${e.message}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    } catch (e) {
      debugPrint('ERRO AO ALTERAR SENHA: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível alterar sua senha.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Redefinir senha'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLg,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 326,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),

                    Text(
                      'Crie uma nova senha',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.verdePrincipal,
                          ),
                    ),

                    const SizedBox(height: AppTheme.spacingSm),

                    Text(
                      'Digite e confirme sua nova senha para continuar.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 32),

                    Text(
                      'Nova senha',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    const SizedBox(height: AppTheme.spacingSm),

                    SizedBox(
                      height: 40,
                      child: TextField(
                        controller: _senhaController,
                        obscureText: !_senhaVisivel,
                        decoration: InputDecoration(
                          hintText: 'Digite sua nova senha',
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _senhaVisivel = !_senhaVisivel;
                              });
                            },
                            icon: Icon(
                              _senhaVisivel
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingMd),

                    Text(
                      'Confirmar nova senha',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    const SizedBox(height: AppTheme.spacingSm),

                    SizedBox(
                      height: 40,
                      child: TextField(
                        controller: _confirmarSenhaController,
                        obscureText: !_confirmarSenhaVisivel,
                        decoration: InputDecoration(
                          hintText: 'Confirme sua nova senha',
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _confirmarSenhaVisivel =
                                    !_confirmarSenhaVisivel;
                              });
                            },
                            icon: Icon(
                              _confirmarSenhaVisivel
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingLg),

                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: _carregando ? null : _salvarNovaSenha,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.verdePrincipal,
                          foregroundColor: AppTheme.branco,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _carregando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Salvar nova senha',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: AppTheme.branco,
                                  ),
                            ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingLg),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}