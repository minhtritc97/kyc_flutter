import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('shows the Start KYC button', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Start KYC'), findsOneWidget);
  });
}
