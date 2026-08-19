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
}
