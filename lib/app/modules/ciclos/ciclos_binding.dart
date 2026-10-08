import 'package:get/get.dart';

import '../../shared/data/database/app_database.dart';
import '../../shared/data/repositories/ciclo_repository.dart';
import 'ciclos_controller.dart';

/// Injeta o repositório e o controller da feature de Ciclos. Usa o banco já
/// aberto no `main` (AppDatabase permanente).
class CiclosBinding extends Bindings {
  @override
  void dependencies() {
    final db = Get.find<AppDatabase>().db;
    Get.lazyPut(() => CicloRepository(db));
    Get.lazyPut(() => CiclosController(Get.find()));
  }
}
