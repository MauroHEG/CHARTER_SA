import 'package:flutter/material.dart';

class DocumentsScreen extends StatefulWidget {
  @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  List<String> _dossiers = [
    'Mon voyage à Paris',
    'Voyage à Londres',
    'Week-end Milan'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7BF853),
        title: Text('Mes documents', style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Color(0xFFD9F5D0),
        child: ListView.builder(
          itemCount: _dossiers.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildDossierItem(_dossiers[index], index);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF7BF853),
        child: Icon(Icons.add),
        onPressed: _ajouterDossier,
      ),
    );
  }

  Widget _buildDossierItem(String nomDossier, int index) {
    return ListTile(
      title: Text(nomDossier),
      onTap: () {
        // Naviguer vers le contenu du dossier
      },
    );
  }

  void _ajouterDossier() async {
    // Ajouter la logique pour créer un nouveau dossier (à stocker dans une BDD)
    TextEditingController dossierController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nouveau dossier'),
          content: TextField(
            controller: dossierController,
            decoration: InputDecoration(labelText: 'Nom du dossier'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Créer'),
              onPressed: () {
                setState(() {
                  _dossiers.add(dossierController.text);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
