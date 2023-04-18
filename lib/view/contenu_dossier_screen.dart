import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ContenuDossierScreen extends StatefulWidget {
  final String dossierId;
  final String dossierNom;

  ContenuDossierScreen({required this.dossierId, required this.dossierNom});

  @override
  _ContenuDossierScreenState createState() => _ContenuDossierScreenState();
}

class _ContenuDossierScreenState extends State<ContenuDossierScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dossierNom),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('utilisateurs')
            .doc(userId)
            .collection('dossiers')
            .doc(widget.dossierId)
            .collection('fichiers')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Erreur : ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot fichierSnapshot = snapshot.data!.docs[index];
              return ListTile(
                leading: Icon(Icons.picture_as_pdf),
                title: Text(fichierSnapshot.get('nom')),
                onTap: () {
                  // Vous pouvez ajouter ici une action pour ouvrir le fichier PDF avec un package approprié
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _ajouterFichier,
      ),
    );
  }

  void _ajouterFichier() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;

      // Téléchargez le fichier dans Firebase Storage
      TaskSnapshot taskSnapshot = await _storage
          .ref()
          .child('utilisateurs/$userId/dossiers/${widget.dossierId}/$fileName')
          .putFile(file);

      // Ajoutez le fichier à la collection de fichiers du dossier
      String fileUrl = await taskSnapshot.ref.getDownloadURL();
      await _firestore
          .collection('utilisateurs')
          .doc(userId)
          .collection('dossiers')
          .doc(widget.dossierId)
          .collection('fichiers')
          .add({
        'nom': fileName,
        'url': fileUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fichier ajouté avec succès')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Aucun fichier sélectionné")),
      );
    }
  }
}
