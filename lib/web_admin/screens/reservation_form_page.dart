import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationFormPage extends StatefulWidget {
  final Map<String, dynamic>? reservationData;
  final bool isEditMode;

  const ReservationFormPage(
      {super.key, this.reservationData, this.isEditMode = false});

  @override
  _ReservationFormPageState createState() => _ReservationFormPageState();
}

class _ReservationFormPageState extends State<ReservationFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _descriptionVoyageController = TextEditingController();
  TextEditingController _prixPayeController = TextEditingController();

  @override
  void dispose() {
    _descriptionVoyageController.dispose();
    _prixPayeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.isEditMode && widget.reservationData != null) {
      _selectedUser = widget.reservationData!['utilisateur'];
      _nomHotel = widget.reservationData!['nomHotel'];
      _nomPays = widget.reservationData!['nomPays'];
      _nomVille = widget.reservationData!['nomVille'];
      _localisationAeroportDepart =
          widget.reservationData!['localisationAeroportDepart'];
      _localisationAeroportArrivee =
          widget.reservationData!['localisationAeroportArrivee'];
      _adresseHotel = widget.reservationData!['adresseHotel'];
      _descriptionVoyage = widget.reservationData!['descriptionVoyage'];
      _prixPaye = widget.reservationData!['prixPaye'];
      _heureDecollageDepart = TimeOfDay.fromDateTime(
          DateTime.parse(widget.reservationData!['heureDecollageDepart']));
      _heureDecollageArrivee = TimeOfDay.fromDateTime(
          DateTime.parse(widget.reservationData!['heureDecollageArrivee']));
      _dateDebut = widget.reservationData!['dateDebut'].toDate();
      _dateFin = widget.reservationData!['dateFin'].toDate();
      _isOffer = widget.reservationData!['isOffer']; // Ajouté

      _descriptionVoyageController.text = _descriptionVoyage!;
      _prixPayeController.text = _prixPaye.toString();
    }
  }

  // Variables pour stocker les données du formulaire
  String? _selectedUser;
  String? _nomHotel;
  String? _nomPays;
  String? _nomVille;
  String? _localisationAeroportDepart;
  String? _localisationAeroportArrivee;
  String? _adresseHotel;
  String? _descriptionVoyage;
  DateTime? _dateDebut;
  DateTime? _dateFin;
  double? _prixPaye;
  TimeOfDay? _heureDecollageDepart;
  TimeOfDay? _heureDecollageArrivee;
  bool _isOffer = false; // Ajouté
  String? _selectedOffer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une réservation'),
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
                        return const CircularProgressIndicator();
                      }

                      List<DropdownMenuItem<String>> userList =
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        return DropdownMenuItem<String>(
                          value: document.id,
                          child: Text(document['nom']),
                        );
                      }).toList();

                      return DropdownButtonFormField<String>(
                        decoration:
                            const InputDecoration(labelText: 'Utilisateur'),
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
                    decoration:
                        const InputDecoration(labelText: "Nom de l'hôtel"),
                    onChanged: (value) => _nomHotel = value,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Pays"),
                    onChanged: (value) => _nomPays = value,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Ville"),
                    onChanged: (value) => _nomVille = value,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Localisation de l'aéroport de départ"),
                    onChanged: (value) => _localisationAeroportDepart = value,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Localisation de l'aéroport d'arrivée"),
                    onChanged: (value) => _localisationAeroportArrivee = value,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Adresse de l'hôtel"),
                    onChanged: (value) => _adresseHotel = value,
                  ),
                  TextFormField(
                    controller: _descriptionVoyageController,
                    decoration: const InputDecoration(
                        labelText: "Description du voyage"),
                    onChanged: (value) => _descriptionVoyage = value,
                  ),
                  TextFormField(
                    controller: _prixPayeController,
                    decoration: const InputDecoration(labelText: "Prix payé"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _prixPaye = double.parse(value),
                  ),
                  CheckboxListTile(
                    title: const Text('Offre spéciale?'),
                    value: _isOffer,
                    onChanged: (bool? value) {
                      setState(() {
                        _isOffer = value!;
                      });
                    },
                  ),
                  // Ajoutez ici le FutureBuilder pour le champ Offre Spéciale
                  FutureBuilder<QuerySnapshot>(
                    future:
                        FirebaseFirestore.instance.collection('offres').get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      List<DropdownMenuItem<String>> offerList =
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        return DropdownMenuItem<String>(
                          value: document.id,
                          child: Text(document['titre']),
                        );
                      }).toList();

                      return Visibility(
                        visible: _isOffer ?? false,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              labelText: 'Offre Spéciale'),
                          items: offerList,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedOffer = value;

                              // Récupère l'offre sélectionnée
                              DocumentSnapshot selectedOfferDoc =
                                  snapshot.data!.docs.firstWhere(
                                      (doc) => doc.id == _selectedOffer);

                              // Met à jour les champs avec les informations de l'offre sélectionnée
                              _prixPaye = selectedOfferDoc['prix'];
                              _dateDebut =
                                  selectedOfferDoc['dateDebut'].toDate();
                              _dateFin = selectedOfferDoc['dateFin'].toDate();
                              _descriptionVoyage =
                                  selectedOfferDoc['description'];

                              // Met à jour les TextEditingController avec les nouvelles valeurs
                              _descriptionVoyageController.text =
                                  _descriptionVoyage!;
                              _prixPayeController.text = _prixPaye.toString();
                            });
                          },
                          value: _selectedOffer,
                        ),
                      );
                    },
                  ),
                  // Date de début
                  ListTile(
                    title: Text(
                        "Date de début: ${_dateDebut != null ? DateFormat('dd/MM/yyyy').format(_dateDebut!) : 'Sélectionner la date'}"),
                    onTap: () async {
                      DateTime? dateSelectionnee = await showDatePicker(
                        context: context,
                        initialDate: _dateDebut ?? DateTime.now(),
                        firstDate: DateTime(DateTime.now().year - 5),
                        lastDate: DateTime(DateTime.now().year + 5),
                      );
                      if (dateSelectionnee != null) {
                        setState(() {
                          _dateDebut = dateSelectionnee;
                        });
                      }
                    },
                  ),
                  // Date de fin
                  ListTile(
                    title: Text(
                        "Date de fin: ${_dateFin != null ? DateFormat('dd/MM/yyyy').format(_dateFin!) : 'Sélectionner la date'}"),
                    onTap: () async {
                      DateTime? dateSelectionnee = await showDatePicker(
                        context: context,
                        initialDate: _dateFin ?? DateTime.now(),
                        firstDate: DateTime(DateTime.now().year - 5),
                        lastDate: DateTime(DateTime.now().year + 5),
                      );
                      if (dateSelectionnee != null) {
                        setState(() {
                          _dateFin = dateSelectionnee;
                        });
                      }
                    },
                  ),
                  // Heure de décollage départ
                  ListTile(
                    title: Text(
                        "Heure de décollage départ: ${_heureDecollageDepart != null ? _heureDecollageDepart!.format(context) : 'Sélectionner l\'heure'}"),
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
                        "Heure de décollage arrivée: ${_heureDecollageArrivee != null ? _heureDecollageArrivee!.format(context) : 'Sélectionner l\'heure'}"),
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
                  // Bouton pour soumettre le formulaire
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Si le formulaire est valide, affiche un Snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Traitement des données')));

                          Map<String, dynamic> data = {
                            'utilisateur': _selectedUser,
                            'nomHotel': _nomHotel,
                            'nomPays': _nomPays,
                            'nomVille': _nomVille,
                            'localisationAeroportDepart':
                                _localisationAeroportDepart,
                            'localisationAeroportArrivee':
                                _localisationAeroportArrivee,
                            'adresseHotel': _adresseHotel,
                            'descriptionVoyage': _descriptionVoyage,
                            'prixPaye': _prixPaye,
                            'heureDecollageDepart':
                                _heureDecollageDepart!.format(context),
                            'heureDecollageArrivee':
                                _heureDecollageArrivee!.format(context),
                            'dateDebut': _dateDebut,
                            'dateFin': _dateFin,
                            'isOffer': _isOffer, // Ajouté
                          };

                          if (widget.isEditMode) {
                            FirebaseFirestore.instance
                                .collection('reservations')
                                .doc(widget.reservationData!['id'])
                                .update(data);
                          } else {
                            FirebaseFirestore.instance
                                .collection('reservations')
                                .add(data);
                          }

                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Soumettre'),
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
