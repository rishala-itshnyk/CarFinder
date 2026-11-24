import 'package:flutter_test/flutter_test.dart';

import 'package:carfinder/main.dart';

void main() {
  testWidgets('Navigation smoke check', (WidgetTester tester) async {
    await tester.pumpWidget(const CarFinderApp());

    expect(find.text('Пошук авто'), findsOneWidget);
    expect(find.text('Знайти авто на Copart'), findsOneWidget);

    await tester.tap(find.text('Знайти авто на Copart'));
    await tester.pump();

    expect(find.text('Деталі лота Copart'), findsOneWidget);
    expect(find.text('Зробити ставку'), findsOneWidget);
  });
}
