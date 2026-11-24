import 'package:flutter_test/flutter_test.dart';

import 'package:carfinder/main.dart';

void main() {
  testWidgets('Register screen smoke check', (WidgetTester tester) async {
    await tester.pumpWidget(const CarFinderApp());

    expect(find.text('Реєстрація в CarFinder'), findsOneWidget);
    expect(find.text('Зареєструватися'), findsOneWidget);
  });
}
