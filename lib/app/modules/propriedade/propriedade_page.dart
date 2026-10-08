import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/data/models/propriedade.dart';
import 'propriedade_controller.dart';

/// Tela de dados da propriedade. No MVP é edição da propriedade padrão (nome e
/// localização). Enquanto carrega, mostra spinner; depois, o formulário já
/// preenchido.
class PropriedadePage extends GetView<PropriedadeController> {
  const PropriedadePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Propriedade')),
      body: Obx(() {
        if (controller.carregando.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final prop = controller.propriedade.value;
        if (prop == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'Nenhuma propriedade cadastrada.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        // key pelo id/updatedAt: se o modelo mudar, o form recria com os
        // valores novos nos campos.
        return _PropriedadeForm(
          key: ValueKey('${prop.id}:${prop.updatedAt.toIso8601String()}'),
          propriedade: prop,
        );
      }),
    );
  }
}

class _PropriedadeForm extends StatefulWidget {
  const _PropriedadeForm({super.key, required this.propriedade});

  final Propriedade propriedade;

  @override
  State<_PropriedadeForm> createState() => _PropriedadeFormState();
}

class _PropriedadeFormState extends State<_PropriedadeForm> {
  final _controller = Get.find<PropriedadeController>();
  final _formKey = GlobalKey<FormState>();

  late final _nomeCtrl =
      TextEditingController(text: widget.propriedade.nome);
  late final _localizacaoCtrl =
      TextEditingController(text: widget.propriedade.localizacao ?? '');

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _localizacaoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _nomeCtrl,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Nome *',
              hintText: 'Ex.: Chácara do Ananias',
              border: OutlineInputBorder(),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Informe um nome' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _localizacaoCtrl,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Localização',
              hintText: 'Ex.: Zona rural, município X',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          Obx(
            () => FilledButton.icon(
              onPressed: _controller.salvando.value ? null : _salvar,
              icon: const Icon(Icons.save_outlined),
              label: Text(
                _controller.salvando.value ? 'Salvando...' : 'Salvar',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    final localizacao = _localizacaoCtrl.text.trim();
    await _controller.salvar(
      nome: _nomeCtrl.text.trim(),
      localizacao: localizacao.isEmpty ? null : localizacao,
    );
    Get.snackbar(
      'Pronto',
      'Dados da propriedade atualizados.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
