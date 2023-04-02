import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

class ContenuDossierScreen extends StatefulWidget {
  final String dossierId;
  final String dossierNom;

  ContenuDossierScreen({required this.dossierId, required this.dossierNom});

  @override
  _ContenuDossierScreenState createState() => _ContenuDossierScreenState();
}

class _ContenuDossierScreenState extends State<ContenuDossierScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dossierNom),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: () async {
                bool permissionAccordee = await _demandePermissionStockage();
                if (permissionAccordee) {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                          type: FileType.custom, allowedExtensions: ['pdf']);

                  if (result != null) {
                    File file = File(result.files.single.path!);
                    await uploadPdf(file);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'La permission de lecture du stockage externe est refusée')));
                }
              },
              icon: Icon(Icons.add),
              label: Text('Ajouter un PDF'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _demandePermissionStockage() async {
    PermissionStatus status = await Permission.storage.status;
    if (status.isDenied) {
      PermissionStatus nouvellePermission = await Permission.storage.request();
      if (nouvellePermission.isGranted) {
        return true;
      } else {
        return false;
      }
    } else if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> uploadPdf(File file) async {
    try {
      String fileName = file.path.split('/').last;
      Reference reference = FirebaseStorage.instance
          .ref()
          .child('utilisateurs/${widget.dossierId}/$fileName');
      UploadTask uploadTask = reference.putFile(file);
      await uploadTask.whenComplete(() => null);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fichier PDF ajouté avec succès')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Erreur lors de l'ajout du fichier PDF : $e")));
    }
  }
}
