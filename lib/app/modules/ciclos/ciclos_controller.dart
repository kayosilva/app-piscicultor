import 'package:get/get.dart';

import '../../shared/data/models/ciclo.dart';
import '../../shared/data/models/tanque.dart';
import '../../shared/data/repositories/ciclo_repository.dart';

/// Estado e regras da tela de Ciclos de um tanque. O tanque chega via
/// `Get.arguments` (a lista de tanques navega passando o tanque tocado).
class CiclosController extends GetxController {
  CiclosController(this._repo);

  final CicloRepository _repo;

  /// Tanque dono destes ciclos (passado na navegação).
  late final Tanque tanque = Get.arguments as Tanque;

  final ciclos = <Ciclo>[].obs;
  final carregando = true.obs;

  /// Ciclo em andamento, se houver (regra: no máximo um por tanque).
  Ciclo? get cicloAtivo {
    for (final c in ciclos) {
      if (c.status == StatusCiclo.ativo) return c;
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    carregar();
  }

  Future<void> carregar() async {
    carregando.value = true;
    ciclos.value = await _repo.listByTanque(tanque.id);
    carregando.value = false;
  }

  /// Cria (se [existente] for nulo) ou atualiza um ciclo. Retorna `null` em
  /// sucesso, ou uma mensagem de erro quando a regra de negócio impede.
  Future<String?> salvar({
    Ciclo? existente,
    required String especie,
    required DateTime dataPovoamento,
    required int qtdInicial,
    String? origemAlevinos,
  }) async {
    if (existente == null) {
      // Só um ciclo ativo por tanque: encerre o atual antes de povoar de novo.
      if (cicloAtivo != null) {
        return 'Este tanque já tem um ciclo ativo. '
            'Encerre-o (despesca) antes de iniciar outro.';
      }
      await _repo.create(
        tanqueId: tanque.id,
        especie: especie,
        dataPovoamento: dataPovoamento,
        qtdInicial: qtdInicial,
        origemAlevinos: origemAlevinos,
      );
    } else {
      // Construção explícita preservando status/despesca (a edição não mexe
      // neles — isso é papel do "encerrar").
      await _repo.update(
        Ciclo(
          id: existente.id,
          tanqueId: existente.tanqueId,
          especie: especie,
          dataPovoamento: dataPovoamento,
          qtdInicial: qtdInicial,
          origemAlevinos: origemAlevinos,
          status: existente.status,
          dataDespesca: existente.dataDespesca,
          createdAt: existente.createdAt,
          updatedAt: existente.updatedAt,
          deletedAt: existente.deletedAt,
        ),
      );
    }
    await carregar();
    return null;
  }

  Future<void> encerrar(Ciclo ciclo, DateTime dataDespesca) async {
    await _repo.encerrar(ciclo.id, dataDespesca: dataDespesca);
    await carregar();
  }

  Future<void> excluir(Ciclo ciclo) async {
    await _repo.softDelete(ciclo.id);
    await carregar();
  }
}
