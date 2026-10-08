import 'package:flutter/material.dart';

/// Paleta da identidade visual do Piscicultor (tema "água").
/// Fonte única das cores de marca — use estes tokens em vez de cores soltas.
abstract class AppColors {
  /// Cor-semente principal (teal/água). Gera todo o ColorScheme (M3).
  static const seed = Color(0xFF00796B);

  /// Acento secundário (água mais clara), para destaques pontuais.
  static const accent = Color(0xFF26A69A);
}
