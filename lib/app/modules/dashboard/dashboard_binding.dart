import 'package:get/get.dart';

import '../../shared/data/database/app_database.dart';
import '../../shared/data/repositories/ciclo_repository.dart';
import '../../shared/data/repositories/propriedade_repository.dart';
import '../../shared/data/repositories/tanque_repository.dart';
import 'dashboard_controller.dart';

/// Injeta os repositórios e o controller do Painel. Usa o banco já aberto no
/// `main` (AppDatabase permanente).
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    final db = Get.find<AppDatabase>().db;
    Get.lazyPut(() => PropriedadeRepository(db));
    Get.lazyPut(() => TanqueRepository(db));
    Get.lazyPut(() => CicloRepository(db));
    Get.lazyPut(
        () => DashboardController(Get.find(), Get.find(), Get.find()));
  }
}
