import 'package:charter_appli_travaux_mro/models/avis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import 'dart:io';

class ReviewScreen extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> reservationDetails;

  const ReviewScreen(
      {Key? key, required this.userId, required this.reservationDetails})
      : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _avisController = TextEditingController();
  double _rating = 3;
  List<File> _images = [];
  List<String> _imageUrls = [];

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _images.add(File(image.path));
      });
    }
  }

  Future<void> _uploadImages() async {
    for (var image in _images) {
      String fileName = Path.basename(image.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      _imageUrls.add(downloadUrl);
    }
  }

  @override
  void dispose() {
    _titreController.dispose();
    _avisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publier un avis'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text('Destination: ${widget.reservationDetails['nomPays']}'),
                Text('Ville: ${widget.reservationDetails['nomVille']}'),
                TextFormField(
                  controller: _titreController,
                  decoration: InputDecoration(
                    labelText: 'Titre',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un titre pour l\'avis.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _avisController,
                  decoration: InputDecoration(
                    labelText: 'Avis',
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un avis.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    _rating = rating;
                  },
                ),
                SizedBox(height: 16.0),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: _images.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    if (index == _images.length) {
                      return IconButton(
                        icon: Icon(Icons.add_a_photo),
                        onPressed: _pickImage,
                      );
                    }
                    return Image.file(_images[index]);
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await _uploadImages();
                      Avis avis = Avis(
                        destination: widget.reservationDetails['nomPays'],
                        ville: widget.reservationDetails['nomVille'],
                        titre: _titreController.text,
                        avis: _avisController.text,
                        note: _rating.round(),
                        images: _imageUrls,
                      );

                      FirebaseFirestore.instance.collection('avis').add({
                        'userId': widget.userId,
                        'destination': avis.destination,
                        'ville': avis.ville,
                        'titre': avis.titre,
                        'avis': avis.avis,
                        'note': avis.note,
                        'images': avis.images,
                      });

                      FirebaseFirestore.instance
                          .collection('utilisateurs')
                          .doc(widget.userId)
                          .collection('avis')
                          .add({
                        'destination': avis.destination,
                        'ville': avis.ville,
                        'titre': avis.titre,
                        'avis': avis.avis,
                        'note': avis.note,
                        'images': avis.images,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Avis enregistré avec succès!')));
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Publier l\'avis'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
