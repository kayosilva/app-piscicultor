// Smoke test do esqueleto: garante que o app sobe e o contador reativo
// (GetX/Obx) incrementa ao tocar no botão.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:piscicultor/main.dart';

void main() {
  testWidgets('incrementa o contador de tanques', (WidgetTester tester) async {
    await tester.pumpWidget(const PiscicultorApp());
    await tester.pumpAndSettle();

    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });
}
