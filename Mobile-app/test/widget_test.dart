import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_app/main.dart';

void main() {
  testWidgets('Signup screen renders correctly', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(MyApp());

    // Navigate to the signup screen
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    // Check for the presence of key signup screen elements
    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Last Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('ID Number'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);
  });
}
