import 'package:get/get.dart';

import '../modules/ciclos/ciclo_form_page.dart';
import '../modules/ciclos/ciclos_binding.dart';
import '../modules/ciclos/ciclos_page.dart';
import '../modules/dashboard/dashboard_binding.dart';
import '../modules/dashboard/dashboard_page.dart';
import '../modules/propriedade/propriedade_binding.dart';
import '../modules/propriedade/propriedade_page.dart';
import '../modules/settings/settings_binding.dart';
import '../modules/settings/settings_page.dart';
import '../modules/tanques/tanque_form_page.dart';
import '../modules/tanques/tanques_binding.dart';
import '../modules/tanques/tanques_list_page.dart';
import 'app_routes.dart';

/// Mapa de rotas -> página + binding (injeção de dependência por rota).
abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.propriedade,
      page: () => const PropriedadePage(),
      binding: PropriedadeBinding(),
    ),
    GetPage(
      name: AppRoutes.tanques,
      page: () => const TanquesListPage(),
      binding: TanquesBinding(),
    ),
    GetPage(
      // Sem binding próprio: reaproveita o TanquesController vivo da lista.
      name: AppRoutes.tanqueForm,
      page: () => const TanqueFormPage(),
    ),
    GetPage(
      name: AppRoutes.ciclos,
      page: () => const CiclosPage(),
      binding: CiclosBinding(),
    ),
    GetPage(
      // Sem binding próprio: reaproveita o CiclosController vivo da lista.
      name: AppRoutes.cicloForm,
      page: () => const CicloFormPage(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
    ),
  ];
}
