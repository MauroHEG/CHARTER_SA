import 'package:charter_appli_travaux_mro/view/login_screen.dart';
import 'package:charter_appli_travaux_mro/view/services/offre_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charter_appli_travaux_mro/providers/user_info_provider.dart';
import 'package:charter_appli_travaux_mro/providers/notification_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  // Initialisation de Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions
          .currentPlatform); // currentPlatform --> va trouver et utiliser les infos firebase propre à chaque OS (android, iOS, web...)

  // Initialisation de Firebase Messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Demander l'autorisation de recevoir des notifications
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // Si l'autorisation est accordée, écouter les messages entrants
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message reçu: ${message.notification?.body}");
    });
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserInfoProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        Provider(create: (context) => OffreService()), // ajoutez ceci
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(background: const Color(0xFFD9F5D0)),
      ),
      home: const LoginScreen(),
    );
  }
}
