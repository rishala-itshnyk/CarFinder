import 'package:flutter_test/flutter_test.dart';

import 'package:carfinder/main.dart';

void main() {
  testWidgets('Lab4 smoke check', (WidgetTester tester) async {
    await tester.pumpWidget(const CarFinderApp());

    expect(find.text('Лабораторна №4'), findsOneWidget);
    expect(find.text('Tesla Model 3 Long Range'), findsOneWidget);
    expect(find.text('Зробити ставку'), findsOneWidget);
  });
}
