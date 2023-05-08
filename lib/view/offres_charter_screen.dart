import 'package:charter_appli_travaux_mro/view/ville_details_screen.dart';
import 'package:flutter/material.dart';
// Ajoutez ce paquet pour utiliser le carrousel d'images

class OffresCharterScreen extends StatefulWidget {
  const OffresCharterScreen({super.key});

  @override
  _OffresCharterScreenState createState() => _OffresCharterScreenState();
}

class _OffresCharterScreenState extends State<OffresCharterScreen> {
  List<Map<String, dynamic>> paysList = [
    {
      'nom': 'France',
      'villes': ['Paris', 'Lyon', 'Marseille', 'Bordeaux'],
    },
    {
      'nom': 'Espagne',
      'villes': ['Madrid', 'Barcelone', 'Valence', 'Séville'],
    },
    {
      'nom': 'Italie',
      'villes': ['Rome', 'Milan', 'Florence', 'Venise'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BF853),
        title: const Text("Offres Charter", style: TextStyle(color: Colors.black)),
      ),
      body: ListView.builder(
        itemCount: paysList
            .length, // Remplacez ceci par une fonction pour récupérer les pays depuis la base de données
        itemBuilder: (BuildContext context, int index) {
          return _buildPays(context, paysList[index]['nom']);
        },
      ),
    );
  }
}

Widget _buildPays(BuildContext context, String pays) {
  return ExpansionTile(
    title: Text(pays),
    children: [
      _buildVille(context, 'Marseille', pays),
      _buildVille(context, 'Lyon', pays),
      _buildVille(context, 'Paris', pays),
      _buildVille(context, 'Bordeaux', pays),
    ],
  );
}

Widget _buildVille(BuildContext context, String ville, String pays) {
  return ListTile(
    title: Text(ville),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VilleDetailsScreen(ville: ville, pays: pays),
        ),
      );
    },
  );
}
