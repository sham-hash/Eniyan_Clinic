// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:eniyan_clinic/app/app.dart';
import 'package:eniyan_clinic/features/auth/presentation/pages/registration_page.dart';
import 'package:eniyan_clinic/features/home/presentation/pages/home_page.dart';

void main() {
  testWidgets('shows splash, welcome, login, and home flow', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EniyanClinicApp());

    expect(
      find.text('Nurturing little minds, inspiring bright futures'),
      findsOneWidget,
    );
    expect(find.text('Developed by ShaTechX'), findsOneWidget);
    expect(find.text('Welcome to Eniyan Clinic'), findsNothing);

    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump();

    expect(
      find.text('A little more care for every little one.'),
      findsOneWidget,
    );
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Trusted care for growing families'), findsOneWidget);
    expect(find.text('Good morning,'), findsNothing);

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'parent@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password');
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(find.text('Good Morning 👋'), findsOneWidget);
    expect(find.text('Welcome to\nEniyan Clinics'), findsOneWidget);
    expect(find.text('Appointments'), findsOneWidget);
    expect(find.text('Facilities'), findsOneWidget);
    expect(find.text('Blog'), findsOneWidget);
    expect(find.text('Peak Flow'), findsOneWidget);

    await tester.tap(find.byTooltip('Open profile'));
    await tester.pumpAndSettle();

    expect(find.text('Rajesh Kumar'), findsOneWidget);
    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Terms & Conditions'), findsOneWidget);
  });

  testWidgets('registers a new family account', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegistrationPage()));

    expect(find.text('Create your account'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Ravi Kumar');
    await tester.enterText(fields.at(1), 'ravi@example.com');
    await tester.enterText(fields.at(2), 'password');
    await tester.enterText(fields.at(3), 'password');
    await tester.ensureVisible(find.byType(CheckboxListTile));
    await tester.tap(find.byType(CheckboxListTile));
    await tester.ensureVisible(find.text('Create account'));
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Good Morning 👋'), findsOneWidget);
  });

  testWidgets('opens the appointments tab', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    await tester.tap(find.text('Appointments').last);
    await tester.pumpAndSettle();

    expect(find.text('My Appointments'), findsOneWidget);
    expect(find.text('Upcoming'), findsNWidgets(3));
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Cancelled'), findsOneWidget);
    expect(find.text('Dr. Elamparithi'), findsOneWidget);
    expect(find.text('Book Appointment'), findsOneWidget);
  });

  testWidgets('opens the facilities tab', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    await tester.tap(find.text('Facilities').last);
    await tester.pumpAndSettle();

    expect(find.text('Our Facilities'), findsOneWidget);
    expect(find.text('Comfortable care for your child.'), findsOneWidget);
    expect(find.text('Pediatric Consultation'), findsOneWidget);
    expect(find.text('Neonatal Care'), findsOneWidget);
    expect(find.text('Vaccination'), findsOneWidget);
    expect(find.text('Emergency Support'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -1000));
    await tester.pumpAndSettle();
    expect(find.text('Have a question?'), findsOneWidget);
  });

  testWidgets('opens the blog tab', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    await tester.tap(find.text('Blog').last);
    await tester.pumpAndSettle();

    expect(find.text('Health & Wellness'), findsOneWidget);
    expect(
      find.text('Helpful guidance for\nhealthier, happier families.'),
      findsOneWidget,
    );
    expect(find.text('FEATURED ARTICLE'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(find.text('Latest articles'), findsOneWidget);
    expect(
      find.text('Building a happy, healthy plate for your child'),
      findsOneWidget,
    );
  });
}
