import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class OffresListPage extends StatefulWidget {
  @override
  _OffresListPageState createState() => _OffresListPageState();
}

class _OffresListPageState extends State<OffresListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des offres'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('offres').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Erreur : ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              DateTime expirationDate = data['date_expiration'].toDate();
              bool offreExpiree =
                  expirationDate.difference(DateTime.now()).inDays < 7;
              return Container(
                decoration: BoxDecoration(
                  color: offreExpiree ? Colors.red.shade100 : Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(5),
                child: ListTile(
                  title: Text(data['titre_aguicheur']),
                  subtitle: Text(
                      'Réservations: ${data['nombre_reservations']} | Expiration: ${DateFormat('dd/MM/yyyy').format(expirationDate)}'),
                  onTap: () {
                    // Ajouter une action pour ouvrir une page détaillée de l'offre
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _nouvelleOffre(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _nouvelleOffre(BuildContext context) async {
    TextEditingController paysController = TextEditingController();
    TextEditingController villeController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController titreAguicheurController = TextEditingController();
    TextEditingController prixController = TextEditingController();
    DateTime? dateExpiration;
    List<File>? imagesFiles;
    File? brochureFile;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nouvelle offre'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: paysController,
                  decoration: InputDecoration(labelText: 'Pays'),
                ),
                TextField(
                  controller: villeController,
                  decoration: InputDecoration(labelText: 'Ville'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: titreAguicheurController,
                  decoration: InputDecoration(labelText: 'Titre aguicheur'),
                ),
                TextField(
                  controller: prixController,
                  decoration: InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 5),
                    );
                    if (pickedDate != null) {
                      dateExpiration = pickedDate;
                    }
                  },
                  child: Text(dateExpiration == null
                      ? 'Sélectionner une date d\'expiration'
                      : 'Date d\'expiration : ${DateFormat('dd/MM/yyyy').format(dateExpiration!)}'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    imagesFiles =
                        (await ImagePicker().pickMultiImage()).cast<File>();
                  },
                  child: Text('Sélectionner des images'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );
                    if (result != null) {
                      brochureFile = File(result.files.single.path!);
                    }
                  },
                  child: Text('Sélectionner une brochure PDF'),
                ),
              ],
            ),
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
                if (paysController.text.isNotEmpty &&
                    villeController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    titreAguicheurController.text.isNotEmpty &&
                    dateExpiration != null &&
                    prixController.text.isNotEmpty &&
                    imagesFiles != null &&
                    brochureFile != null) {
                  CollectionReference offres =
                      FirebaseFirestore.instance.collection('offres');

                  // Téléchargez les images et la brochure PDF sur Firebase Storage et récupérez les URL
                  List<String> imagesUrls = [];
                  for (File imageFile in imagesFiles!) {
                    String imageUrl = await _uploadFile(imageFile.path);
                    imagesUrls.add(imageUrl);
                  }
                  String brochureUrl = await _uploadFile(brochureFile!.path);

                  await offres.add({
                    'pays': paysController.text.trim(),
                    'ville': villeController.text.trim(),
                    'description': descriptionController.text.trim(),
                    'titre_aguicheur': titreAguicheurController.text.trim(),
                    'date_expiration': Timestamp.fromDate(dateExpiration!),
                    'prix': double.parse(prixController.text.trim()),
                    'images_urls': imagesUrls,
                    'brochure_url': brochureUrl,
                    'nombre_reservations': 0,
                  });

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _uploadFile(String filePath) async {
    File file = File(filePath);
    String fileName = filePath.split('/').last;
    Reference storageReference =
        FirebaseStorage.instance.ref().child('offres/$fileName');
    UploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.whenComplete(() => null);
    return await storageReference.getDownloadURL();
  }
}
