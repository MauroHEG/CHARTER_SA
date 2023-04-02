//import 'dart:html';

import 'package:charter_appli_travaux_mro/utils/appStrings.dart';
import 'package:charter_appli_travaux_mro/view/acceuil_view.dart';
import 'package:charter_appli_travaux_mro/view/home_screen.dart';
import 'package:charter_appli_travaux_mro/view/loginPage_view.dart';
import 'package:charter_appli_travaux_mro/view/login_screen.dart';
import 'package:charter_appli_travaux_mro/view/shared/appBar_Profil_view.dart';
import 'package:charter_appli_travaux_mro/view/shared/appBar_view.dart';
import 'package:charter_appli_travaux_mro/view/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  //initialisation de la Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions
          .currentPlatform); //currentPlatform --> va trouver et utiliser les infos firebase propre à chaque OS (android, iOS, web...)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Mon application',
        theme: ThemeData(
          primarySwatch: Colors.green,
          backgroundColor: Color(0xFFD9F5D0),
        ),
        home: LoginScreen());
  }
}
