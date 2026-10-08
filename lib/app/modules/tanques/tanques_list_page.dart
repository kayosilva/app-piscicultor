import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../shared/data/models/tanque.dart';
import '../../shared/widgets/app_drawer.dart';
import 'tanques_controller.dart';

/// Tela inicial do app: um mini-dashboard (propriedade + total de tanques)
/// seguido da lista de tanques, com criar/editar/excluir. Substitui a antiga
/// Home-placeholder.
class TanquesListPage extends GetView<TanquesController> {
  const TanquesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Tanques')),
      body: Obx(() {
        if (controller.carregando.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: controller.carregar,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              _ResumoCard(),
              const SizedBox(height: 16),
              if (controller.tanques.isEmpty)
                const _EmptyState()
              else
                ...controller.tanques.map(
                  (t) => _TanqueTile(
                    tanque: t,
                    onAbrir: () => _abrirCiclos(t),
                    onEditar: () => _abrirForm(t),
                    onExcluir: () => _confirmarExclusao(t),
                  ),
                ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirForm(null),
        icon: const Icon(Icons.add),
        label: const Text('Novo tanque'),
      ),
    );
  }

  void _abrirForm(Tanque? tanque) =>
      Get.toNamed(AppRoutes.tanqueForm, arguments: tanque);

  void _abrirCiclos(Tanque tanque) =>
      Get.toNamed(AppRoutes.ciclos, arguments: tanque);

  Future<void> _confirmarExclusao(Tanque tanque) async {
    await Get.defaultDialog(
      title: 'Excluir tanque',
      middleText: 'Deseja excluir "${tanque.nome}"?',
      textCancel: 'Cancelar',
      textConfirm: 'Excluir',
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.excluir(tanque);
        Get.back();
      },
    );
  }
}

/// Cartão de resumo no topo (nome da propriedade + contagem de tanques).
class _ResumoCard extends GetView<TanquesController> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined,
                color: theme.colorScheme.primary, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.propriedade.value?.nome ?? 'Propriedade',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${controller.tanques.length} '
                    '${controller.tanques.length == 1 ? 'tanque' : 'tanques'}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TanqueTile extends StatelessWidget {
  const _TanqueTile({
    required this.tanque,
    required this.onAbrir,
    required this.onEditar,
    required this.onExcluir,
  });

  final Tanque tanque;
  final VoidCallback onAbrir;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(Icons.waves, color: theme.colorScheme.onPrimaryContainer),
        ),
        title: Text(tanque.nome),
        subtitle: Text(_subtitulo(tanque)),
        onTap: onAbrir,
        trailing: PopupMenuButton<String>(
          onSelected: (v) => v == 'editar' ? onEditar() : onExcluir(),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'editar', child: Text('Editar')),
            PopupMenuItem(value: 'excluir', child: Text('Excluir')),
          ],
        ),
      ),
    );
  }

  String _subtitulo(Tanque t) {
    final partes = <String>[t.tipo.label];
    if (t.volumeM3 != null) partes.add('${_num(t.volumeM3!)} m³');
    if (t.areaM2 != null) partes.add('${_num(t.areaM2!)} m²');
    return partes.join(' · ');
  }

  /// Formata sem casas decimais desnecessárias (120.0 → "120").
  String _num(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 64),
      child: Column(
        children: [
          Icon(Icons.waves, size: 64, color: theme.colorScheme.outline),
          const SizedBox(height: 16),
          Text('Nenhum tanque cadastrado',
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Toque em "Novo tanque" para começar.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
