import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../main.dart';
import '../../services/supabase/supabase_auth_service.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() =>
      _ConfiguracoesPageState();
}

class _ConfiguracoesPageState
    extends State<ConfiguracoesPage> {
  final _authService = SupabaseAuthService();

  bool _notificacoesAtivadas = true;

  String _nomeUsuario = '';
  String _emailUsuario = '';
  List<String> _preferenciasAlimentares = [];

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    final usuario = Supabase.instance.client.auth.currentUser;

    if (usuario == null) return;

    _emailUsuario = usuario.email ?? '';

    try {
      final perfil = await Supabase.instance.client
          .from('profiles')
          .select('nome, preferencias_alimentares, notificacoes_ativadas')
          .eq('id', usuario.id)
          .single();

      if (!mounted) return;

      setState(() {
        _nomeUsuario = perfil['nome']?.toString() ?? '';

        _preferenciasAlimentares =
            List<String>.from(perfil['preferencias_alimentares'] ?? []);

        _notificacoesAtivadas =
            perfil['notificacoes_ativadas'] ?? true;
      });
    } catch (e) {
      debugPrint('ERRO AO CARREGAR PERFIL: $e');
    }
  }

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
                onChanged: (value) async {
                  final usuario =
                      Supabase.instance.client.auth.currentUser;

                  if (usuario == null) return;

                  try {
                    await Supabase.instance.client
                        .from('profiles')
                        .update({
                          'notificacoes_ativadas': value,
                        })
                        .eq('id', usuario.id);

                    if (!mounted) return;

                    setState(() {
                      _notificacoesAtivadas = value;
                    });
                  } catch (e) {
                    debugPrint(
                      'ERRO AO ATUALIZAR NOTIFICAÇÕES: $e',
                    );

                    if (!mounted) return;

                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Não foi possível atualizar as notificações.',
                        ),
                      ),
                    );
                  }
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
                  _mostrarPreferenciasAlimentares(context);
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
                  _mostrarEditarPerfil(context);
                },
              ),

              _buildMenuItem(
                context,
                icon: Icons.lock_outline,
                title: 'Alterar senha',
                onTap: () {
                  _mostrarAlterarSenha(context);
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
                  _mostrarPrivacidade(context);
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
                  _mostrarTermosDeUso(context);
                },
              ),

              _buildMenuItem(
                context,
                icon: Icons.privacy_tip_outlined,
                title: 'Política de privacidade',
                onTap: () {
                  _mostrarPoliticaPrivacidade(context);
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

  void _mostrarAlterarSenha(BuildContext context) {
    final novaSenhaController = TextEditingController();
    final confirmarSenhaController = TextEditingController();

    String? mensagemErro;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
          title: const Text('Alterar senha'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: novaSenhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nova senha',
                ),
              ),

              const SizedBox(height: AppTheme.spacingMd),

              TextField(
                controller: confirmarSenhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar nova senha',
                ),
              ),

              if (mensagemErro != null) ...[
                const SizedBox(height: AppTheme.spacingMd),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    mensagemErro!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),

            ElevatedButton(
              onPressed: () async {
                final novaSenha = novaSenhaController.text.trim();
                final confirmarSenha =
                    confirmarSenhaController.text.trim();

                if (novaSenha.isEmpty || confirmarSenha.isEmpty) {
                  setDialogState(() {
                    mensagemErro = 'Preencha todos os campos.';
                  });
                  return;
                }

                if (novaSenha.length < 6) {
                  setDialogState(() {
                    mensagemErro =
                        'A senha deve ter pelo menos 6 caracteres.';
                  });
                  return;
                }

                if (novaSenha != confirmarSenha) {
                  setDialogState(() {
                    mensagemErro = 'As senhas não coincidem.';
                  });
                  return;
                }

                final navigator = Navigator.of(context);

                try {
                  await _authService.atualizarSenha(
                    novaSenha: novaSenha,
                  );

                  if (!mounted) return;

                  navigator.pop();

                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Senha alterada com sucesso!',
                      ),
                    ),
                  );
                } catch (e) {
                  debugPrint('ERRO AO ALTERAR SENHA: $e');

                  if (!mounted) return;

                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Não foi possível alterar a senha.',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Alterar senha'),
            ),
          ],
        );
      },
    );
  },
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

  void _mostrarEditarPerfil(BuildContext context) {
    final nomeController = TextEditingController(
      text: _nomeUsuario,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar perfil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
              ),

              const SizedBox(height: AppTheme.spacingMd),

              TextField(
                controller: TextEditingController(
                  text: _emailUsuario,
                ),
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final novoNome = nomeController.text.trim();

                if (novoNome.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Digite um nome válido.'),
                    ),
                  );
                  return;
                }

                final usuario = Supabase.instance.client.auth.currentUser;

                if (usuario == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Usuário não autenticado.'),
                    ),
                  );
                  return;
                }

                try {
                  await Supabase.instance.client
                      .from('profiles')
                      .update({
                        'nome': novoNome,
                      })
                      .eq('id', usuario.id);

                  if (!mounted) return;

                  setState(() {
                    _nomeUsuario = novoNome;
                  });

                  if (!context.mounted) return;

                  Navigator.pop(context);

                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Perfil atualizado com sucesso!',
                      ),
                    ),
                  );
                } catch (e) {
                  debugPrint('ERRO AO ATUALIZAR PERFIL: $e');

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Não foi possível atualizar o perfil.',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarPreferenciasAlimentares(BuildContext context) {
    final preferencias = [
      'Vegetariana',
      'Vegana',
      'Sem glúten',
      'Sem lactose',
    ];

    final preferenciasSelecionadas =
      Set<String>.from(_preferenciasAlimentares);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Preferências alimentares',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: preferencias.map((preferencia) {
                    final selecionada =
                        preferenciasSelecionadas.contains(preferencia);

                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(preferencia),
                      value: selecionada,
                      onChanged: (value) {
                        setDialogState(() {
                          if (value == true) {
                            preferenciasSelecionadas.add(preferencia);
                          } else {
                            preferenciasSelecionadas.remove(preferencia);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final usuario =
                        Supabase.instance.client.auth.currentUser;

                    if (usuario == null) return;

                    try {
                      await Supabase.instance.client
                          .from('profiles')
                          .update({
                            'preferencias_alimentares':
                                preferenciasSelecionadas.toList(),
                          })
                          .eq('id', usuario.id);

                      if (!mounted) return;

                      setState(() {
                        _preferenciasAlimentares =
                            preferenciasSelecionadas.toList();
                      });

                      if (!context.mounted) return;

                      Navigator.pop(context);

                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Preferências alimentares salvas com sucesso!',
                          ),
                        ),
                      );
                    } catch (e) {
                      debugPrint(
                        'ERRO AO SALVAR PREFERÊNCIAS ALIMENTARES: $e',
                      );

                      if (!mounted) return;

                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Não foi possível salvar as preferências alimentares.',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _mostrarPrivacidade(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Privacidade'),
          content: const SingleChildScrollView(
            child: Text(
              'No NutriGo, seus dados de conta são utilizados para '
              'identificar seu perfil e permitir o funcionamento dos '
              'recursos personalizados do aplicativo.\n\n'
              'Suas receitas, favoritos, coleções e preferências são '
              'associados à sua conta para que possam ser recuperados '
              'quando você acessar o aplicativo novamente.\n\n'
              'O acesso aos dados é protegido pelas regras de segurança '
              'configuradas no banco de dados.',
            ),
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

  void _mostrarTermosDeUso(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Termos de uso'),
          content: const SingleChildScrollView(
            child: Text(
              'Ao utilizar o NutriGo, o usuário concorda em utilizar '
              'o aplicativo de forma responsável e fornecer informações '
              'adequadas ao publicar receitas.\n\n'
              'O conteúdo cadastrado pelo usuário é de sua responsabilidade. '
              'O NutriGo oferece recursos para descobrir, organizar, '
              'favoritar e compartilhar receitas dentro da experiência '
              'proposta pelo aplicativo.\n\n'
              'Este projeto possui finalidade acadêmica e demonstrativa.',
            ),
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

  void _mostrarPoliticaPrivacidade(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Política de privacidade'),
          content: const SingleChildScrollView(
            child: Text(
              'O NutriGo utiliza informações de autenticação e perfil '
              'para disponibilizar os recursos vinculados à conta do usuário.\n\n'
              'Entre os dados utilizados pelo aplicativo estão nome, e-mail, '
              'preferências alimentares, receitas, favoritos, coleções e '
              'configurações relacionadas à experiência no aplicativo.\n\n'
              'As informações são armazenadas no Supabase e protegidas '
              'pelas regras de acesso configuradas para o projeto.\n\n'
              'Este aplicativo foi desenvolvido para fins acadêmicos.',
            ),
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
            child: RadioGroup<ThemeMode>(
              groupValue: temaAtual,
              onChanged: (value) {
                if (value != null) {
                  MyApp.of(context).mudarTema(value);
                  Navigator.pop(context);
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tema',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: AppTheme.spacingMd),

                  const RadioListTile<ThemeMode>(
                    title: Text('Sistema'),
                    value: ThemeMode.system,
                  ),

                  const RadioListTile<ThemeMode>(
                    title: Text('Claro'),
                    value: ThemeMode.light,
                  ),

                  const RadioListTile<ThemeMode>(
                    title: Text('Escuro'),
                    value: ThemeMode.dark,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}