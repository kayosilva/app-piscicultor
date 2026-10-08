import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

/// Ponto único de acesso ao SQLite local. Abre o banco, cria o schema na
/// primeira execução e faz o seed da propriedade padrão. Registrado como
/// serviço permanente no `main` e obtido via `Get.find<AppDatabase>()`.
///
/// Schema (v1): propriedade → tanque → ciclo. Todas as tabelas usam UUID (TEXT)
/// como PK e carregam created_at/updated_at/deleted_at para viabilizar o sync
/// futuro e o soft-delete.
class AppDatabase extends GetxService {
  static const _fileName = 'piscicultor.db';
  static const _version = 1;
  static const _uuid = Uuid();

  late final Database db;

  Future<AppDatabase> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, _fileName);
    db = await openDatabase(
      path,
      version: _version,
      onConfigure: (d) => d.execute('PRAGMA foreign_keys = ON'),
      onCreate: _onCreate,
    );
    return this;
  }

  Future<void> _onCreate(Database d, int version) async {
    await d.execute('''
      CREATE TABLE propriedade (
        id           TEXT PRIMARY KEY,
        nome         TEXT NOT NULL,
        localizacao  TEXT,
        created_at   TEXT NOT NULL,
        updated_at   TEXT NOT NULL,
        deleted_at   TEXT
      )
    ''');

    await d.execute('''
      CREATE TABLE tanque (
        id              TEXT PRIMARY KEY,
        propriedade_id  TEXT NOT NULL,
        nome            TEXT NOT NULL,
        tipo            TEXT NOT NULL,
        volume_m3       REAL,
        area_m2         REAL,
        created_at      TEXT NOT NULL,
        updated_at      TEXT NOT NULL,
        deleted_at      TEXT,
        FOREIGN KEY (propriedade_id) REFERENCES propriedade (id)
      )
    ''');

    await d.execute('''
      CREATE TABLE ciclo (
        id               TEXT PRIMARY KEY,
        tanque_id        TEXT NOT NULL,
        especie          TEXT NOT NULL,
        data_povoamento  TEXT NOT NULL,
        qtd_inicial      INTEGER NOT NULL,
        origem_alevinos  TEXT,
        status           TEXT NOT NULL,
        data_despesca    TEXT,
        created_at       TEXT NOT NULL,
        updated_at       TEXT NOT NULL,
        deleted_at       TEXT,
        FOREIGN KEY (tanque_id) REFERENCES tanque (id)
      )
    ''');

    await _seedPropriedadePadrao(d);
  }

  /// Cria a propriedade padrão. No MVP o Sr. Ananias tem só uma; assim o app
  /// abre direto nos tanques, sem fricção de cadastrar propriedade antes.
  Future<void> _seedPropriedadePadrao(Database d) async {
    final now = DateTime.now().toIso8601String();
    await d.insert('propriedade', {
      'id': _uuid.v4(),
      'nome': 'Minha Propriedade',
      'localizacao': null,
      'created_at': now,
      'updated_at': now,
      'deleted_at': null,
    });
  }
}
