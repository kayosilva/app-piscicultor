/// Situação do ciclo. `ativo` = criação em andamento; `encerrado` = já
/// despescado. O `name` é gravado no banco; o `label` é exibido na UI.
enum StatusCiclo {
  ativo('Ativo'),
  encerrado('Encerrado');

  const StatusCiclo(this.label);
  final String label;

  static StatusCiclo fromName(String? name) => values.firstWhere(
        (s) => s.name == name,
        orElse: () => StatusCiclo.ativo,
      );
}

/// Ciclo (lote) = um povoamento específico de um tanque (ex.: 5.000 alevinos de
/// tilápia em março). Ao despescar e povoar de novo, é um novo ciclo no mesmo
/// tanque. É aqui que todo o histórico da criação se pendura.
class Ciclo {
  const Ciclo({
    required this.id,
    required this.tanqueId,
    required this.especie,
    required this.dataPovoamento,
    required this.qtdInicial,
    this.origemAlevinos,
    required this.status,
    this.dataDespesca,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String tanqueId;
  final String especie;
  final DateTime dataPovoamento;
  final int qtdInicial;
  final String? origemAlevinos;
  final StatusCiclo status;
  final DateTime? dataDespesca;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  factory Ciclo.fromMap(Map<String, Object?> map) => Ciclo(
        id: map['id'] as String,
        tanqueId: map['tanque_id'] as String,
        especie: map['especie'] as String,
        dataPovoamento: DateTime.parse(map['data_povoamento'] as String),
        qtdInicial: map['qtd_inicial'] as int,
        origemAlevinos: map['origem_alevinos'] as String?,
        status: StatusCiclo.fromName(map['status'] as String?),
        dataDespesca: map['data_despesca'] == null
            ? null
            : DateTime.parse(map['data_despesca'] as String),
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
        deletedAt: map['deleted_at'] == null
            ? null
            : DateTime.parse(map['deleted_at'] as String),
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'tanque_id': tanqueId,
        'especie': especie,
        'data_povoamento': dataPovoamento.toIso8601String(),
        'qtd_inicial': qtdInicial,
        'origem_alevinos': origemAlevinos,
        'status': status.name,
        'data_despesca': dataDespesca?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'deleted_at': deletedAt?.toIso8601String(),
      };
}
