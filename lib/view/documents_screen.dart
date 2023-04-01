import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/firestore_service.dart';

class DocumentsScreen extends StatefulWidget {
  @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7BF853),
        title: Text('Mes documents', style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Color(0xFFD9F5D0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestoreService.getDossiers(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                String nomDossier = snapshot.data!.docs[index].get('nom');
                String dossierId = snapshot.data!.docs[index].id;
                return _buildDossierItem(snapshot.data!.docs[index], index);
              },
            );
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

  Widget _buildDossierItem(DocumentSnapshot dossier, int index) {
    String nomDossier = dossier.get('nom');

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(
          Icons.folder,
          color: Colors.green,
          size: 36.0,
        ),
        title: Text(
          nomDossier,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          // Naviguer vers le contenu du dossier
        },
      ),
    );
  }

  void _ajouterDossier() async {
    TextEditingController dossierController = TextEditingController();
    String? userId = FirebaseAuth.instance.currentUser?.uid;

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
              onPressed: () async {
                String userId = FirebaseAuth.instance.currentUser!.uid;
                await FirebaseFirestore.instance
                    .collection('utilisateurs')
                    .doc(userId)
                    .collection('dossiers')
                    .add({
                  'nom': dossierController.text,
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
