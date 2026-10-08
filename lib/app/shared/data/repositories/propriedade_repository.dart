import 'package:sqflite/sqflite.dart';

import '../models/propriedade.dart';

/// Acesso à tabela `propriedade`. No MVP só lê a propriedade padrão (seed);
/// o CRUD completo entra quando o app virar multi-propriedade.
class PropriedadeRepository {
  PropriedadeRepository(this._db);

  final Database _db;

  /// Retorna a primeira propriedade não excluída (a padrão, no MVP).
  Future<Propriedade?> getPadrao() async {
    final rows = await _db.query(
      'propriedade',
      where: 'deleted_at IS NULL',
      orderBy: 'created_at',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Propriedade.fromMap(rows.first);
  }

  /// Busca por id (usada após salvar, para devolver o estado recém-gravado).
  Future<Propriedade?> getById(String id) async {
    final rows = await _db.query(
      'propriedade',
      where: 'id = ? AND deleted_at IS NULL',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Propriedade.fromMap(rows.first);
  }

  /// Atualiza nome/localização da propriedade e recarimba `updated_at`. No MVP
  /// só edita a padrão; a criação/exclusão entram no CRUD multi-propriedade.
  Future<void> update({
    required String id,
    required String nome,
    String? localizacao,
  }) async {
    await _db.update(
      'propriedade',
      {
        'nome': nome,
        'localizacao': localizacao,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
