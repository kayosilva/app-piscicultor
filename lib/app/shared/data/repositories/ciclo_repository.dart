import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../models/ciclo.dart';

/// Acesso à tabela `ciclo`. Concentra as regras de persistência (gera UUID,
/// carimba timestamps, encerra e faz soft-delete) para os controllers só
/// lidarem com o modelo.
class CicloRepository {
  CicloRepository(this._db);

  final Database _db;
  static const _uuid = Uuid();

  Future<List<Ciclo>> listByTanque(String tanqueId) async {
    final rows = await _db.query(
      'ciclo',
      where: 'tanque_id = ? AND deleted_at IS NULL',
      whereArgs: [tanqueId],
      orderBy: 'data_povoamento DESC',
    );
    return rows.map(Ciclo.fromMap).toList();
  }

  /// Ciclo em andamento do tanque, se houver (só pode haver um ativo por vez).
  Future<Ciclo?> cicloAtivo(String tanqueId) async {
    final rows = await _db.query(
      'ciclo',
      where: 'tanque_id = ? AND status = ? AND deleted_at IS NULL',
      whereArgs: [tanqueId, StatusCiclo.ativo.name],
      orderBy: 'data_povoamento DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Ciclo.fromMap(rows.first);
  }

  Future<Ciclo> create({
    required String tanqueId,
    required String especie,
    required DateTime dataPovoamento,
    required int qtdInicial,
    double? pesoInicialG,
    String? origemAlevinos,
    bool vacinado = false,
  }) async {
    final now = DateTime.now();
    final ciclo = Ciclo(
      id: _uuid.v4(),
      tanqueId: tanqueId,
      especie: especie,
      dataPovoamento: dataPovoamento,
      qtdInicial: qtdInicial,
      pesoInicialG: pesoInicialG,
      origemAlevinos: origemAlevinos,
      vacinado: vacinado,
      status: StatusCiclo.ativo,
      createdAt: now,
      updatedAt: now,
    );
    await _db.insert('ciclo', ciclo.toMap());
    return ciclo;
  }

  Future<void> update(Ciclo ciclo) async {
    final map = ciclo.toMap()
      ..['updated_at'] = DateTime.now().toIso8601String();
    await _db.update('ciclo', map, where: 'id = ?', whereArgs: [ciclo.id]);
  }

  /// Encerra o ciclo (despesca): marca status `encerrado` e a data de despesca.
  Future<void> encerrar(String id, {required DateTime dataDespesca}) async {
    final now = DateTime.now().toIso8601String();
    await _db.update(
      'ciclo',
      {
        'status': StatusCiclo.encerrado.name,
        'data_despesca': dataDespesca.toIso8601String(),
        'updated_at': now,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Soft-delete: marca `deleted_at` em vez de remover a linha.
  Future<void> softDelete(String id) async {
    final now = DateTime.now().toIso8601String();
    await _db.update(
      'ciclo',
      {'deleted_at': now, 'updated_at': now},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
