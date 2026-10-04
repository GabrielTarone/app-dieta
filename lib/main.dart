import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'screens/login/login_page.dart';
import 'screens/redefinir_senha/redefinir_senha_page.dart';
import 'env.dart';
import 'dart:async';
import 'screens/main/main_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  if (Env.supabaseConfigurado) {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabaseAnonKey,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static MyAppState of(BuildContext context) {
    return context.findAncestorStateOfType<MyAppState>()!;
  }

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  late final Stream<AuthState> _authStateChanges;
  StreamSubscription<AuthState>? _authSubscription;

  ThemeMode get themeMode => _themeMode;

  @override
  void initState() {
    super.initState();

    if (Env.supabaseConfigurado) {
      _authStateChanges = Supabase.instance.client.auth.onAuthStateChange;

      _authSubscription = _authStateChanges.listen((data) {
        if (data.event == AuthChangeEvent.passwordRecovery) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) => const RedefinirSenhaPage(),
              ),
            );
          });

          return;
        }

        if (data.event == AuthChangeEvent.signedIn) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final navigator = navigatorKey.currentState;

            if (navigator == null) return;

            navigator.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const MainScreen(),
              ),
              (route) => false,
            );
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void mudarTema(ThemeMode novoTema) {
    setState(() {
      _themeMode = novoTema;
    });
  }

  Widget _telaInicial() {
    if (!Env.supabaseConfigurado) {
      return const LoginPage();
    }

    final sessaoAtual =
        Supabase.instance.client.auth.currentSession;

    if (sessaoAtual != null) {
      return const MainScreen();
    }

    return const LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'NutriGo',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,

      home: _telaInicial(),
    );
  }
}