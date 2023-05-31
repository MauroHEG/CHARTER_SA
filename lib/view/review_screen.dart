import 'package:charter_appli_travaux_mro/models/avis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
      body: Center(
        // Center content vertically
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center content horizontally
                children: <Widget>[
                  Text(
                    '${widget.reservationDetails['nomPays']} - ${widget.reservationDetails['nomVille']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Card(
                    // Using card for better UI
                    child: TextFormField(
                      controller: _titreController,
                      decoration: InputDecoration(
                        labelText: 'Titre',
                        contentPadding: EdgeInsets.all(
                            10.0), // Padding inside TextFormField
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un titre pour l\'avis.';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Card(
                    // Using card for better UI
                    child: TextFormField(
                      controller: _avisController,
                      decoration: InputDecoration(
                        labelText: 'Avis',
                        contentPadding: EdgeInsets.all(
                            10.0), // Padding inside TextFormField
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un avis.';
                        }
                        return null;
                      },
                    ),
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
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Avis avis = Avis(
                          userId: widget.userId,
                          destination: widget.reservationDetails['nomPays'],
                          ville: widget.reservationDetails['nomVille'],
                          titre: _titreController.text,
                          avis: _avisController.text,
                          note: _rating.round(),
                        );

                        FirebaseFirestore.instance.collection('avis').add({
                          'userId': widget.userId,
                          'destination': avis.destination,
                          'ville': avis.ville,
                          'titre': avis.titre,
                          'avis': avis.avis,
                          'note': avis.note,
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
      ),
    );
  }
}
