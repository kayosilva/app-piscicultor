import 'package:get/get.dart';

import '../../shared/data/models/propriedade.dart';
import '../../shared/data/models/tanque.dart';
import '../../shared/data/repositories/propriedade_repository.dart';
import '../../shared/data/repositories/tanque_repository.dart';

/// Estado e regras da tela de Tanques (dashboard + CRUD). Carrega a propriedade
/// padrão e os tanques dela; expõe salvar/excluir recarregando a lista.
class TanquesController extends GetxController {
  TanquesController(this._propriedadeRepo, this._tanqueRepo);

  final PropriedadeRepository _propriedadeRepo;
  final TanqueRepository _tanqueRepo;

  final propriedade = Rxn<Propriedade>();
  final tanques = <Tanque>[].obs;
  final carregando = true.obs;

  @override
  void onInit() {
    super.onInit();
    carregar();
  }

  Future<void> carregar() async {
    carregando.value = true;
    final prop = await _propriedadeRepo.getPadrao();
    propriedade.value = prop;
    tanques.value =
        prop == null ? [] : await _tanqueRepo.listByPropriedade(prop.id);
    carregando.value = false;
  }

  /// Cria (se [existente] for nulo) ou atualiza um tanque, e recarrega a lista.
  Future<void> salvar({
    Tanque? existente,
    required String nome,
    required TipoTanque tipo,
    double? volumeM3,
    double? areaM2,
    double? alturaM,
    MaterialTanque? material,
    required SistemaCultivo sistemaCultivo,
  }) async {
    final prop = propriedade.value;
    if (prop == null) return;

    if (existente == null) {
      await _tanqueRepo.create(
        propriedadeId: prop.id,
        nome: nome,
        tipo: tipo,
        volumeM3: volumeM3,
        areaM2: areaM2,
        alturaM: alturaM,
        material: material,
        sistemaCultivo: sistemaCultivo,
      );
    } else {
      // Construção explícita (em vez de copyWith) para que limpar um campo na
      // edição realmente grave null — copyWith com `??` manteria o valor antigo.
      await _tanqueRepo.update(
        Tanque(
          id: existente.id,
          propriedadeId: existente.propriedadeId,
          nome: nome,
          tipo: tipo,
          volumeM3: volumeM3,
          areaM2: areaM2,
          alturaM: alturaM,
          material: material,
          sistemaCultivo: sistemaCultivo,
          createdAt: existente.createdAt,
          updatedAt: existente.updatedAt,
          deletedAt: existente.deletedAt,
        ),
      );
    }
    await carregar();
  }

  Future<void> excluir(Tanque tanque) async {
    await _tanqueRepo.softDelete(tanque.id);
    await carregar();
  }
}
