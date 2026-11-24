import 'package:flutter_test/flutter_test.dart';

import 'package:carfinder/main.dart';

void main() {
  testWidgets('JSON catalog smoke check', (WidgetTester tester) async {
    await tester.pumpWidget(const CarFinderApp());
    await tester.pumpAndSettle();

    expect(find.text('Tesla Model 3 Long Range'), findsOneWidget);
    expect(find.text('Всього лотів'), findsOneWidget);
  });
}
