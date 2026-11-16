import 'package:flutter_test/flutter_test.dart';

import 'package:studio_dashboard/main.dart';

void main() {
  testWidgets('increments the counter when tapped', (tester) async {
    await tester.pumpWidget(const CounterApp());

    expect(find.text('0'), findsOneWidget);
    await tester.tap(find.text('Increment'));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });
}
