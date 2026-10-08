import 'package:get/get.dart';

import '../../shared/data/models/ciclo.dart';
import '../../shared/data/models/propriedade.dart';
import '../../shared/data/models/tanque.dart';
import '../../shared/data/repositories/ciclo_repository.dart';
import '../../shared/data/repositories/propriedade_repository.dart';
import '../../shared/data/repositories/tanque_repository.dart';

/// Um tanque com o seu ciclo ativo (ou `null`, se estiver ocioso). É a linha do
/// painel: consolida a estrutura física + o que está sendo criado nela agora.
class ResumoTanque {
  const ResumoTanque(this.tanque, this.cicloAtivo);

  final Tanque tanque;
  final Ciclo? cicloAtivo;

  bool get ocupado => cicloAtivo != null;
}

/// Estado do painel (tela inicial). Junta propriedade + tanques + ciclo ativo
/// de cada tanque, e deriva os indicadores do topo.
class DashboardController extends GetxController {
  DashboardController(this._propriedadeRepo, this._tanqueRepo, this._cicloRepo);

  final PropriedadeRepository _propriedadeRepo;
  final TanqueRepository _tanqueRepo;
  final CicloRepository _cicloRepo;

  final propriedade = Rxn<Propriedade>();
  final resumos = <ResumoTanque>[].obs;
  final carregando = true.obs;

  // Indicadores derivados (KPIs do topo).
  int get totalTanques => resumos.length;
  int get tanquesOcupados => resumos.where((r) => r.ocupado).length;
  int get peixesEmCultivo =>
      resumos.fold(0, (soma, r) => soma + (r.cicloAtivo?.qtdInicial ?? 0));

  @override
  void onInit() {
    super.onInit();
    carregar();
  }

  Future<void> carregar() async {
    carregando.value = true;
    final prop = await _propriedadeRepo.getPadrao();
    propriedade.value = prop;

    if (prop == null) {
      resumos.clear();
      carregando.value = false;
      return;
    }

    final tanques = await _tanqueRepo.listByPropriedade(prop.id);
    final lista = <ResumoTanque>[];
    for (final Tanque t in tanques) {
      lista.add(ResumoTanque(t, await _cicloRepo.cicloAtivo(t.id)));
    }
    resumos.value = lista;
    carregando.value = false;
  }
}
