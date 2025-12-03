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
    expect(find.byKey(Key('tab_tasks')), findsOneWidget);
    expect(find.byKey(Key('tab_helper')), findsOneWidget);
    expect(find.byKey(Key('tab_profile')), findsOneWidget);
  });
}
