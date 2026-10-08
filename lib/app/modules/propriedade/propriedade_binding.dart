import 'package:get/get.dart';

import '../../shared/data/database/app_database.dart';
import '../../shared/data/repositories/propriedade_repository.dart';
import 'propriedade_controller.dart';

/// Injeta o repositório e o controller da tela de dados da propriedade. Usa o
/// banco já aberto no `main` (AppDatabase permanente).
class PropriedadeBinding extends Bindings {
  @override
  void dependencies() {
    final db = Get.find<AppDatabase>().db;
    Get.lazyPut(() => PropriedadeRepository(db));
    Get.lazyPut(() => PropriedadeController(Get.find()));
  }
}
