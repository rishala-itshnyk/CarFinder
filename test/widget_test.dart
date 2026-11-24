import 'package:flutter_test/flutter_test.dart';

import 'package:carfinder/main.dart';

void main() {
  testWidgets('State management smoke check', (WidgetTester tester) async {
    await tester.pumpWidget(const CarFinderApp());

    expect(find.text('Tesla Model 3 Long Range'), findsOneWidget);
    expect(find.text('Поточна ставка: \$9,200 (ставок: 12)'), findsOneWidget);

    await tester.tap(find.text('+ \$100'));
    await tester.pump();

    expect(find.text('Поточна ставка: \$9,200 (ставок: 13)'), findsOneWidget);
  });
}
