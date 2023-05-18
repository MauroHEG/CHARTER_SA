import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:charter_appli_travaux_mro/view/pdf_view_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ContenuDossierScreen extends StatefulWidget {
  final String dossierId;
  final String dossierNom;

  const ContenuDossierScreen(
      {super.key, required this.dossierId, required this.dossierNom});

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
                  title: Text(fichierSnapshot.get('nom')),
                  onTap: () async {
                    String? url = fichierSnapshot.get('url');
                    String? nom = fichierSnapshot.get('nom');
                    if (url != null && nom != null) {
                      PermissionStatus status = await Permission.storage.status;
                      if (!status.isGranted) {
                        status = await Permission.storage.request();
                      }
                      if (status.isGranted) {
                        var response = await http.get(Uri.parse(url));
                        var documentDir =
                            await getApplicationDocumentsDirectory();
                        var downloadDir =
                            Directory('${documentDir.path}/Download');
                        await downloadDir.create();
                        File file = File('${downloadDir.path}/$nom');
                        await file.writeAsBytes(response.bodyBytes);
                        OpenFile.open(file.path);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Permission de stockage non accordée"),
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
            r'https://firebasestorage.googleapis.com/v0/b/[your-project-id].appspot.com/o/'),
        '');
    filePath = Uri.decodeFull(filePath);
    await _storage.ref().child(filePath).delete();

    // Supprimer le document de Firestore
    await fichierSnapshot.reference.delete();
  }
}
