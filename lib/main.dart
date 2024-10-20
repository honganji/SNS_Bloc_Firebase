import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sns_bloc_firebase/features/auth/presentation/pages/auth_page.dart';
import 'package:sns_bloc_firebase/features/auth/presentation/pages/login_page.dart';
import 'package:sns_bloc_firebase/features/auth/presentation/pages/register_page.dart';
import 'package:sns_bloc_firebase/firebase_options.dart';
import 'package:sns_bloc_firebase/themes/light_mode.dart';

void main() async {
  // firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // run app
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: AuthPage(),
    );
  }
}
