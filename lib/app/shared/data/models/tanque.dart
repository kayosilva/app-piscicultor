/// Tipo de estrutura física do tanque. O `name` (escavado, tanqueRede...) é o
/// que vai gravado no banco; o `label` é o texto exibido na UI.
enum TipoTanque {
  escavado('Escavado'),
  tanqueRede('Tanque-rede'),
  alvenaria('Alvenaria'),
  outro('Outro');

  const TipoTanque(this.label);
  final String label;

  static TipoTanque fromName(String? name) => values.firstWhere(
        (t) => t.name == name,
        orElse: () => TipoTanque.outro,
      );
}

/// Tanque = a estrutura física (existe sempre, é reutilizável). O que se cria
/// dentro dele muda a cada povoamento — isso é o [Ciclo], não o tanque. Por
/// isso o histórico (leituras, biometria, ração) pendura no ciclo, não aqui.
class Tanque {
  const Tanque({
    required this.id,
    required this.propriedadeId,
    required this.nome,
    required this.tipo,
    this.volumeM3,
    this.areaM2,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String propriedadeId;
  final String nome;
  final TipoTanque tipo;
  final double? volumeM3;
  final double? areaM2;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  factory Tanque.fromMap(Map<String, Object?> map) => Tanque(
        id: map['id'] as String,
        propriedadeId: map['propriedade_id'] as String,
        nome: map['nome'] as String,
        tipo: TipoTanque.fromName(map['tipo'] as String?),
        volumeM3: (map['volume_m3'] as num?)?.toDouble(),
        areaM2: (map['area_m2'] as num?)?.toDouble(),
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
        deletedAt: map['deleted_at'] == null
            ? null
            : DateTime.parse(map['deleted_at'] as String),
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'propriedade_id': propriedadeId,
        'nome': nome,
        'tipo': tipo.name,
        'volume_m3': volumeM3,
        'area_m2': areaM2,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'deleted_at': deletedAt?.toIso8601String(),
      };

  Tanque copyWith({
    String? nome,
    TipoTanque? tipo,
    double? volumeM3,
    double? areaM2,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) =>
      Tanque(
        id: id,
        propriedadeId: propriedadeId,
        nome: nome ?? this.nome,
        tipo: tipo ?? this.tipo,
        volumeM3: volumeM3 ?? this.volumeM3,
        areaM2: areaM2 ?? this.areaM2,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );
}
