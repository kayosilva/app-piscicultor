import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../routes/app_routes.dart';
import '../../shared/data/models/ciclo.dart';
import 'ciclos_controller.dart';

final _fmtData = DateFormat('dd/MM/yyyy');

/// Lista os ciclos (lotes) de um tanque, com iniciar / editar / encerrar
/// (despesca) / excluir. É aqui que o histórico da criação começa a se pendurar.
class CiclosPage extends GetView<CiclosController> {
  const CiclosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ciclos — ${controller.tanque.nome}')),
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
              if (controller.ciclos.isEmpty)
                const _EmptyState()
              else
                ...controller.ciclos.map(
                  (c) => _CicloTile(
                    ciclo: c,
                    onEditar: () => _abrirForm(c),
                    onEncerrar: () => _encerrar(c),
                    onExcluir: () => _confirmarExclusao(c),
                  ),
                ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirForm(null),
        icon: const Icon(Icons.add),
        label: const Text('Novo ciclo'),
      ),
    );
  }

  void _abrirForm(Ciclo? ciclo) =>
      Get.toNamed(AppRoutes.cicloForm, arguments: ciclo);

  /// Encerra (despesca): pede a data e marca o ciclo como encerrado.
  Future<void> _encerrar(Ciclo ciclo) async {
    final data = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: ciclo.dataPovoamento,
      lastDate: DateTime.now(),
      helpText: 'Data da despesca',
    );
    if (data == null) return;
    await controller.encerrar(ciclo, data);
    Get.snackbar('Ciclo encerrado', 'Despesca registrada em ${_fmtData.format(data)}.',
        snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> _confirmarExclusao(Ciclo ciclo) async {
    await Get.defaultDialog(
      title: 'Excluir ciclo',
      middleText: 'Deseja excluir o ciclo de ${ciclo.especie} '
          '(povoado em ${_fmtData.format(ciclo.dataPovoamento)})?',
      textCancel: 'Cancelar',
      textConfirm: 'Excluir',
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.excluir(ciclo);
        Get.back();
      },
    );
  }
}

/// Cabeçalho: tanque + situação do ciclo ativo (ou aviso de que não há nenhum).
class _ResumoCard extends GetView<CiclosController> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ativo = controller.cicloAtivo;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.waves, color: theme.colorScheme.primary, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(controller.tanque.nome, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    ativo == null
                        ? 'Sem ciclo ativo'
                        : 'Ciclo ativo: ${ativo.especie} · '
                            '${ativo.qtdInicial} peixes · '
                            'há ${_diasCorridos(ativo.dataPovoamento)} dias',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: ativo == null
                          ? theme.colorScheme.outline
                          : theme.colorScheme.primary,
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

class _CicloTile extends StatelessWidget {
  const _CicloTile({
    required this.ciclo,
    required this.onEditar,
    required this.onEncerrar,
    required this.onExcluir,
  });

  final Ciclo ciclo;
  final VoidCallback onEditar;
  final VoidCallback onEncerrar;
  final VoidCallback onExcluir;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ativo = ciclo.status == StatusCiclo.ativo;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: ativo
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.set_meal,
            color: ativo
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.outline,
          ),
        ),
        title: Row(
          children: [
            Expanded(child: Text(ciclo.especie)),
            _StatusBadge(status: ciclo.status),
          ],
        ),
        subtitle: Text(_subtitulo()),
        isThreeLine: ciclo.origemAlevinos != null,
        trailing: PopupMenuButton<String>(
          onSelected: (v) {
            switch (v) {
              case 'editar':
                onEditar();
              case 'encerrar':
                onEncerrar();
              case 'excluir':
                onExcluir();
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'editar', child: Text('Editar')),
            if (ativo)
              const PopupMenuItem(
                  value: 'encerrar', child: Text('Encerrar (despesca)')),
            const PopupMenuItem(value: 'excluir', child: Text('Excluir')),
          ],
        ),
      ),
    );
  }

  String _subtitulo() {
    final linhas = <String>[
      'Povoado em ${_fmtData.format(ciclo.dataPovoamento)} · '
          '${ciclo.qtdInicial} peixes',
      if (ciclo.status == StatusCiclo.encerrado && ciclo.dataDespesca != null)
        'Despesca em ${_fmtData.format(ciclo.dataDespesca!)}'
      else
        'Há ${_diasCorridos(ciclo.dataPovoamento)} dias',
    ];
    if (ciclo.origemAlevinos != null) {
      linhas.add('Origem: ${ciclo.origemAlevinos}');
    }
    return linhas.join('\n');
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final StatusCiclo status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ativo = status == StatusCiclo.ativo;
    final fg = ativo ? theme.colorScheme.primary : theme.colorScheme.outline;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: fg.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
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
          Icon(Icons.set_meal, size: 64, color: theme.colorScheme.outline),
          const SizedBox(height: 16),
          Text('Nenhum ciclo neste tanque', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Toque em "Novo ciclo" para registrar um povoamento.',
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

int _diasCorridos(DateTime desde) => DateTime.now().difference(desde).inDays;
