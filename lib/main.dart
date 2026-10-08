import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/shared/data/database/app_database.dart';
import 'app/shared/services/propriedade_atual_service.dart';
import 'app/shared/services/settings_service.dart';
import 'app/shared/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Persistência local (Hive) + preferências do app.
  await Hive.initFlutter();
  await Hive.openBox(SettingsService.boxName);
  await Get.putAsync(() => SettingsService().init(), permanent: true);

  // Banco relacional local (SQLite): tanques, ciclos, leituras.
  await Get.putAsync(() => AppDatabase().init(), permanent: true);

  // Propriedade atual (nome exibido no header do menu) — depende do banco.
  await Get.putAsync(() => PropriedadeAtualService().init(), permanent: true);

  runApp(const PiscicultorApp());
}

class PiscicultorApp extends StatelessWidget {
  const PiscicultorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsService>();

    return GetMaterialApp(
      title: 'Piscicultor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode.value,
      // App em pt-BR: date pickers, formatos e textos padrão em português.
      locale: const Locale('pt', 'BR'),
      fallbackLocale: const Locale('pt', 'BR'),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('pt', 'BR')],
      initialRoute: AppRoutes.dashboard,
      getPages: AppPages.pages,
    );
  }
}
