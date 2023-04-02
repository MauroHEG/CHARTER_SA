import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReservationFormPage extends StatefulWidget {
  @override
  _ReservationFormPageState createState() => _ReservationFormPageState();
}

class _ReservationFormPageState extends State<ReservationFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variables pour stocker les données du formulaire
  String? _selectedUser;
  String? _nomHotel;
  String? _localisationAeroportDepart;
  String? _localisationAeroportArrivee;
  String? _adresseHotel;
  String? _descriptionVoyage;
  DateTime? _dateDebut;
  DateTime? _dateFin;
  double? _prixPaye;
  TimeOfDay? _heureDecollageDepart;
  TimeOfDay? _heureDecollageArrivee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer une réservation'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Champ pour la liste des utilisateurs
                  FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('utilisateurs')
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      List<DropdownMenuItem<String>> userList =
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        return DropdownMenuItem<String>(
                          value: document.id,
                          child: Text(document['nom']),
                        );
                      }).toList();

                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Utilisateur'),
                        items: userList,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedUser = value;
                          });
                        },
                        value: _selectedUser,
                      );
                    },
                  ),
                  // Les autres champs du formulaire
                  TextFormField(
                    decoration: InputDecoration(labelText: "Nom de l'hôtel"),
                    onChanged: (value) => _nomHotel = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Localisation de l'aéroport de départ"),
                    onChanged: (value) => _localisationAeroportDepart = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Localisation de l'aéroport d'arrivée"),
                    onChanged: (value) => _localisationAeroportArrivee = value,
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: "Adresse de l'hôtel"),
                    onChanged: (value) => _adresseHotel = value,
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: "Description du voyage"),
                    onChanged: (value) => _descriptionVoyage = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Prix payé"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _prixPaye = double.parse(value),
                  ),
                  // Heure de décollage départ
                  ListTile(
                    title: Text(
                        "Heure de décollage départ: ${_heureDecollageDepart?.format(context) ?? 'Sélectionner l\'heure'}"),
                    onTap: () async {
                      TimeOfDay? heureSelectionnee = await showTimePicker(
                        context: context,
                        initialTime: _heureDecollageDepart ?? TimeOfDay.now(),
                      );
                      if (heureSelectionnee != null) {
                        setState(() {
                          _heureDecollageDepart = heureSelectionnee;
                        });
                      }
                    },
                  ),
                  // Heure de décollage arrivée
                  ListTile(
                    title: Text(
                        "Heure de décollage arrivée: ${_heureDecollageArrivee?.format(context) ?? 'Sélectionner l\'heure'}"),
                    onTap: () async {
                      TimeOfDay? heureSelectionnee = await showTimePicker(
                        context: context,
                        initialTime: _heureDecollageArrivee ?? TimeOfDay.now(),
                      );
                      if (heureSelectionnee != null) {
                        setState(() {
                          _heureDecollageArrivee = heureSelectionnee;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  // Bouton de création de réservation
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Ajouter la réservation à Firebase
                          FirebaseFirestore.instance
                              .collection('reservations')
                              .add({
                            'utilisateur': _selectedUser,
                            'nomHotel': _nomHotel,
                            'localisationAeroportDepart':
                                _localisationAeroportDepart,
                            'localisationAeroportArrivee':
                                _localisationAeroportArrivee,
                            'adresseHotel': _adresseHotel,
                            'descriptionVoyage': _descriptionVoyage,
                            'dateDebut': _dateDebut,
                            'dateFin': _dateFin,
                            'prixPaye': _prixPaye,
                            'heureDecollageDepart':
                                _heureDecollageDepart?.format(context),
                            'heureDecollageArrivee':
                                _heureDecollageArrivee?.format(context),
                          }).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Réservation créée'),
                              ),
                            );
                            Navigator.pop(context);
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erreur: $error'),
                              ),
                            );
                          });
                        }
                      },
                      child: Text(
                        'Créer la réservation',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(16),
                      ),
                    ),
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
