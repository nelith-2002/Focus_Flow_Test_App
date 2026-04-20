// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:focus_flow_test/app.dart';

void main() {
  testWidgets('Focus Flow screen renders', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FocusFlowApp());

    expect(find.text('Focus Flow'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
