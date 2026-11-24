import 'package:flutter_test/flutter_test.dart';

import 'package:carfinder/main.dart';

void main() {
  testWidgets('App local storage smoke check', (WidgetTester tester) async {
    await tester.pumpWidget(const CarFinderApp());
    await tester.pumpAndSettle();

    expect(find.byType(CarFinderApp), findsOneWidget);
  });
}
