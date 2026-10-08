import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/services/settings_service.dart';

/// Controller da tela de Configurações. Faz a ponte com o SettingsService
/// (fonte de verdade das preferências persistidas).
class SettingsController extends GetxController {
  final SettingsService _settings = Get.find<SettingsService>();

  ThemeMode get themeMode => _settings.themeMode.value;

  void changeTheme(ThemeMode mode) => _settings.setThemeMode(mode);
}
