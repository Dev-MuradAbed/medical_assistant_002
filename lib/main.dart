import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:medical_assistant_002/provider/doctor_provider/profile_provider.dart';
import 'package:medical_assistant_002/provider/doctor_provider/todo_provider/todo_doctor_provider.dart';
import 'package:medical_assistant_002/provider/doctor_provider/todo_provider/todo_patient_provider.dart';
import 'package:medical_assistant_002/screens/auth/login_screen.dart';
import 'package:medical_assistant_002/screens/navigation_bar_screens/bottom_navigation_paramedic%20_bar.dart';
import '../storge/pref_controller.dart';
import '../theme.dart';
import 'package:provider/provider.dart';

import 'database/doctor_db.dart';
import 'provider/provider_language.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPrefController().initPref();
  await DbController().initDatabase();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MedicalAssist());
}

class MedicalAssist extends StatelessWidget {


  MedicalAssist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [


        ChangeNotifierProvider<TaskProvider>(
          create: (context) => TaskProvider(),
        ),
        ChangeNotifierProvider<TaskDoctorProvider>(
          create: (context) => TaskDoctorProvider(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider(),
        ),
        ChangeNotifierProvider<LanguageProvider>(
            create: (context) => LanguageProvider()),
      ],
      child: mati(),
    );
  }
}
class mati extends StatefulWidget {
  const mati({Key? key}) : super(key: key);

  @override
  State<mati> createState() => _matiState();
}

class _matiState extends State<mati> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale(Provider.of<LanguageProvider>(context).language),
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],

      theme: Themes.light,
      darkTheme: Themes.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login_screen',
      routes: {
        '/button_navigator_bar': (context) => const BNPBar(),
        '/login_screen': (context) => const LoginScreen(),
        // '/signup_screen': (context) => const SignupScreen(),
        // '/forget_screen': (context) => const ForgetPassword(),
        // '/change_password': (context) => const ChangePassword(),
      },
    );
  }
}
