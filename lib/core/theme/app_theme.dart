import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Tokens de cor
  static const Color verdePrincipal = Color(0xFF4CAF6A);
  static const Color verdeClaro = Color(0xFFA8D5B2);
  static const Color bege = Color(0xFFE8DCC2);
  static const Color creme = Color(0xFFF5F0E7);
  static const Color branco = Color(0xFFFFFFFF);
  static const Color cinzaEscuro = Color(0xFF333333);
  static const Color cinzaClaro = Color(0xFF8E8E8E);
  static const Color textoSecundario = Color(0xFF70766F);
  static const Color botaoDesabilitado = Color(0xFF70766F);
  static const Color botaoSecundario = Color(0xFF86B88E);
  static const Color corIcones = Color(0xFF4E4747);

  // Tokens de espaçamento
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;

  // Tema Completo
  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: verdePrincipal,
    ),
    scaffoldBackgroundColor: creme,
    useMaterial3: true,

    // Tipografia do NutriGo
    textTheme: GoogleFonts.interTextTheme(
      const TextTheme(
        // Título Logo
        displayLarge: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),

        // Título Chamativo
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),

        // Subtítulo Chamativo
        headlineMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),

        // Subtítulo
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),

        // Texto Normal
        bodyMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),

        // Texto Normal Chamativo
        bodyLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),

        // Texto botão
        labelLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ); 

  static ThemeData get dark => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: verdePrincipal,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    useMaterial3: true,
    textTheme: GoogleFonts.interTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        labelLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}