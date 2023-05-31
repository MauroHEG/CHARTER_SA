import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:charter_appli_travaux_mro/view/pdf_view_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:permission_handler/permission_handler.dart';

class ContenuDossierScreen extends StatefulWidget {
  final String dossierId;
  final String dossierNom;

  const ContenuDossierScreen(
      {Key? key, required this.dossierId, required this.dossierNom})
      : super(key: key);

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
            .collection('contenu')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Erreur : ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot fichierSnapshot = snapshot.data!.docs[index];
              return ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: Text(fichierSnapshot.get('nom').split('_').last),
                  onTap: () async {
                    String? url = fichierSnapshot.get('url');
                    String? nom = fichierSnapshot.get('nom');
                    if (url != null && nom != null) {
                      try {
                        // Download the PDF document
                        var dio = Dio();
                        var dir = await getApplicationDocumentsDirectory();
                        var localPath = "${dir.path}/$nom";

                        await dio.download(url, localPath);

                        // Verify if file exists
                        if (await File(localPath).exists()) {
                          print('File downloaded successfully');
                        } else {
                          print('File download failed');
                        }

                        // Open the PDF view page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PdfViewPage(path: localPath)),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Erreur lors du chargement du fichier"),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Erreur lors du téléchargement du fichier"),
                        ),
                      );
                    }
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmation'),
                            content: Text(
                                'Êtes-vous sûr de vouloir supprimer ce fichier?'),
                            actions: [
                              TextButton(
                                child: Text('Annuler'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'Supprimer',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await _supprimerFichier(fichierSnapshot);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _ajouterFichier();
        },
      ),
    );
  }

  Future<void> _ajouterFichier() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      try {
        await _uploadFile(file);
      } catch (e) {
        print(e);
      }
    } else {
      // User canceled the picker
    }
  }

  Future<void> _uploadFile(File file) async {
    String fileName = '${DateTime.now().millisecondsSinceEpoch}_document.pdf';
    Reference storageReference =
        _storage.ref().child('users/$userId/documents/$fileName');
    UploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.whenComplete(() async {
      String fileUrl = await storageReference.getDownloadURL();

      String? newFileName = await showDialog(
        context: context,
        builder: (BuildContext context) {
          String? newName;
          return AlertDialog(
            title: Text('Renommer le fichier (Sans caractères spéciaux !)'),
            content: TextField(
              onChanged: (value) {
                newName = value;
              },
              decoration:
                  InputDecoration(hintText: "Entrez le nouveau nom du fichier"),
            ),
            actions: [
              TextButton(
                child: Text('Annuler'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(newName);
                },
              ),
            ],
          );
        },
      );
      if (newFileName != null && newFileName.isNotEmpty) {
        fileName = newFileName;
      }

      await _firestore
          .collection('utilisateurs')
          .doc(userId)
          .collection('dossiers')
          .doc(widget.dossierId)
          .collection('contenu')
          .add({'nom': fileName, 'url': fileUrl});
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<void> _supprimerFichier(DocumentSnapshot fichierSnapshot) async {
    // Supprimer le fichier du stockage Firebase
    String filePath = fichierSnapshot.get('url').replaceAll(
        new RegExp(
            r'https://firebasestorage.googleapis.com/v0/b/charter-bd51b.appspot.com/o/'),
        '');
    filePath = Uri.decodeFull(filePath.split('?')[0]); // ajoutez cette ligne
    print(filePath); // imprimer le chemin du fichier pour le débogage
    await _storage.ref().child(filePath).delete();

    // Supprimer le document de Firestore
    await fichierSnapshot.reference.delete();
  }
}
