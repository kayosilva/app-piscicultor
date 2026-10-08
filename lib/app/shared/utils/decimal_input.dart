// Conversão de números decimais em campos de formulário, no padrão pt-BR.
//
// Sem separador de milhar de propósito: "1.000" seria ambíguo com o ponto que
// o teclado do Android às vezes oferece como separador decimal.

/// Lê o texto do campo aceitando vírgula ou ponto como separador decimal.
/// Vazio (ou inválido) vira `null`.
double? parseDecimal(String texto) {
  final t = texto.trim().replaceAll(',', '.');
  if (t.isEmpty) return null;
  return double.tryParse(t);
}

/// Escreve o valor para o campo: sem casas desnecessárias (120.0 → "120") e
/// com vírgula decimal (1.7 → "1,7"). `null` vira texto vazio.
String formatDecimal(double? valor) {
  if (valor == null) return '';
  if (valor == valor.roundToDouble()) return valor.toStringAsFixed(0);
  return valor.toString().replaceAll('.', ',');
}
