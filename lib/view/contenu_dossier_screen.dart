import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

class ContenuDossierScreen extends StatelessWidget {
  final String dossierId;
  final String dossierNom;

  ContenuDossierScreen({required this.dossierId, required this.dossierNom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7BF853),
        title: Text(dossierNom, style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Color(0xFFD9F5D0),
        child: Text('Ici, vous pouvez afficher le contenu du dossier'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF7BF853),
        child: Icon(Icons.add),
        onPressed: () => _ajouterDocumentPDF(context),
      ),
    );
  }

  Future<void> _ajouterDocumentPDF(BuildContext context) async {
    print("Appel de la méthode _ajouterDocumentPDF");

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;
      String userId = FirebaseAuth.instance.currentUser!.uid;

      try {
        // Créez une référence au fichier dans Firebase Storage
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('dossiers/$userId/$dossierId/$fileName');

        // Téléchargez le fichier dans Firebase Storage
        await storageRef.putFile(file);

        // Récupérez l'URL du fichier téléchargé
        String fileURL = await storageRef.getDownloadURL();

        // Enregistrez les métadonnées du fichier dans Firestore
        await FirebaseFirestore.instance
            .collection('dossiers')
            .doc(dossierId)
            .collection('documents')
            .add({
          'nom': fileName,
          'url': fileURL,
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Document ajouté avec succès.")));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur lors de l'ajout du document.")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Aucun fichier sélectionné.")));
    }
  }
}
