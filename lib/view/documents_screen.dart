import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'contenu_dossier_screen.dart';
import 'services/firestore_service.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BF853),
        title: const Text('Mes documents', style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: const Color(0xFFD9F5D0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestoreService.getDossiers(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
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
        backgroundColor: const Color(0xFF7BF853),
        onPressed: _ajouterDossier,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDossierItem(DocumentSnapshot dossier, int index) {
    String nomDossier = dossier.get('nom');
    String dossierId = dossier.id;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: const Icon(
          Icons.folder,
          color: Colors.green,
          size: 36.0,
        ),
        title: Text(
          nomDossier,
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContenuDossierScreen(
                dossierId: dossierId,
                dossierNom: nomDossier,
              ),
            ),
          );
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
          title: const Text('Nouveau dossier'),
          content: TextField(
            controller: dossierController,
            decoration: const InputDecoration(labelText: 'Nom du dossier'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Créer'),
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
