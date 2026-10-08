import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../shared/widgets/app_drawer.dart';
import 'dashboard_controller.dart';

/// Painel (tela inicial): visão consolidada da propriedade — indicadores no
/// topo e cada tanque com o status do seu ciclo ativo. Tocar num tanque abre
/// os ciclos dele; ao voltar, o painel se atualiza.
class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Painel')),
      body: Obx(() {
        if (controller.carregando.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: controller.carregar,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              Text(
                controller.propriedade.value?.nome ?? 'Propriedade',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _Kpis(),
              const SizedBox(height: 24),
              Text('Tanques', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (controller.resumos.isEmpty)
                const _EmptyState()
              else
                ...controller.resumos.map(
                  (r) => _TanqueStatusCard(
                    resumo: r,
                    onTap: () => _abrirCiclos(r),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  /// Abre os ciclos do tanque e recarrega o painel ao retornar (o ciclo ativo
  /// pode ter mudado lá dentro).
  void _abrirCiclos(ResumoTanque r) {
    Get.toNamed(AppRoutes.ciclos, arguments: r.tanque)
        ?.then((_) => controller.carregar());
  }
}

/// Linha de indicadores: tanques, ocupados e peixes em cultivo.
class _Kpis extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _KpiCard(
            icon: Icons.grid_view_outlined,
            valor: '${controller.totalTanques}',
            rotulo: 'Tanques',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _KpiCard(
            icon: Icons.water_drop_outlined,
            valor: '${controller.tanquesOcupados}',
            rotulo: 'Em cultivo',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _KpiCard(
            icon: Icons.set_meal_outlined,
            valor: _compacto(controller.peixesEmCultivo),
            rotulo: 'Peixes',
          ),
        ),
      ],
    );
  }

  /// Abrevia números grandes (12500 → "12,5 mil") para caber no cartão.
  String _compacto(int n) {
    if (n < 1000) return '$n';
    final milhares = n / 1000;
    final txt = milhares.toStringAsFixed(milhares >= 10 ? 0 : 1);
    return '${txt.replaceAll('.', ',')} mil';
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.icon,
    required this.valor,
    required this.rotulo,
  });

  final IconData icon;
  final String valor;
  final String rotulo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              valor,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              rotulo,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.outline),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TanqueStatusCard extends StatelessWidget {
  const _TanqueStatusCard({required this.resumo, required this.onTap});

  final ResumoTanque resumo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ativo = resumo.cicloAtivo;
    final ocupado = resumo.ocupado;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: ocupado
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.waves,
            color: ocupado
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.outline,
          ),
        ),
        title: Text(resumo.tanque.nome),
        subtitle: Text(
          ativo == null
              ? 'Ocioso · sem ciclo ativo'
              : '${ativo.especie} · ${ativo.qtdInicial} peixes · '
                  'há ${_diasCorridos(ativo.dataPovoamento)} dias',
          style: ativo == null
              ? TextStyle(color: theme.colorScheme.outline)
              : TextStyle(color: theme.colorScheme.primary),
        ),
        trailing: const Icon(Icons.chevron_right),
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
      padding: const EdgeInsets.only(top: 48),
      child: Column(
        children: [
          Icon(Icons.grid_view_outlined,
              size: 64, color: theme.colorScheme.outline),
          const SizedBox(height: 16),
          Text('Nenhum tanque cadastrado',
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Cadastre um tanque para começar a acompanhar a criação.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.outline),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.tanques)
                ?.then((_) => Get.find<DashboardController>().carregar()),
            icon: const Icon(Icons.add),
            label: const Text('Cadastrar tanque'),
          ),
        ],
      ),
    );
  }
}

int _diasCorridos(DateTime desde) => DateTime.now().difference(desde).inDays;
