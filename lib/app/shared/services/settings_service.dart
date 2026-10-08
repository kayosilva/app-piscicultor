import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

/// Serviço de preferências do app, persistidas localmente (Hive).
/// Hoje cuida do tema (claro/escuro/sistema); deve crescer com outras configs.
/// Registrado como permanente no main, disponível via `Get.find()`.
class SettingsService extends GetxService {
  static const boxName = 'settings';
  static const _themeKey = 'theme_mode';

  late final Box _box = Hive.box(boxName);

  /// Modo de tema atual (reativo).
  final themeMode = ThemeMode.system.obs;

  Future<SettingsService> init() async {
    final stored =
        _box.get(_themeKey, defaultValue: ThemeMode.system.name) as String;
    themeMode.value = _fromName(stored);
    return this;
  }

  /// Altera o tema, persiste e aplica imediatamente em todo o app.
  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    _box.put(_themeKey, mode.name);
    Get.changeThemeMode(mode);
  }

  ThemeMode _fromName(String name) => ThemeMode.values.firstWhere(
        (m) => m.name == name,
        orElse: () => ThemeMode.system,
      );
}
