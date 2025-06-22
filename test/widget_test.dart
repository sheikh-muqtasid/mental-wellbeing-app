import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_wellbeing/main.dart';
import 'package:mental_wellbeing/pages/Doctor/doctor_info_page.dart';
import 'package:mental_wellbeing/pages/Doctor/doctor_registration_page.dart';
import 'package:mental_wellbeing/pages/Doctor/doctor_schedule_page.dart';
import 'package:mental_wellbeing/pages/login_page.dart';
import 'package:mental_wellbeing/pages/Doctor/doctor_login_page.dart';
import 'package:mental_wellbeing/pages/Doctor/doctor_home_page.dart';
import 'package:mental_wellbeing/pages/demographics_page.dart';
import 'package:mental_wellbeing/pages/consent_form_page.dart';
import 'package:mental_wellbeing/pages/session_diary_page.dart';
import 'package:mental_wellbeing/pages/sessions_page.dart';
import 'package:mental_wellbeing/pages/session%201/session1_page.dart';
import 'package:mental_wellbeing/pages/session%202/session2_page.dart';
import 'package:mental_wellbeing/pages/session%203/session3_page.dart';
import 'package:mental_wellbeing/pages/session%204/session4_page.dart';
import 'package:mental_wellbeing/pages/session%205/session5_page.dart';
import 'package:mental_wellbeing/pages/session%206/session6_page.dart';
import 'package:mental_wellbeing/pages/session%207/session7_page.dart';
import 'package:mental_wellbeing/pages/user_home_page.dart';
import 'package:mental_wellbeing/pages/welcome_page.dart';

void main() {
  testWidgets('WelcomePage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MentalWellbeingApp());

    expect(find.text('Mental Wellbeing App'), findsOneWidget);
    expect(find.text('I am a Patient'), findsOneWidget);
    expect(find.text('I am a Doctor'), findsOneWidget);
  });

  testWidgets('LoginPage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: const LoginPage(),
      routes: {
        '/demographics': (context) => const DemographicsPage(),
        '/user_home': (context) => const UserHomePage(),
      },
    ));

    expect(find.text('Patient Login'), findsOneWidget);
    expect(find.text('Sign in with Google to continue'), findsOneWidget);
  });

  testWidgets('DoctorLoginPage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: const DoctorLoginPage(),
      routes: {
        '/doctor_home': (context) => const DoctorHomePage(),
        '/doctor_register': (context) => const DoctorRegistrationPage(),
      },
    ));

    expect(find.text('Doctor Login'), findsOneWidget);
    expect(find.text('Sign in with Google to continue'), findsOneWidget);
    expect(find.text('New Doctor? Register Here'), findsOneWidget);
  });

  testWidgets('DemographicsPage form validation', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DemographicsPage()));

    // Verify initial state
    expect(find.text('Demographics'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3));

    // Test validation
    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(find.text('Name is required'), findsOneWidget);
    expect(find.text('Age is required'), findsOneWidget);
    expect(find.text('Please describe your routine'), findsOneWidget);
  });

  testWidgets('ConsentFormPage toggles consent', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: const ConsentFormPage(),
      routes: {
        '/sessions': (context) => const SessionsPage(),
      },
    ));

    // Initial state
    expect(find.text('Consent Form'), findsOneWidget);
    final checkbox = find.byType(CheckboxListTile);
    expect(checkbox, findsOneWidget);
    expect(tester.widget<CheckboxListTile>(checkbox).value, false);

    // Toggle checkbox
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(tester.widget<CheckboxListTile>(checkbox).value, true);

    // Test submit
    await tester.tap(find.text('Submit'));
    await tester.pump();
  });

  testWidgets('SessionsPage shows all sessions', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: const SessionsPage(),
      routes: {
        '/session1': (context) => const Session1Page(),
        '/session2': (context) => const Session2Page(),
        '/session3': (context) => const Session3Page(),
        '/session4': (context) => const Session4Page(),
        '/session5': (context) => const Session5Page(),
        '/session6': (context) => const Session6Page(),
        '/session7': (context) => const Session7Page(),
      },
    ));

    expect(find.text('Sessions'), findsOneWidget);
    expect(find.text('Session 1: Managing Stress'), findsOneWidget);
    expect(
        find.text('Session 7: Reflection and Future Planning'), findsOneWidget);
    expect(find.byIcon(Icons.bar_chart), findsOneWidget);
  });

  testWidgets('SessionDiaryPage renders correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: const SessionDiaryPage(sessionNumber: 1),
      routes: {
        '/sessions': (context) => const SessionsPage(),
      },
    ));

    expect(find.text('Session 1 Diary'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Submit Diary'), findsOneWidget);
  });

  testWidgets('DoctorHomePage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: const DoctorHomePage(),
      routes: {
        '/schedule_session': (context) => const ScheduleSessionPage(),
        '/doctor_info': (context) => const DoctorInfoPage(),
        '/welcome': (context) => const WelcomePage(),
      },
    ));

    expect(find.text('Doctor Dashboard'), findsOneWidget);
    expect(find.text('View Patient Reports'), findsOneWidget);
    expect(find.text('Schedule Session'), findsOneWidget);
    expect(find.text('My Information'), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);
  });

  testWidgets('UserHomePage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: const UserHomePage(),
      routes: {
        '/sessions': (context) => const SessionsPage(),
        '/doctor_info': (context) => const DoctorInfoPage(),
        '/welcome': (context) => const WelcomePage(),
      },
    ));

    expect(find.text('User Home'), findsOneWidget);
    expect(find.text('Sessions'), findsOneWidget);
    expect(find.text('Doctors Info'), findsOneWidget);
    expect(find.text('View Progress Report'), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);
  });
}
