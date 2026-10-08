import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../shared/data/models/ciclo.dart';
import 'ciclos_controller.dart';

final _fmtData = DateFormat('dd/MM/yyyy');

/// Formulário de criar/editar ciclo. Recebe o ciclo a editar via
/// `Get.arguments` (nulo = novo povoamento). Reaproveita o [CiclosController]
/// já vivo da lista. O status/despesca não são editados aqui — é papel do
/// "encerrar".
class CicloFormPage extends StatefulWidget {
  const CicloFormPage({super.key});

  @override
  State<CicloFormPage> createState() => _CicloFormPageState();
}

class _CicloFormPageState extends State<CicloFormPage> {
  final _controller = Get.find<CiclosController>();
  final _formKey = GlobalKey<FormState>();

  late final Ciclo? _editando = Get.arguments as Ciclo?;
  late final _especieCtrl =
      TextEditingController(text: _editando?.especie ?? '');
  late final _qtdCtrl = TextEditingController(
      text: _editando == null ? '' : '${_editando.qtdInicial}');
  late final _origemCtrl =
      TextEditingController(text: _editando?.origemAlevinos ?? '');
  late DateTime _dataPovoamento = _editando?.dataPovoamento ?? DateTime.now();

  bool _salvando = false;

  @override
  void dispose() {
    _especieCtrl.dispose();
    _qtdCtrl.dispose();
    _origemCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando == null ? 'Novo ciclo' : 'Editar ciclo'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _especieCtrl,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Espécie *',
                hintText: 'Ex.: Tilápia',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Informe a espécie' : null,
            ),
            const SizedBox(height: 16),
            // Campo de data: só leitura, abre o date picker ao tocar.
            TextFormField(
              readOnly: true,
              controller:
                  TextEditingController(text: _fmtData.format(_dataPovoamento)),
              decoration: const InputDecoration(
                labelText: 'Data do povoamento *',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today_outlined),
              ),
              onTap: _escolherData,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _qtdCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade de alevinos *',
                hintText: 'Ex.: 5000',
                border: OutlineInputBorder(),
              ),
              validator: _validarQtd,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _origemCtrl,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Origem dos alevinos',
                hintText: 'Ex.: Fornecedor X',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _salvando ? null : _salvar,
              icon: const Icon(Icons.save_outlined),
              label: Text(_salvando ? 'Salvando...' : 'Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _escolherData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataPovoamento,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      helpText: 'Data do povoamento',
    );
    if (data != null) setState(() => _dataPovoamento = data);
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);

    final origem = _origemCtrl.text.trim();
    final erro = await _controller.salvar(
      existente: _editando,
      especie: _especieCtrl.text.trim(),
      dataPovoamento: _dataPovoamento,
      qtdInicial: int.parse(_qtdCtrl.text.trim()),
      origemAlevinos: origem.isEmpty ? null : origem,
    );

    if (!mounted) return;
    setState(() => _salvando = false);

    if (erro != null) {
      Get.snackbar('Não foi possível salvar', erro,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    Get.back();
    Get.snackbar(
      'Pronto',
      _editando == null ? 'Ciclo iniciado.' : 'Ciclo atualizado.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String? _validarQtd(String? v) {
    if (v == null || v.trim().isEmpty) return 'Informe a quantidade';
    final n = int.tryParse(v.trim());
    if (n == null) return 'Use apenas números inteiros';
    if (n <= 0) return 'Deve ser maior que zero';
    return null;
  }
}
