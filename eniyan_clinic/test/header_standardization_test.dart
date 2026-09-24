import 'package:eniyan_clinic/features/appointments/presentation/pages/appointments_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('appointments header uses the standard clinic title sizing', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: const AppointmentsAppBar(),
          body: const SizedBox.shrink(),
        ),
      ),
    );

    final title = tester.widget<Text>(find.text('My Appointments'));
    expect(title.style?.fontSize, 18);
    expect(title.style?.fontWeight, FontWeight.w700);
  });

  testWidgets('notifications action navigates to the notifications page', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: const AppointmentsAppBar(),
          body: const SizedBox.shrink(),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Notifications'));
    await tester.pumpAndSettle();

    expect(find.text('Notifications'), findsOneWidget);
  });
}
