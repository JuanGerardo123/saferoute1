import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Renderiza widget básico correctamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Text('SafeRoute test')),
      ),
    );

    expect(find.text('SafeRoute test'), findsOneWidget);
  });
}
