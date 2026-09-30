import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/recipe.dart';
import '../configuracoes/configuracoes_page.dart';
import '../login/login_page.dart';
import '../minhas_receitas/minhas_receitas_page.dart';
import '../notificacoes/notificacoes_page.dart';
import '../ajuda_suporte/ajuda_suporte_page.dart';
import '../favoritos/favoritos_page.dart';
import '../../services/supabase/supabase_auth_service.dart';

class PerfilPage extends StatelessWidget {
  final List<Recipe> favoritos;
  final void Function(Recipe) onFavoriteTap;

  final List<Recipe> minhasReceitas;
  final void Function(Recipe) onAdicionarMinhaReceita;
  final Future<void> Function(Recipe) onRemoverMinhaReceita;

  final Future<void> Function(
    Recipe receitaAntiga,
    Recipe receitaEditada,
  ) onEditarMinhaReceita;

  const PerfilPage({
    super.key,
    required this.favoritos,
    required this.onFavoriteTap,
    required this.minhasReceitas,
    required this.onAdicionarMinhaReceita,
    required this.onRemoverMinhaReceita,
    required this.onEditarMinhaReceita,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileHeader(context),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingLg,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: AppTheme.spacingMd,
                    ),

                    _buildLevel(context),

                    const SizedBox(
                      height: AppTheme.spacingLg,
                    ),

                    _buildStats(context),

                    const SizedBox(
                      height: AppTheme.spacingLg,
                    ),

                    const Divider(),

                    _buildMenu(context),

                    const SizedBox(
                      height: AppTheme.spacingLg,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 150,
          child: Image.asset(
            'assets/images/Imagem Fundo Superior.png',
            fit: BoxFit.cover,
          ),
        ),

        Transform.translate(
          offset: const Offset(0, -45),
          child: Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppTheme.verdePrincipal,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/Imagem Avatar.png',
                width: 92,
                height: 92,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        Transform.translate(
          offset: const Offset(0, -35),
          child: Column(
            children: [
              Text(
                'Ricardo Mendes',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium,
              ),

              const SizedBox(height: 4),

              Text(
                '@ricardomendes.nutrigo',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLevel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLg,
        vertical: AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: AppTheme.verdeClaro,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        'Nível 3    •    450 pontos',
        style:
            Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.cinzaEscuro,
                ),
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStat(
          context,
          value: '24',
          label: 'Receitas',
        ),
        _buildStat(
          context,
          value: '156',
          label: 'Curtidas',
        ),
        _buildStat(
          context,
          value: '18',
          label: 'Seguindo',
        ),
      ],
    );
  }

  Widget _buildStat(
    BuildContext context, {
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge,
        ),

        const SizedBox(
          height: AppTheme.spacingSm,
        ),

        Text(
          label,
          style:
              Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
        ),
      ],
    );
  }

  Widget _buildMenu(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          context,
          icon: Icons.menu_book_outlined,
          title: 'Minhas receitas',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MinhasReceitasPage(
                  favoritos: favoritos,
                  onFavoriteTap: onFavoriteTap,
                  minhasReceitas: minhasReceitas,
                  onAdicionarMinhaReceita:
                      onAdicionarMinhaReceita,
                  onRemoverMinhaReceita:
                      onRemoverMinhaReceita,
                  onEditarMinhaReceita:
                      onEditarMinhaReceita,
                ),
              ),
            );
          },
        ),

        _buildMenuItem(
          context,
          icon: Icons.favorite_border,
          title: 'Receitas favoritas',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoritosPage(
                  favoritos: favoritos,
                  onFavoriteTap: onFavoriteTap,
                  mostrarVoltar: true,
                ),
              ),
            );
          },
        ),

        const Divider(),

        _buildMenuItem(
          context,
          icon: Icons.settings_outlined,
          title: 'Configurações',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const ConfiguracoesPage(),
              ),
            );
          },
        ),

        _buildMenuItem(
          context,
          icon: Icons.notifications_none,
          title: 'Notificações',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const NotificacoesPage(),
              ),
            );
          },
        ),

        _buildMenuItem(
          context,
          icon: Icons.help_outline,
          title: 'Ajuda e suporte',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const AjudaSuportePage(),
              ),
            );
          },
        ),

        const Divider(),

        _buildMenuItem(
          context,
          icon: Icons.logout,
          title: 'Sair',
          showArrow: false,
          onTap: () async {
            try {
              await SupabaseAuthService().sair();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                (route) => false,
              );
            } catch (e) {
              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Não foi possível sair. Tente novamente.',
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  Theme.of(context).colorScheme.onSurface,
              size: 26,
            ),

            const SizedBox(
              width: AppTheme.spacingMd,
            ),

            Expanded(
              child: Text(
                title,
                style:
                    Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            if (showArrow)
              Icon(
                Icons.chevron_right,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}