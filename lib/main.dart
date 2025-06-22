import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

import 'package:flutter_gemini/flutter_gemini.dart';
import 'consts.dart';

import 'pages/welcome_page.dart';
import 'pages/login_page.dart';
import 'pages/user_home_page.dart';

import 'pages/Doctor/doctor_login_page.dart';
import 'pages/Doctor/doctor_home_page.dart';
import 'pages/Doctor/doctor_schedule_page.dart';
import 'pages/Doctor/doctor_registration_page.dart';
import 'pages/Doctor/doctor_info_page.dart';

import 'pages/demographics_page.dart';
import 'pages/consent_form_page.dart';
import 'pages/sessions_page.dart';
import 'pages/session_diary_page.dart';

import 'pages/session 1/session1_page.dart';
import 'pages/session1_question_page.dart';
import 'pages/session 1/session1_information_page.dart';

import 'pages/session 2/session2_page.dart';
import 'pages/session 2/task_logging_page.dart';
import 'pages/session 2/session2_evaluation_page.dart';

import 'pages/session 3/session3_page.dart';
import 'pages/session 3/tracking_page.dart';

import 'pages/session 4/session4_page.dart';
import 'pages/session 4/self_affirmation_page.dart';

import 'pages/session 5/session5_page.dart';

import 'pages/session 6/session6_page.dart';
import 'pages/session 6/grounding_exercise_page.dart';

import 'pages/session 7/session7_page.dart';
import 'pages/session 7/reflection_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: Gemini_Api_Key);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MentalWellbeingApp());
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing Firebase: $e');
    }
  }
}

class MentalWellbeingApp extends StatelessWidget {
  const MentalWellbeingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Wellbeing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/user_home': (context) => const UserHomePage(),
        '/demographics': (context) => const DemographicsPage(),
        '/consent': (context) => const ConsentFormPage(),
        '/sessions': (context) => const SessionsPage(),
        '/session1': (context) => const Session1Page(),
        '/session1_question': (context) => const Session1QuestionPage(),
        '/session1_information': (context) => const Session1InformationPage(),
        '/session1_diary': (context) =>
            const SessionDiaryPage(sessionNumber: 1),
        '/session2': (context) => const Session2Page(),
        '/task_logging': (context) => const TaskLoggingPage(),
        '/session2_evaluation': (context) => const Session2EvaluationPage(),
        '/session3': (context) => const Session3Page(),
        '/tracking': (context) => const TrackingPage(),
        '/session4': (context) => const Session4Page(),
        '/self_affirmation': (context) => const SelfAffirmationPage(),
        '/session5': (context) => const Session5Page(),
        '/session6': (context) => const Session6Page(),
        '/grounding_exercise': (context) => const GroundingExercisePage(),
        '/session7': (context) => const Session7Page(),
        '/reflection': (context) => const ReflectionPage(),
        '/doctor_login': (context) => const DoctorLoginPage(),
        '/doctor_home': (context) => const DoctorHomePage(),
        '/schedule_session': (context) => const ScheduleSessionPage(),
        '/doctor_register': (context) => const DoctorRegistrationPage(),
        '/doctor_info': (context) => const DoctorInfoPage(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const WelcomePage(),
      ),
    );
  }
}
