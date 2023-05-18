import 'package:flutter/material.dart';
import 'package:charter_appli_travaux_mro/models/review.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // ajoutez cette dépendance à votre pubspec.yaml

class ReviewScreen extends StatefulWidget {
  final String destination;
  final String ville;

  ReviewScreen({required this.destination, required this.ville});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _avisController = TextEditingController();
  double _rating = 0;
  List<String> _images = []; // Vous devrez implémenter le choix des images

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publier un avis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Destination : ${widget.destination}'),
              Text('Ville : ${widget.ville}'),
              TextFormField(
                controller: _titreController,
                decoration: const InputDecoration(
                  labelText: 'Titre',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _avisController,
                decoration: const InputDecoration(
                  labelText: 'Avis',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un avis';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
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
              // Ajouter le widget pour choisir les images ici
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Sauvegardez l'avis
                    var review = Review(
                      destination: widget.destination,
                      ville: widget.ville,
                      titre: _titreController.text,
                      avis: _avisController.text,
                      note: _rating.round(),
                      images: _images,
                    );
                    // Ici vous pouvez appeler votre fonction pour sauvegarder l'avis dans la base de données
                    print(review.toMap());
                  }
                },
                child: Text('Publier l\'avis'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
