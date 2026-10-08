import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/data/models/tanque.dart';
import '../../shared/utils/decimal_input.dart';
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
  late final _volumeCtrl = TextEditingController(
    text: formatDecimal(_editando?.volumeM3),
  );
  late final _areaCtrl = TextEditingController(
    text: formatDecimal(_editando?.areaM2),
  );
  late final _alturaCtrl = TextEditingController(
    text: formatDecimal(_editando?.alturaM),
  );
  late TipoTanque _tipo = _editando?.tipo ?? TipoTanque.escavado;
  late MaterialTanque? _material = _editando?.material;
  late SistemaCultivo _sistema =
      _editando?.sistemaCultivo ?? SistemaCultivo.convencional;

  bool _salvando = false;

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _volumeCtrl.dispose();
    _areaCtrl.dispose();
    _alturaCtrl.dispose();
    super.dispose();
  }

  /// Ao mudar área ou altura, sugere o volume (área × altura). O produtor
  /// pode sobrescrever depois; só volta a ser recalculado se mexer em área ou
  /// altura de novo.
  void _sugerirVolume(String _) {
    final volume = Tanque.volumeCalculado(
      areaM2: parseDecimal(_areaCtrl.text),
      alturaM: parseDecimal(_alturaCtrl.text),
    );
    if (volume != null) _volumeCtrl.text = formatDecimal(volume);
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
                  .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                  .toList(),
              onChanged: (t) => setState(() => _tipo = t ?? _tipo),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<MaterialTanque?>(
              initialValue: _material,
              decoration: const InputDecoration(
                labelText: 'Material',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Não informado'),
                ),
                ...MaterialTanque.values.map(
                  (m) => DropdownMenuItem(value: m, child: Text(m.label)),
                ),
              ],
              onChanged: (m) => setState(() => _material = m),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<SistemaCultivo>(
              initialValue: _sistema,
              decoration: const InputDecoration(
                labelText: 'Sistema de cultivo',
                helperText: 'Bioflocos muda as faixas ideais da água',
                border: OutlineInputBorder(),
              ),
              items: SistemaCultivo.values
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                  .toList(),
              onChanged: (s) => setState(() => _sistema = s ?? _sistema),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _areaCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Área (m²)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _sugerirVolume,
                    validator: (v) => _validarNumero(v, 'área'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _alturaCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Altura da água (m)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _sugerirVolume,
                    validator: (v) => _validarNumero(v, 'altura'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _volumeCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Volume (m³)',
                helperText: 'Calculado por área × altura; pode ajustar',
                border: OutlineInputBorder(),
              ),
              validator: (v) => _validarNumero(v, 'volume'),
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
      volumeM3: parseDecimal(_volumeCtrl.text),
      areaM2: parseDecimal(_areaCtrl.text),
      alturaM: parseDecimal(_alturaCtrl.text),
      material: _material,
      sistemaCultivo: _sistema,
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
    return parseDecimal(v) == null ? 'Valor de $campo inválido' : null;
  }
}
