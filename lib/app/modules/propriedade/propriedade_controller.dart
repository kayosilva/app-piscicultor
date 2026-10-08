import 'package:get/get.dart';

import '../../shared/data/models/propriedade.dart';
import '../../shared/data/repositories/propriedade_repository.dart';
import '../../shared/services/propriedade_atual_service.dart';
import '../dashboard/dashboard_controller.dart';

/// Controller da tela de dados da propriedade. No MVP só existe a propriedade
/// padrão (seed), então a tela é de edição — sem lista nem "nova propriedade".
/// A estrutura já fica pronta para virar CRUD completo na Fase 2 (multi-tenant).
class PropriedadeController extends GetxController {
  PropriedadeController(this._repo);

  final PropriedadeRepository _repo;

  final carregando = true.obs;
  final salvando = false.obs;
  final Rxn<Propriedade> propriedade = Rxn<Propriedade>();

  @override
  void onInit() {
    super.onInit();
    carregar();
  }

  Future<void> carregar() async {
    carregando.value = true;
    propriedade.value = await _repo.getPadrao();
    carregando.value = false;
  }

  /// Salva nome/localização da propriedade atual e devolve o estado atualizado
  /// para a UI (ex.: o drawer refletir o novo nome).
  Future<void> salvar({required String nome, String? localizacao}) async {
    final atual = propriedade.value;
    if (atual == null) return;

    salvando.value = true;
    await _repo.update(id: atual.id, nome: nome, localizacao: localizacao);
    final atualizada = await _repo.getById(atual.id);
    propriedade.value = atualizada;
    salvando.value = false;

    // Propaga para o header do menu (serviço global reativo) — reflete na hora.
    if (atualizada != null) {
      Get.find<PropriedadeAtualService>().definir(atualizada);
    }

    // Painel exibe o nome da propriedade no topo; se ele estiver vivo na pilha,
    // recarrega para refletir o nome novo ao voltar.
    if (Get.isRegistered<DashboardController>()) {
      await Get.find<DashboardController>().carregar();
    }
  }
}
