import 'package:flutter_test/flutter_test.dart';

import 'package:carfinder/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CarFinderApp());

    expect(find.text('Пошук авто'), findsOneWidget);
    expect(find.text('Знайти авто'), findsOneWidget);
  });
}
