import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../models/tanque.dart';

/// Acesso à tabela `tanque`. Concentra as regras de persistência (gera UUID,
/// carimba timestamps, faz soft-delete) para os controllers só lidarem com o
/// modelo.
class TanqueRepository {
  TanqueRepository(this._db);

  final Database _db;
  static const _uuid = Uuid();

  /// Lista os tanques ativos (não excluídos) de uma propriedade, por nome.
  Future<List<Tanque>> listByPropriedade(String propriedadeId) async {
    final rows = await _db.query(
      'tanque',
      where: 'propriedade_id = ? AND deleted_at IS NULL',
      whereArgs: [propriedadeId],
      orderBy: 'nome COLLATE NOCASE',
    );
    return rows.map(Tanque.fromMap).toList();
  }

  Future<Tanque> create({
    required String propriedadeId,
    required String nome,
    required TipoTanque tipo,
    double? volumeM3,
    double? areaM2,
  }) async {
    final now = DateTime.now();
    final tanque = Tanque(
      id: _uuid.v4(),
      propriedadeId: propriedadeId,
      nome: nome,
      tipo: tipo,
      volumeM3: volumeM3,
      areaM2: areaM2,
      createdAt: now,
      updatedAt: now,
    );
    await _db.insert('tanque', tanque.toMap());
    return tanque;
  }

  Future<void> update(Tanque tanque) async {
    await _db.update(
      'tanque',
      tanque.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [tanque.id],
    );
  }

  /// Soft-delete: marca `deleted_at` em vez de remover a linha.
  Future<void> softDelete(String id) async {
    final now = DateTime.now().toIso8601String();
    await _db.update(
      'tanque',
      {'deleted_at': now, 'updated_at': now},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
