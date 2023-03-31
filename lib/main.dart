import 'dart:html';

import 'package:charter_appli_travaux_mro/utils/appStrings.dart';
import 'package:charter_appli_travaux_mro/view/acceuil_view.dart';
import 'package:charter_appli_travaux_mro/view/loginPage_view.dart';
import 'package:charter_appli_travaux_mro/view/shared/appBar_Profil_view.dart';
import 'package:charter_appli_travaux_mro/view/shared/appBar_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  //initialisation de la Firebase
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
        title: AppStrings.titreApp,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
        ),
        home: AppBar_profil_view(
          title: AppStrings.acceuil,
          page: Acceuil_view(),
        )
        /*AppBar_view(
          title: AppStrings.acceuil,
          page: LoginPage(),
        )*/
        //de base = const MyHomePage(title: "Flutter demo home page"), j'ai enlever le const car MyHomePage va changer de titre au fur et à mesure
        );
  }
}
