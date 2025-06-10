import 'package:concert_schedule/screens/performance_calendar_screen.dart';
import 'package:concert_schedule/screens/performance_list_screen.dart';
import 'package:concert_schedule/screens/record_add_screen.dart';
import 'package:concert_schedule/screens/record_screen.dart';
import 'package:concert_schedule/screens/regist_screen.dart';
import 'package:concert_schedule/screens/start_screen.dart';
import 'package:concert_schedule/screens/login_screen.dart';
import 'package:concert_schedule/screens/main_screen.dart';
import 'package:concert_schedule/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await initializeDateFormatting('ko_KR', null);
    await initializeDateFormatting('ko', null);
    await initializeDateFormatting('en_US', null);
    await initializeDateFormatting('en', null);
    Intl.defaultLocale = 'ko_KR';
  } catch (e) {
    print('Locale initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MainScreen(),
      routes: {
        '/start': (context) => const StartScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/main': (context) => MainScreen(),
        '/perform': (context) => PerformanceCalendarScreen(),
        '/register': (context) => RegistrationScreen(),
        '/record': (context) => RecordScreen(),
        '/recordAdd': (context) => RecordAddScreen(),
        '/list': (context) => PerformanceListScreen(),
      },
    );
  }
}