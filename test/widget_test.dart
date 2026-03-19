import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:water_support_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WaterSupportApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
