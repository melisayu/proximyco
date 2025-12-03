import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proximyco/main.dart';

void main() {
  testWidgets('Bottom navigation switches tabs correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // Verify default page is Discover
    expect(find.byKey(Key('tab_discover')), findsOneWidget);
    expect(find.text('Discover Within 5km'), findsOneWidget);

    // Tap My Tasks tab
    await tester.tap(find.byIcon(Icons.checklist_outlined));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('tab_tasks')), findsOneWidget);
    expect(find.text('Discover Within 5km'), findsNothing);

    // Tap Helper tab
    await tester.tap(find.byIcon(Icons.volunteer_activism_outlined));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('tab_helpers')), findsOneWidget);
    expect(find.text('Discover Within 5km'), findsNothing);

    // Tap Profile tab
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('tab_profile')), findsOneWidget);
    expect(find.text('Discover Within 5km'), findsNothing);

    // // Tap Discover again
    await tester.tap(find.byIcon(Icons.explore_outlined));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('tab_discover')), findsOneWidget);
    expect(find.text('Discover Within 5km'), findsOneWidget);
  });
}
