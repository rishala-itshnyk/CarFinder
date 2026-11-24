import 'package:flutter_test/flutter_test.dart';

import 'package:carfinder/main.dart';

void main() {
  testWidgets('Catalog smoke check', (WidgetTester tester) async {
    await tester.pumpWidget(const CarFinderApp());

    expect(find.text('Tesla Model 3 Long Range'), findsOneWidget);
    expect(find.text('BMW M3 Competition G80'), findsOneWidget);
    expect(find.text('Всього лотів'), findsOneWidget);
  });
}
