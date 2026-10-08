// Testes dos modelos: conversão de/para o banco e regras simples. Cobrem em
// especial linhas gravadas no schema v1, que não têm as colunas da v2.

import 'package:flutter_test/flutter_test.dart';

import 'package:piscicultor/app/shared/data/models/ciclo.dart';
import 'package:piscicultor/app/shared/data/models/tanque.dart';
import 'package:piscicultor/app/shared/utils/decimal_input.dart';

const _agora = '2026-10-07T10:00:00.000';

void main() {
  group('Tanque', () {
    test('linha v1 (sem colunas novas) usa os padrões', () {
      final t = Tanque.fromMap({
        'id': 't1',
        'propriedade_id': 'p1',
        'nome': 'Viveiro 1',
        'tipo': 'escavado',
        'volume_m3': 250,
        'area_m2': 200,
        'created_at': _agora,
        'updated_at': _agora,
        'deleted_at': null,
      });

      expect(t.alturaM, isNull);
      expect(t.material, isNull);
      expect(t.sistemaCultivo, SistemaCultivo.convencional);
      expect(t.volumeM3, 250.0);
    });

    test('ida e volta pelo banco preserva os campos novos', () {
      final original = Tanque(
        id: 't1',
        propriedadeId: 'p1',
        nome: 'Tanque 1',
        tipo: TipoTanque.suspenso,
        volumeM3: 100,
        areaM2: 100,
        alturaM: 1,
        material: MaterialTanque.geomembrana,
        sistemaCultivo: SistemaCultivo.bioflocos,
        createdAt: DateTime.parse(_agora),
        updatedAt: DateTime.parse(_agora),
      );

      final map = original.toMap();
      expect(map['tipo'], 'suspenso');
      expect(map['material'], 'geomembrana');
      expect(map['sistema_cultivo'], 'bioflocos');

      final lido = Tanque.fromMap(map);
      expect(lido.tipo, TipoTanque.suspenso);
      expect(lido.alturaM, 1.0);
      expect(lido.material, MaterialTanque.geomembrana);
      expect(lido.sistemaCultivo, SistemaCultivo.bioflocos);
    });

    test('material desconhecido vira "outro"; ausente continua nulo', () {
      expect(MaterialTanque.fromName('inexistente'), MaterialTanque.outro);
      expect(MaterialTanque.fromName(null), isNull);
    });

    test('volume calculado = área × altura, nulo se faltar um dos dois', () {
      expect(Tanque.volumeCalculado(areaM2: 100, alturaM: 1.2), 120.0);
      expect(Tanque.volumeCalculado(areaM2: 100), isNull);
      expect(Tanque.volumeCalculado(alturaM: 1), isNull);
    });
  });

  group('Ciclo', () {
    test('linha v1 (sem colunas novas) usa os padrões', () {
      final c = Ciclo.fromMap({
        'id': 'c1',
        'tanque_id': 't1',
        'especie': 'Tilápia',
        'data_povoamento': _agora,
        'qtd_inicial': 5000,
        'origem_alevinos': 'Fornecedor Aqua',
        'status': 'ativo',
        'data_despesca': null,
        'created_at': _agora,
        'updated_at': _agora,
        'deleted_at': null,
      });

      expect(c.pesoInicialG, isNull);
      expect(c.vacinado, isFalse);
      expect(c.origemAlevinos, 'Fornecedor Aqua');
    });

    test('ida e volta pelo banco grava vacinado como 0/1', () {
      final original = Ciclo(
        id: 'c1',
        tanqueId: 't1',
        especie: 'Tilápia',
        dataPovoamento: DateTime.parse(_agora),
        qtdInicial: 3000,
        pesoInicialG: 1.7,
        vacinado: true,
        status: StatusCiclo.ativo,
        createdAt: DateTime.parse(_agora),
        updatedAt: DateTime.parse(_agora),
      );

      final map = original.toMap();
      expect(map['vacinado'], 1);
      expect(map['peso_inicial_g'], 1.7);

      final lido = Ciclo.fromMap(map);
      expect(lido.vacinado, isTrue);
      expect(lido.pesoInicialG, 1.7);
    });
  });

  group('Decimal em formulário', () {
    test('lê vírgula ou ponto; vazio ou inválido vira nulo', () {
      expect(parseDecimal('1,7'), 1.7);
      expect(parseDecimal(' 1.7 '), 1.7);
      expect(parseDecimal(''), isNull);
      expect(parseDecimal('abc'), isNull);
    });

    test('escreve com vírgula e sem casas desnecessárias', () {
      expect(formatDecimal(1.7), '1,7');
      expect(formatDecimal(120), '120');
      expect(formatDecimal(null), '');
    });

    test('o que é escrito volta igual ao ser lido', () {
      for (final v in [1.7, 0.25, 120.0, 1.2]) {
        expect(parseDecimal(formatDecimal(v)), v);
      }
    });
  });
}
