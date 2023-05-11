import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationDetailPage extends StatefulWidget {
  final Map<String, dynamic> reservationData;

  const ReservationDetailPage({super.key, required this.reservationData});

  @override
  _ReservationDetailPageState createState() => _ReservationDetailPageState();
}

class _ReservationDetailPageState extends State<ReservationDetailPage> {
  String? _userName;
  String? _formattedDateDebut;
  String? _formattedDateFin;

  @override
  void initState() {
    super.initState();
    fetchUserName();
    formatDateDebutFin();
  }

  Future<void> fetchUserName() async {
    String userId = widget.reservationData['utilisateur'];
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('utilisateurs')
        .doc(userId)
        .get();
    setState(() {
      _userName = (userSnapshot.data() as Map<String, dynamic>)['nom'];
    });
  }

  void formatDateDebutFin() {
    DateTime dateDebut =
        (widget.reservationData['dateDebut'] as Timestamp).toDate();
    DateTime dateFin =
        (widget.reservationData['dateFin'] as Timestamp).toDate();

    _formattedDateDebut = DateFormat('dd/MM/yyyy').format(dateDebut);
    _formattedDateFin = DateFormat('dd/MM/yyyy').format(dateFin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de la réservation'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informations générales',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('Nom du pays: ${widget.reservationData['nomPays']}'),
                      const SizedBox(height: 5),
                      Text('Utilisateur: ${_userName ?? 'Chargement...'}'),
                      const SizedBox(height: 5),
                      Text('Date de début: $_formattedDateDebut'),
                      const SizedBox(height: 5),
                      Text('Date de fin: $_formattedDateFin'),
                      const SizedBox(height: 5),
                      Text(
                          "Nom de l'hôtel: ${widget.reservationData['nomHotel']}"),
                      const SizedBox(height: 5),
                      Text('Ville: ${widget.reservationData['nomVille']}'),
                      const SizedBox(height: 5),
                      Text(
                          "Adresse de l'hôtel: ${widget.reservationData['adresseHotel']}"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Détails du voyage',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                          "Description du voyage: ${widget.reservationData['descriptionVoyage']}"),
                      const SizedBox(height: 5),
                      Text("Prix payé: ${widget.reservationData['prixPaye']}"),
                      const SizedBox(height: 5),
                      Text(
                          "Heure de décollage départ: ${widget.reservationData['heureDecollageDepart']}"),
                      const SizedBox(height: 5),
                      Text(
                          "Heure de décollage arrivée: ${widget.reservationData['heureDecollageArrivee']}"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
