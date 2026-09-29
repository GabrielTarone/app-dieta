import 'package:flutter/material.dart';

import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_theme.dart';
import '../../models/recipe.dart';

class PublicarReceitaPage extends StatefulWidget {
  final String categoria;

  // Se vier uma receita, estamos editando.
  // Se for null, estamos criando uma nova.
  final Recipe? receitaParaEditar;

  const PublicarReceitaPage({
    super.key,
    required this.categoria,
    this.receitaParaEditar,
  });

  @override
  State<PublicarReceitaPage> createState() =>
      _PublicarReceitaPageState();
}

class _PublicarReceitaPageState
    extends State<PublicarReceitaPage> {
  int _etapaAtual = 1;

  final TextEditingController _nomeController =
      TextEditingController();

  final TextEditingController _tempoController =
      TextEditingController();

  final TextEditingController _caloriasController =
      TextEditingController();

  String _dificuldade = 'Fácil';

  final List<String> _dietasSelecionadas = [];

  final List<TextEditingController>
      _ingredientesControllers = [];

  final List<TextEditingController>
      _preparoControllers = [];

  final ImagePicker _imagePicker = ImagePicker();

  Uint8List? _imagemBytes;

  bool get _estaEditando =>
      widget.receitaParaEditar != null;

  @override
  void initState() {
    super.initState();

    final receita = widget.receitaParaEditar;

    if (receita != null) {
      // Modo edição:
      // preenche os campos com os dados atuais.
      _nomeController.text = receita.title;

      _tempoController.text =
          receita.timeMinutes.toString();

      _caloriasController.text =
          receita.caloriesValue.toString();

      _dificuldade = receita.difficulty;

      _dietasSelecionadas.addAll(
        receita.diets,
      );

      for (final ingrediente
          in receita.ingredients) {
        _ingredientesControllers.add(
          TextEditingController(
            text: ingrediente,
          ),
        );
      }

      for (final etapa in receita.preparation) {
        _preparoControllers.add(
          TextEditingController(
            text: etapa,
          ),
        );
      }
    }

    // Garante pelo menos um campo.
    if (_ingredientesControllers.isEmpty) {
      _ingredientesControllers.add(
        TextEditingController(),
      );
    }

    if (_preparoControllers.isEmpty) {
      _preparoControllers.add(
        TextEditingController(),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _tempoController.dispose();
    _caloriasController.dispose();

    for (final controller
        in _ingredientesControllers) {
      controller.dispose();
    }

    for (final controller
        in _preparoControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  Future<void> _selecionarImagem() async {
    final XFile? imagem =
        await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (imagem == null) {
      return;
    }

    final bytes = await imagem.readAsBytes();

    if (!mounted) {
      return;
    }

    setState(() {
      _imagemBytes = bytes;
    });
  }

  void _continuar() {
    final nome =
        _nomeController.text.trim();

    final tempo =
        _tempoController.text.trim();

    final calorias =
        _caloriasController.text.trim();

    if (nome.isEmpty ||
        tempo.isEmpty ||
        calorias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Preencha todas as informações básicas',
          ),
        ),
      );

      return;
    }

    if (int.tryParse(tempo) == null ||
        int.tryParse(calorias) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tempo e calorias precisam ser números',
          ),
        ),
      );

      return;
    }

    setState(() {
      _etapaAtual = 2;
    });
  }

  void _voltarParaEtapaAnterior() {
    setState(() {
      _etapaAtual = 1;
    });
  }

  void _selecionarDieta(
    String dieta,
    bool selecionada,
  ) {
    setState(() {
      if (selecionada) {
        if (!_dietasSelecionadas.contains(dieta)) {
          _dietasSelecionadas.add(dieta);
        }
      } else {
        _dietasSelecionadas.remove(dieta);
      }
    });
  }

  void _adicionarIngrediente() {
    setState(() {
      _ingredientesControllers.add(
        TextEditingController(),
      );
    });
  }

  void _removerIngrediente(int index) {
    if (_ingredientesControllers.length == 1) {
      return;
    }

    setState(() {
      _ingredientesControllers[index].dispose();

      _ingredientesControllers.removeAt(
        index,
      );
    });
  }

  void _adicionarEtapaPreparo() {
    setState(() {
      _preparoControllers.add(
        TextEditingController(),
      );
    });
  }

  void _removerEtapaPreparo(int index) {
    if (_preparoControllers.length == 1) {
      return;
    }

    setState(() {
      _preparoControllers[index].dispose();

      _preparoControllers.removeAt(
        index,
      );
    });
  }

  void _salvarReceita() {
    final ingredientes =
        _ingredientesControllers
            .map(
              (controller) =>
                  controller.text.trim(),
            )
            .where(
              (ingrediente) =>
                  ingrediente.isNotEmpty,
            )
            .toList();

    final preparo =
        _preparoControllers
            .map(
              (controller) =>
                  controller.text.trim(),
            )
            .where(
              (etapa) => etapa.isNotEmpty,
            )
            .toList();

    if (ingredientes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Adicione pelo menos um ingrediente',
          ),
        ),
      );

      return;
    }

    if (preparo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Adicione pelo menos uma etapa de preparo',
          ),
        ),
      );

      return;
    }

    final tempo = int.parse(
      _tempoController.text.trim(),
    );

    final calorias = int.parse(
      _caloriasController.text.trim(),
    );

    final receita = Recipe(
      title: _nomeController.text.trim(),
      category: widget.categoria,

      imagePath:
          widget.receitaParaEditar?.imagePath,

      imageBytes:
          _imagemBytes ??
          widget.receitaParaEditar?.imageBytes,

      time: '$tempo min',
      timeMinutes: tempo,
      difficulty: _dificuldade,
      calories: '$calorias kcal',
      caloriesValue: calorias,
      diets: List.from(
        _dietasSelecionadas,
      ),
      ingredients: ingredientes,
      preparation: preparo,
    );

    Navigator.pop(
      context,
      receita,
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

        leading: IconButton(
          onPressed: () {
            if (_etapaAtual == 2) {
              _voltarParaEtapaAnterior();
            } else {
              Navigator.pop(context);
            }
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),

        title: Text(
          _estaEditando
              ? 'Editar receita'
              : 'Publicar receita',
          style:
              Theme.of(context).textTheme.titleMedium,
        ),
      ),

      body: SafeArea(
        child: _etapaAtual == 1
            ? _buildInformacoesBasicas(context)
            : _buildDetalhesReceita(context),
      ),
    );
  }

  Widget _buildImagemReceita(
    BuildContext context,
  ) {
    final receitaAntiga =
        widget.receitaParaEditar;

    final temImagemNova =
        _imagemBytes != null;

    final temImagemAntiga =
        receitaAntiga?.imagePath != null;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _buildLabel(
          context,
          'Foto da receita',
        ),

        const SizedBox(
          height: AppTheme.spacingSm,
        ),

        GestureDetector(
          onTap: _selecionarImagem,
          child: Container(
            width: double.infinity,
            height: 190,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surface,
              borderRadius:
                  BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: temImagemNova
                ? Image.memory(
                    _imagemBytes!,
                    fit: BoxFit.cover,
                  )
                : temImagemAntiga
                    ? Image.asset(
                        receitaAntiga!
                            .imagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return _buildAdicionarFoto(
                            context,
                          );
                        },
                      )
                    : _buildAdicionarFoto(
                        context,
                      ),
          ),
        ),

        if (temImagemNova ||
            temImagemAntiga) ...[
          const SizedBox(
            height: AppTheme.spacingSm,
          ),

          Center(
            child: TextButton.icon(
              onPressed:
                  _selecionarImagem,
              icon: const Icon(
                Icons.photo_library_outlined,
              ),
              label: const Text(
                'Trocar foto',
              ),
              style: TextButton.styleFrom(
                foregroundColor:
                    AppTheme.verdePrincipal,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAdicionarFoto(
    BuildContext context,
  ) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.add_photo_alternate_outlined,
          size: 42,
          color: AppTheme.verdePrincipal,
        ),

        const SizedBox(
          height: AppTheme.spacingSm,
        ),

        Text(
          'Adicionar foto',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(
                color:
                    AppTheme.verdePrincipal,
              ),
        ),

        const SizedBox(height: 4),

        Text(
          'Escolha uma foto da receita',
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
    );
  }

  Widget _buildInformacoesBasicas(
    BuildContext context,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(
        AppTheme.spacingLg,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            _estaEditando
                ? 'Editar informações'
                : 'Informações básicas',
            style: Theme.of(context)
                .textTheme
                .headlineLarge,
          ),

          const SizedBox(
            height: AppTheme.spacingSm,
          ),

          Text(
            _estaEditando
                ? 'Altere as informações da sua receita.'
                : 'Conte um pouco sobre a sua receita.',
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
            height: AppTheme.spacingLg,
          ),

          _buildImagemReceita(context),

          const SizedBox(
            height: AppTheme.spacingLg,
          ),

          _buildLabel(
            context,
            'Nome da receita',
          ),

          const SizedBox(
            height: AppTheme.spacingSm,
          ),

          TextField(
            controller: _nomeController,
            decoration: _inputDecoration(
              context,
              hintText:
                  'Ex: Frango com legumes',
            ),
          ),

          const SizedBox(
            height: AppTheme.spacingLg,
          ),

          _buildLabel(
            context,
            'Categoria',
          ),

          const SizedBox(
            height: AppTheme.spacingSm,
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMd,
              vertical: 16,
            ),
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
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color:
                      AppTheme.verdePrincipal,
                ),

                const SizedBox(
                  width: AppTheme.spacingSm,
                ),

                Text(
                  widget.categoria,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge,
                ),
              ],
            ),
          ),

          const SizedBox(
            height: AppTheme.spacingLg,
          ),

          _buildLabel(
            context,
            'Tempo de preparo',
          ),

          const SizedBox(
            height: AppTheme.spacingSm,
          ),

          TextField(
            controller: _tempoController,
            keyboardType:
                TextInputType.number,
            decoration: _inputDecoration(
              context,
              hintText: 'Ex: 30',
              suffixText: 'min',
            ),
          ),

          const SizedBox(
            height: AppTheme.spacingLg,
          ),

          _buildLabel(
            context,
            'Dificuldade',
          ),

          const SizedBox(
            height: AppTheme.spacingSm,
          ),

          DropdownButtonFormField<String>(
            initialValue: _dificuldade,
            decoration:
                _inputDecoration(context),
            items: const [
              DropdownMenuItem(
                value: 'Fácil',
                child: Text('Fácil'),
              ),
              DropdownMenuItem(
                value: 'Médio',
                child: Text('Médio'),
              ),
              DropdownMenuItem(
                value: 'Difícil',
                child: Text('Difícil'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _dificuldade = value;
                });
              }
            },
          ),

          const SizedBox(
            height: AppTheme.spacingLg,
          ),

          _buildLabel(
            context,
            'Calorias por porção',
          ),

          const SizedBox(
            height: AppTheme.spacingSm,
          ),

          TextField(
            controller: _caloriasController,
            keyboardType:
                TextInputType.number,
            decoration: _inputDecoration(
              context,
              hintText: 'Ex: 350',
              suffixText: 'kcal',
            ),
          ),

          const SizedBox(
            height: 32,
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _continuar,
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    AppTheme.verdePrincipal,
                foregroundColor:
                    Colors.white,
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 16,
                ),
              ),
              child: const Text(
                'Continuar',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetalhesReceita(
    BuildContext context,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(
        AppTheme.spacingLg,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Detalhes da receita',
            style: Theme.of(context)
                .textTheme
                .headlineLarge,
          ),

          const SizedBox(
            height: AppTheme.spacingSm,
          ),

          Text(
            'Adicione dietas, ingredientes e o modo de preparo.',
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
            height: AppTheme.spacingLg,
          ),

          _buildLabel(
            context,
            'Dietas',
          ),

          const SizedBox(
            height: AppTheme.spacingSm,
          ),

          _buildDieta(
            context,
            'Vegetariana',
          ),

          _buildDieta(
            context,
            'Vegana',
          ),

          _buildDieta(
            context,
            'Sem glúten',
          ),

          _buildDieta(
            context,
            'Sem lactose',
          ),

          const SizedBox(
            height: AppTheme.spacingLg,
          ),

          _buildLabel(
            context,
            'Ingredientes',
          ),

          const SizedBox(
            height: AppTheme.spacingSm,
          ),

          ...List.generate(
            _ingredientesControllers.length,
            (index) {
              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom:
                      AppTheme.spacingSm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller:
                            _ingredientesControllers[
                                index],
                        decoration:
                            _inputDecoration(
                          context,
                          hintText:
                              'Ingrediente ${index + 1}',
                        ),
                      ),
                    ),

                    if (_ingredientesControllers
                            .length >
                        1)
                      IconButton(
                        onPressed: () {
                          _removerIngrediente(
                            index,
                          );
                        },
                        icon: const Icon(
                          Icons.close,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),

          TextButton.icon(
            onPressed:
                _adicionarIngrediente,
            icon: const Icon(
              Icons.add,
            ),
            label: const Text(
              'Adicionar ingrediente',
            ),
            style: TextButton.styleFrom(
              foregroundColor:
                  AppTheme.verdePrincipal,
            ),
          ),

          const SizedBox(
            height: AppTheme.spacingLg,
          ),

          _buildLabel(
            context,
            'Modo de preparo',
          ),

          const SizedBox(
            height: AppTheme.spacingSm,
          ),

          ...List.generate(
            _preparoControllers.length,
            (index) {
              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom:
                      AppTheme.spacingSm,
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(
                        top: 16,
                        right:
                            AppTheme.spacingSm,
                      ),
                      child: Text(
                        '${index + 1}.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge,
                      ),
                    ),

                    Expanded(
                      child: TextField(
                        controller:
                            _preparoControllers[
                                index],
                        minLines: 1,
                        maxLines: 3,
                        decoration:
                            _inputDecoration(
                          context,
                          hintText:
                              'Descreva esta etapa',
                        ),
                      ),
                    ),

                    if (_preparoControllers
                            .length >
                        1)
                      IconButton(
                        onPressed: () {
                          _removerEtapaPreparo(
                            index,
                          );
                        },
                        icon: const Icon(
                          Icons.close,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),

          TextButton.icon(
            onPressed:
                _adicionarEtapaPreparo,
            icon: const Icon(
              Icons.add,
            ),
            label: const Text(
              'Adicionar etapa',
            ),
            style: TextButton.styleFrom(
              foregroundColor:
                  AppTheme.verdePrincipal,
            ),
          ),

          const SizedBox(
            height: 32,
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _salvarReceita,
              icon: Icon(
                _estaEditando
                    ? Icons.save_outlined
                    : Icons.publish_outlined,
              ),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    AppTheme.verdePrincipal,
                foregroundColor:
                    Colors.white,
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 16,
                ),
              ),
              label: Text(
                _estaEditando
                    ? 'Salvar alterações'
                    : 'Publicar receita',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDieta(
    BuildContext context,
    String dieta,
  ) {
    final selecionada =
        _dietasSelecionadas.contains(
      dieta,
    );

    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      value: selecionada,
      activeColor:
          AppTheme.verdePrincipal,
      controlAffinity:
          ListTileControlAffinity.leading,
      title: Text(
        dieta,
        style:
            Theme.of(context).textTheme.bodyMedium,
      ),
      onChanged: (value) {
        _selecionarDieta(
          dieta,
          value ?? false,
        );
      },
    );
  }

  Widget _buildLabel(
    BuildContext context,
    String text,
  ) {
    return Text(
      text,
      style:
          Theme.of(context).textTheme.titleMedium,
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    String? hintText,
    String? suffixText,
  }) {
    return InputDecoration(
      hintText: hintText,
      suffixText: suffixText,
      filled: true,
      fillColor:
          Theme.of(context).colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant,
        ),
      ),
    );
  }
}