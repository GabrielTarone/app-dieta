import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/supabase/supabase_auth_service.dart';
import '../../core/theme/app_theme.dart';
import '../main/main_screen.dart';
import '../cadastro/cadastro_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authService = SupabaseAuthService();

  bool _carregando = false;

  bool _senhaVisivel = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _fazerLogin() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text;

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite seu e-mail'),
        ),
      );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite um e-mail válido'),
        ),
      );
      return;
    }

    if (senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite sua senha'),
        ),
      );
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      await _authService.fazerLogin(
        email: email,
        senha: senha,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } on AuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    } catch (e) {
      debugPrint('ERRO AO FAZER LOGIN: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível fazer login.'),
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

                    _buildLogo(context),

                    const SizedBox(height: 32),

                    _buildWelcome(context),

                    const SizedBox(height: 32),

                    _buildEmailField(context),

                    const SizedBox(height: AppTheme.spacingMd),

                    _buildPasswordField(context),

                    const SizedBox(height: 4),

                    _buildForgotPassword(context),

                    const SizedBox(height: AppTheme.spacingMd),

                    _buildLoginButton(context),

                    const SizedBox(height: AppTheme.spacingLg),

                    _buildDivider(context),

                    const SizedBox(height: AppTheme.spacingMd),

                    _buildSocialButtons(context),

                    const SizedBox(height: AppTheme.spacingMd),

                    _buildRegister(context),

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

  Widget _buildLogo(BuildContext context) {
    return Center(
      child: Text(
        'NutriGo',
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
          color: AppTheme.verdePrincipal,
        ),
      ),
    );
  }

  Widget _buildWelcome(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bem-vindo(a) de volta!',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.verdePrincipal,
          ),
        ),

        const SizedBox(height: AppTheme.spacingSm),

        Text(
          'Faça Login para continuar\nsua jornada saudável',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'E-mail',
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        const SizedBox(height: AppTheme.spacingSm),

        SizedBox(
          height: 40,
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Digite seu e-mail',
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
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
      ],
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Senha',
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        const SizedBox(height: AppTheme.spacingSm),

        SizedBox(
          height: 40,
          child: TextField(
            controller: _senhaController,
            obscureText: !_senhaVisivel,
            decoration: InputDecoration(
              hintText: 'Digite sua senha',

              prefixIcon: Icon(
                Icons.lock_outline,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
      ],
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _carregando
            ? null
            : () async {
                final email = _emailController.text.trim();

                if (email.isEmpty ||
                    !email.contains('@') ||
                    !email.contains('.')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Digite um e-mail válido para recuperar sua senha.',
                      ),
                    ),
                  );
                  return;
                }

                setState(() {
                  _carregando = true;
                });

                try {
                  await _authService.recuperarSenha(
                    email: email,
                  );

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Se o e-mail estiver cadastrado, você receberá '
                        'instruções para recuperar sua senha.',
                      ),
                    ),
                  );
                } on AuthException catch (e) {
                  if (!mounted) return;

                  debugPrint(
                    'ERRO AO SOLICITAR RECUPERAÇÃO: ${e.message}',
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Não foi possível solicitar a recuperação. '
                        'Tente novamente mais tarde.',
                      ),
                    ),
                  );
                } catch (e) {
                  debugPrint('ERRO AO RECUPERAR SENHA: $e');

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Não foi possível enviar a solicitação.',
                      ),
                    ),
                  );
                } finally {
                  if (mounted) {
                    setState(() {
                      _carregando = false;
                    });
                  }
                }
              },
        child: Text(
          'Esqueci minha senha',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.verdePrincipal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: _carregando ? null : _fazerLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.verdePrincipal,
          foregroundColor: AppTheme.branco,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Entrar',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppTheme.branco,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            thickness: 1,
            color: AppTheme.cinzaClaro,
          ),
        ),

        const SizedBox(width: AppTheme.spacingMd),

        Text(
          'ou',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textoSecundario,
          ),
        ),

        const SizedBox(width: AppTheme.spacingMd),

        const Expanded(
          child: Divider(
            thickness: 1,
            color: AppTheme.cinzaClaro,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 40,
          child: OutlinedButton.icon(
            onPressed: () {
              // Login com Google será implementado depois
            },
            icon: Icon(
              Icons.g_mobiledata,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            label: Text(
              'Continuar com Google',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              backgroundColor: Theme.of(context).colorScheme.surface,
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(height: AppTheme.spacingSm),

        SizedBox(
          width: double.infinity,
          height: 40,
          child: OutlinedButton.icon(
            onPressed: () {
              // Login com Apple será implementado depois
            },
            icon: Icon(
              Icons.apple,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            label: Text(
              'Continuar com Apple',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              backgroundColor: Theme.of(context).colorScheme.surface,
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegister(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Text(
            'Ainda não tem uma conta?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 4),

          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CadastroPage(),
                ),
              );
            },
            child: Text(
              'Criar conta',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.verdePrincipal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}