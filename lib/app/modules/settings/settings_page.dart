import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'settings_controller.dart';

/// Tela de Configurações. Por ora: seleção de tema (Sistema/Claro/Escuro),
/// persistida e aplicada na hora. Vai crescer com outras preferências.
class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Text(
              'Aparência',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Reage à mudança de tema para atualizar o "check" selecionado.
          Obx(
            () => Column(
              children: [
                _themeTile(context, ThemeMode.system, 'Padrão do sistema',
                    Icons.brightness_auto_outlined),
                _themeTile(context, ThemeMode.light, 'Claro',
                    Icons.light_mode_outlined),
                _themeTile(context, ThemeMode.dark, 'Escuro',
                    Icons.dark_mode_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _themeTile(
    BuildContext context,
    ThemeMode mode,
    String label,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final selected = controller.themeMode == mode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: selected
            ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
            : null,
        selected: selected,
        onTap: () => controller.changeTheme(mode),
      ),
    );
  }
}
