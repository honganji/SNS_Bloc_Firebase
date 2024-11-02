import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sns_bloc_firebase/app.dart';
import 'package:sns_bloc_firebase/config/firebase_options.dart';

void main() async {
  // setup dotenv package
  await dotenv.load(fileName: ".env");

  // firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // run app
  runApp(MainApp());
}
