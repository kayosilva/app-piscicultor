import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../services/propriedade_atual_service.dart';

/// Menu lateral do app. Centraliza a navegação principal entre seções.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final current = Get.currentRoute;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Logo do app (badge teal com o peixe) — mesma marca do ícone.
                  Image.asset('assets/branding/icon.png', width: 36, height: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Piscicultor', style: theme.textTheme.titleLarge),
                        // Nome da propriedade atual — reativo: acompanha a
                        // edição na tela de Propriedade na hora.
                        Obx(
                          () => Text(
                            Get.find<PropriedadeAtualService>().nome,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 0),
            const SizedBox(height: 8),
            _DrawerItem(
              icon: Icons.dashboard_outlined,
              label: 'Painel',
              route: AppRoutes.dashboard,
              selected: current == AppRoutes.dashboard,
            ),
            _DrawerItem(
              icon: Icons.grid_view_outlined,
              label: 'Tanques',
              route: AppRoutes.tanques,
              selected: current == AppRoutes.tanques,
            ),
            _DrawerItem(
              icon: Icons.home_work_outlined,
              label: 'Propriedade',
              route: AppRoutes.propriedade,
              selected: current == AppRoutes.propriedade,
            ),
            _DrawerItem(
              icon: Icons.settings_outlined,
              label: 'Configurações',
              route: AppRoutes.settings,
              selected: current == AppRoutes.settings,
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.selected,
  });

  final IconData icon;
  final String label;
  final String route;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        selected: selected,
        onTap: () {
          Get.back(); // fecha o drawer
          if (!selected) Get.toNamed(route);
        },
      ),
    );
  }
}
