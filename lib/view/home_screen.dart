import 'package:charter_appli_travaux_mro/view/reservation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/appStrings.dart';
import 'avis_screen.dart';
import 'client_chat_button.dart';
import 'documents_screen.dart';
import 'login_screen.dart';
import 'offres_charter_screen.dart';
import 'edit_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String fullName;
  final String avatarPath;

  const HomeScreen(
      {super.key, required this.fullName, required this.avatarPath});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BF853),
        title:
            Text(widget.fullName, style: const TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage: AssetImage(widget.avatarPath),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('Modifier le profil'),
                        onTap: () async {
                          // Stocker le BuildContext actuel
                          final currentContext = context;

                          // Récupérer les données de l'utilisateur connecté
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            final doc = await FirebaseFirestore.instance
                                .collection('utilisateurs')
                                .doc(user.uid)
                                .get();
                            final userProfile = doc.data();

                            if (userProfile != null) {
                              // Naviguer vers la page de modification du profil en utilisant currentContext
                              Navigator.push(
                                currentContext,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(
                                      userProfile: userProfile),
                                ),
                              );
                            } else {
                              // Afficher un message d'erreur si les données de l'utilisateur ne sont pas disponibles
                              ScaffoldMessenger.of(currentContext).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Erreur lors de la récupération des données de l'utilisateur")),
                              );
                            }
                          }
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Se déconnecter'),
                        onTap: () {
                          // Déconnexion et redirection vers la page de connexion
                          _deconnexionEtRedirection();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Image(
                image: AssetImage(AppStrings.cheminLogo),
              ),
              const SizedBox(height: 80),
              AspectRatio(
                aspectRatio: 1, // Ajuster le rapport hauteur/largeur ici
                child: GridView.count(
                  crossAxisCount: 2,
                  children: [
                    _buildHomeButton('Mes documents', Icons.folder),
                    _buildHomeButton('Mes réservations', Icons.calendar_today),
                    _buildHomeButton('Avis', Icons.rate_review),
                    _buildHomeButton('Offres Charter', Icons.local_offer),
                  ],
                ),
              ),
              const SizedBox(
                  height: 20), // Ajouter un espacement entre les boutons
              const ClientChatButton(), // Ajouter le bouton de chat ici
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeButton(String text, IconData icon) {
    return Card(
      color: const Color(0xFF7BF853),
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          // Naviguation vers l'écran approprié en fonction du bouton cliqué
          if (text == 'Mes documents') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DocumentsScreen()),
            );
          }

          if (text == 'Mes réservations') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReservationScreen(
                  userId: FirebaseAuth.instance.currentUser!.uid,
                ),
              ),
            );
          }

          if (text == 'Avis') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AvisScreen()),
            );
          }

          if (text == 'Offres Charter') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OffresCharterScreen()),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: Colors.black),
              Text(text,
                  style: const TextStyle(color: Colors.black, fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deconnexionEtRedirection() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) =>
          false, // Cette condition permet de supprimer toutes les routes en dessous de la nouvelle route
    );
  }
}
