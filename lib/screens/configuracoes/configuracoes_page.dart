import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../main.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() =>
      _ConfiguracoesPageState();
}

class _ConfiguracoesPageState
    extends State<ConfiguracoesPage> {
  bool _notificacoesAtivadas = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Configurações',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLg,
            vertical: AppTheme.spacingMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(
                context,
                'Preferências',
              ),

              _buildSwitchItem(
                context,
                icon: Icons.notifications_none,
                title: 'Notificações',
                value: _notificacoesAtivadas,
                onChanged: (value) {
                  setState(() {
                    _notificacoesAtivadas = value;
                  });
                },
              ),

              _buildMenuItem(
                context,
                icon: Icons.dark_mode_outlined,
                title: 'Tema',
                onTap: () {
                  _mostrarOpcoesTema(context);
                },
              ),

              _buildMenuItem(
                context,
                icon: Icons.restaurant_menu,
                title: 'Preferências alimentares',
                onTap: () {
                  // Implementaremos depois
                },
              ),

              const SizedBox(height: AppTheme.spacingLg),

              _buildSectionTitle(
                context,
                'Conta',
              ),

              _buildMenuItem(
                context,
                icon: Icons.person_outline,
                title: 'Editar perfil',
                onTap: () {
                  // Implementaremos depois
                },
              ),

              _buildMenuItem(
                context,
                icon: Icons.lock_outline,
                title: 'Alterar senha',
                onTap: () {
                  // Implementaremos depois
                },
              ),

              const SizedBox(height: AppTheme.spacingLg),

              _buildSectionTitle(
                context,
                'Privacidade',
              ),

              _buildMenuItem(
                context,
                icon: Icons.shield_outlined,
                title: 'Privacidade',
                onTap: () {
                  // Implementaremos depois
                },
              ),

              const SizedBox(height: AppTheme.spacingLg),

              _buildSectionTitle(
                context,
                'Sobre',
              ),

              _buildMenuItem(
                context,
                icon: Icons.info_outline,
                title: 'Sobre o NutriGo',
                onTap: () {
                  _mostrarSobre(context);
                },
              ),

              _buildMenuItem(
                context,
                icon: Icons.description_outlined,
                title: 'Termos de uso',
                onTap: () {
                  // Implementaremos depois
                },
              ),

              _buildMenuItem(
                context,
                icon: Icons.privacy_tip_outlined,
                title: 'Política de privacidade',
                onTap: () {
                  // Implementaremos depois
                },
              ),

              _buildVersionItem(context),

              const SizedBox(height: AppTheme.spacingLg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppTheme.spacingSm,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: AppTheme.verdePrincipal,
        ),
      ),
    );
  }

  Widget _buildSwitchItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppTheme.spacingSm,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.onSurface,
            size: 26,
          ),

          const SizedBox(width: AppTheme.spacingMd),

          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          Switch(
            value: value,
            activeThumbColor: AppTheme.verdePrincipal,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurface,
              size: 26,
            ),

            const SizedBox(width: AppTheme.spacingMd),

            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      child: Row(
        children: [
          Icon(
            Icons.apps_outlined,
            color: Theme.of(context).colorScheme.onSurface,
            size: 26,
          ),

          const SizedBox(width: AppTheme.spacingMd),

          Expanded(
            child: Text(
              'Versão',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          Text(
            '1.0.0',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarSobre(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('NutriGo'),
          content: const Text(
            'Aplicativo de receitas desenvolvido para facilitar '
            'a descoberta e organização de receitas.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarOpcoesTema(BuildContext context) {
    final temaAtual = MyApp.of(context).themeMode;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tema',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                const SizedBox(height: AppTheme.spacingMd),

                RadioListTile<ThemeMode>(
                  title: const Text('Sistema'),
                  value: ThemeMode.system,
                  groupValue: temaAtual,
                  onChanged: (value) {
                    if (value != null) {
                      MyApp.of(context).mudarTema(value);
                      Navigator.pop(context);
                    }
                  },
                ),

                RadioListTile<ThemeMode>(
                  title: const Text('Claro'),
                  value: ThemeMode.light,
                  groupValue: temaAtual,
                  onChanged: (value) {
                    if (value != null) {
                      MyApp.of(context).mudarTema(value);
                      Navigator.pop(context);
                    }
                  },
                ),

                RadioListTile<ThemeMode>(
                  title: const Text('Escuro'),
                  value: ThemeMode.dark,
                  groupValue: temaAtual,
                  onChanged: (value) {
                    if (value != null) {
                      MyApp.of(context).mudarTema(value);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}