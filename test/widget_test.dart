import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_web_app/main.dart';

void main() {
  testWidgets('home page starts exploring', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('A quieter way\nto think clearly.'), findsOneWidget);
    expect(find.text('Start exploring'), findsOneWidget);

    await tester.tap(find.text('Start exploring'));
    await tester.pump();

    expect(find.text('You are ready'), findsOneWidget);
  });

  testWidgets('about button opens the project page', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1024, 768));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('About the project'));
    await tester.pumpAndSettle();

    expect(find.text('Make room\nfor the useful things.'), findsOneWidget);
    expect(find.byTooltip('Back to Field Notes'), findsOneWidget);
  });
}
