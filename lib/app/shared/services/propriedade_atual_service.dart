import 'package:get/get.dart';

import '../data/database/app_database.dart';
import '../data/models/propriedade.dart';
import '../data/repositories/propriedade_repository.dart';

/// Propriedade "atual" do app (no MVP, a única — a padrão semeada). Mantida
/// reativa e **permanente** para que a UI global acompanhe edições na hora:
/// hoje alimenta o nome no header do menu, de qualquer tela.
class PropriedadeAtualService extends GetxService {
  final Rxn<Propriedade> propriedade = Rxn<Propriedade>();

  late final PropriedadeRepository _repo =
      PropriedadeRepository(Get.find<AppDatabase>().db);

  Future<PropriedadeAtualService> init() async {
    await recarregar();
    return this;
  }

  /// Nome a exibir (com fallback enquanto não carregou / se não houver).
  String get nome => propriedade.value?.nome ?? 'Minha Propriedade';

  /// Relê do banco a propriedade padrão.
  Future<void> recarregar() async {
    propriedade.value = await _repo.getPadrao();
  }

  /// Atualiza o estado em memória após uma edição já persistida, propagando
  /// para quem observa (ex.: o header do menu) sem novo acesso ao banco.
  void definir(Propriedade p) => propriedade.value = p;
}
