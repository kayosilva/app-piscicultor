import 'package:get/get.dart';

import '../../shared/data/database/app_database.dart';
import '../../shared/data/repositories/propriedade_repository.dart';
import '../../shared/data/repositories/tanque_repository.dart';
import 'tanques_controller.dart';

/// Injeta os repositórios e o controller da feature de Tanques. Usa o banco já
/// aberto no `main` (AppDatabase permanente).
class TanquesBinding extends Bindings {
  @override
  void dependencies() {
    final db = Get.find<AppDatabase>().db;
    Get.lazyPut(() => PropriedadeRepository(db));
    Get.lazyPut(() => TanqueRepository(db));
    Get.lazyPut(() => TanquesController(Get.find(), Get.find()));
  }
}
