import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/data/models/tanque.dart';
import 'tanques_controller.dart';

/// Formulário de criar/editar tanque. Recebe o tanque a editar via
/// `Get.arguments` (nulo = criação). Reaproveita o [TanquesController] já vivo
/// da lista para salvar e recarregar.
class TanqueFormPage extends StatefulWidget {
  const TanqueFormPage({super.key});

  @override
  State<TanqueFormPage> createState() => _TanqueFormPageState();
}

class _TanqueFormPageState extends State<TanqueFormPage> {
  final _controller = Get.find<TanquesController>();
  final _formKey = GlobalKey<FormState>();

  late final Tanque? _editando = Get.arguments as Tanque?;
  late final _nomeCtrl = TextEditingController(text: _editando?.nome ?? '');
  late final _volumeCtrl =
      TextEditingController(text: _fmt(_editando?.volumeM3));
  late final _areaCtrl = TextEditingController(text: _fmt(_editando?.areaM2));
  late TipoTanque _tipo = _editando?.tipo ?? TipoTanque.escavado;

  bool _salvando = false;

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _volumeCtrl.dispose();
    _areaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando == null ? 'Novo tanque' : 'Editar tanque'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nomeCtrl,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nome *',
                hintText: 'Ex.: Tanque 1',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Informe um nome' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TipoTanque>(
              initialValue: _tipo,
              decoration: const InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(),
              ),
              items: TipoTanque.values
                  .map((t) =>
                      DropdownMenuItem(value: t, child: Text(t.label)))
                  .toList(),
              onChanged: (t) => setState(() => _tipo = t ?? _tipo),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _volumeCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Volume (m³)',
                border: OutlineInputBorder(),
              ),
              validator: (v) => _validarNumero(v, 'volume'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _areaCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Área (m²)',
                border: OutlineInputBorder(),
              ),
              validator: (v) => _validarNumero(v, 'área'),
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

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);
    await _controller.salvar(
      existente: _editando,
      nome: _nomeCtrl.text.trim(),
      tipo: _tipo,
      volumeM3: _parse(_volumeCtrl.text),
      areaM2: _parse(_areaCtrl.text),
    );
    Get.back();
    Get.snackbar(
      'Pronto',
      _editando == null ? 'Tanque criado.' : 'Tanque atualizado.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String? _validarNumero(String? v, String campo) {
    if (v == null || v.trim().isEmpty) return null; // opcional
    return _parse(v) == null ? 'Valor de $campo inválido' : null;
  }

  /// Aceita vírgula ou ponto como separador decimal; vazio vira null.
  double? _parse(String v) {
    final t = v.trim().replaceAll(',', '.');
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }

  String _fmt(double? v) {
    if (v == null) return '';
    return v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();
  }
}
