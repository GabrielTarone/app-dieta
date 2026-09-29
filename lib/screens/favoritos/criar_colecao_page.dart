import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/recipe.dart';
import '../../models/recipe_collection.dart';

class CriarColecaoPage extends StatefulWidget {
  final List<Recipe> favoritos;
  final RecipeCollection? colecaoExistente;

  const CriarColecaoPage({
    super.key,
    required this.favoritos,
    this.colecaoExistente,
  });

  @override
  State<CriarColecaoPage> createState() => _CriarColecaoPageState();
}

class _CriarColecaoPageState extends State<CriarColecaoPage> {
  late TextEditingController _nomeController;

  final List<Recipe> _receitasSelecionadas = [];

  bool get _editando => widget.colecaoExistente != null;

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(
      text: widget.colecaoExistente?.name ?? '',
    );

    if (widget.colecaoExistente != null) {
      _receitasSelecionadas.addAll(
        widget.colecaoExistente!.recipes,
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  void _selecionarReceita(
    Recipe recipe,
    bool selecionada,
  ) {
    setState(() {
      if (selecionada) {
        if (!_receitasSelecionadas.contains(recipe)) {
          _receitasSelecionadas.add(recipe);
        }
      } else {
        _receitasSelecionadas.remove(recipe);
      }
    });
  }

  void _salvarColecao() {
    final nome = _nomeController.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Digite um nome para a coleção',
          ),
        ),
      );

      return;
    }

    if (_receitasSelecionadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Selecione pelo menos uma receita',
          ),
        ),
      );

      return;
    }

    final colecao = RecipeCollection(
      name: nome,
      recipes: List.from(_receitasSelecionadas),
    );

    Navigator.pop(
      context,
      colecao,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          _editando ? 'Editar coleção' : 'Nova coleção',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(
            AppTheme.spacingLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nome da coleção',
                style:
                    Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(
                height: AppTheme.spacingSm,
              ),

              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  hintText: 'Ex: Café da manhã',
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(
                height: AppTheme.spacingLg,
              ),

              Text(
                'Selecione as receitas',
                style:
                    Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(
                height: AppTheme.spacingSm,
              ),

              Text(
                'Escolha quais receitas favoritas farão parte desta coleção.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
              ),

              const SizedBox(
                height: AppTheme.spacingMd,
              ),

              Expanded(
                child: widget.favoritos.isEmpty
                    ? Center(
                        child: Text(
                          'Você ainda não possui receitas favoritas.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: widget.favoritos.length,
                        separatorBuilder: (
                          context,
                          index,
                        ) {
                          return const SizedBox(
                            height: AppTheme.spacingSm,
                          );
                        },
                        itemBuilder: (
                          context,
                          index,
                        ) {
                          final recipe =
                              widget.favoritos[index];

                          final selecionada =
                              _receitasSelecionadas
                                  .contains(recipe);

                          return Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface,
                              borderRadius:
                                  BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant,
                              ),
                            ),
                            child: CheckboxListTile(
                              value: selecionada,
                              activeColor:
                                  AppTheme.verdePrincipal,

                              onChanged: (value) {
                                _selecionarReceita(
                                  recipe,
                                  value ?? false,
                                );
                              },

                              title: Text(
                                recipe.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge,
                              ),

                              subtitle: Text(
                                recipe.category,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),

                              controlAffinity:
                                  ListTileControlAffinity
                                      .leading,
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(
                height: AppTheme.spacingMd,
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvarColecao,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppTheme.verdePrincipal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                  child: Text(
                    _editando
                        ? 'Salvar alterações'
                        : 'Criar coleção',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}