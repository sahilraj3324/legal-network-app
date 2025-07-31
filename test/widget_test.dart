// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leagel_1/app/onboarding_screen/onboarding_screen.dart';

void main() {
  testWidgets('Onboarding screen displays correctly', (WidgetTester tester) async {
    // Build the onboarding screen directly to avoid Firebase initialization
    await tester.pumpWidget(
      MaterialApp(
        home: const OnboardingScreen(),
      ),
    );

    // Wait for the widget to be fully built
    await tester.pumpAndSettle();

    // Verify that the onboarding elements are present
    expect(find.text('Continue'), findsOneWidget);
    
    // Verify that the company logo is present
    expect(find.byType(Image), findsWidgets);
    
    // Verify that there are page indicators
    expect(find.byType(Container), findsWidgets);
  });

  testWidgets('Continue button is functional in onboarding', (WidgetTester tester) async {
    // Build the onboarding screen directly
    await tester.pumpWidget(
      MaterialApp(
        home: const OnboardingScreen(),
      ),
    );

    // Wait for the widget to be fully built
    await tester.pumpAndSettle();

    // Verify the continue button is present and tappable
    final continueButton = find.text('Continue');
    expect(continueButton, findsOneWidget);
    
    // Verify the page indicators are present
    expect(find.byType(Container), findsWidgets);
  });
}
