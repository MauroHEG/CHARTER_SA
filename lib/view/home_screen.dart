import 'package:charter_appli_travaux_mro/view/reservation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/appStrings.dart';
import 'avis_screen.dart';
import 'documents_screen.dart';
import 'login_screen.dart';
import 'offres_charter_screen.dart';

class HomeScreen extends StatefulWidget {
  final String fullName;
  final String avatarPath;

  HomeScreen({required this.fullName, required this.avatarPath});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7BF853),
        title: Text(widget.fullName, style: TextStyle(color: Colors.black)),
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
                        leading: Icon(Icons.edit),
                        title: Text('Modifier le profil'),
                        onTap: () {
                          // Naviguer vers la page de modification du profil
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Se déconnecter'),
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
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Image(
                image: AssetImage(AppStrings.cheminLogo),
              ),
              SizedBox(height: 80),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeButton(String text, IconData icon) {
    return Card(
      color: Color(0xFF7BF853),
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          // Naviguation vers l'écran approprié en fonction du bouton cliqué
          if (text == 'Mes documents') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DocumentsScreen()),
            );
          }

          if (text == 'Mes réservations') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReservationScreen()),
            );
          }

          if (text == 'Avis') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AvisScreen()),
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
              Text(text, style: TextStyle(color: Colors.black, fontSize: 18)),
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
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) =>
          false, // Cette condition permet de supprimer toutes les routes en dessous de la nouvelle route
    );
  }
}
