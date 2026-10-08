/// Propriedade = a fazenda/chácara onde ficam os tanques (topo da hierarquia:
/// Propriedade → Tanque → Ciclo → Leituras). No MVP existe uma só, criada por
/// seed; a tabela já nasce pronta para o futuro multi-tenant (SaaS).
class Propriedade {
  const Propriedade({
    required this.id,
    required this.nome,
    this.localizacao,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  /// UUID (TEXT) — escolhido em vez de auto-incremento para evitar colisão de
  /// IDs quando houver sync local→nuvem.
  final String id;
  final String nome;
  final String? localizacao;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Soft-delete: nunca apagamos de fato, só marcamos a data (exigência do
  /// padrão de sincronização).
  final DateTime? deletedAt;

  factory Propriedade.fromMap(Map<String, Object?> map) => Propriedade(
        id: map['id'] as String,
        nome: map['nome'] as String,
        localizacao: map['localizacao'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
        deletedAt: map['deleted_at'] == null
            ? null
            : DateTime.parse(map['deleted_at'] as String),
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'nome': nome,
        'localizacao': localizacao,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'deleted_at': deletedAt?.toIso8601String(),
      };
}
