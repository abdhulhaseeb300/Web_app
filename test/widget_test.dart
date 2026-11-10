import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:studio_dashboard/main.dart';

void main() {
  testWidgets('shows the studio overview and project summary', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const StudioApp());

    expect(find.text('Good morning, Jamie ☀'), findsOneWidget);
    expect(find.text('Active projects'), findsOneWidget);
    expect(find.text('Website redesign'), findsWidgets);
  });

  testWidgets('creates a task and shows it in My tasks', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const StudioApp());
    await tester.tap(find.text('＋  New task'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byType(TextFormField).first, 'Sketch onboarding flow');
    await tester.enterText(find.byType(TextFormField).last, 'Mobile app');
    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();

    expect(find.text('My tasks'), findsWidgets);
    expect(find.text('Sketch onboarding flow'), findsOneWidget);
    expect(find.text('Mobile app'), findsOneWidget);
  });
}
