import 'package:charter_appli_travaux_mro/models/reservation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReservationScreen extends StatefulWidget {
  final String userId;

  ReservationScreen({required this.userId});

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  late final Stream<QuerySnapshot> _reservationsStream;

  @override
  void initState() {
    super.initState();
    _reservationsStream = FirebaseFirestore.instance
        .collection('utilisateurs')
        .doc(widget.userId)
        .collection('reservations')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7BF853),
        title: Text("Mes réservations", style: TextStyle(color: Colors.black)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _reservationsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<Reservation> reservations =
              snapshot.data!.docs.map((DocumentSnapshot document) {
            return Reservation.fromMap(document.data() as Map<String, dynamic>);
          }).toList();

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  title: Text(
                    'Réservation ${index + 1} - ${reservations[index].nomPays} - ${reservations[index].nomVille}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Détails de la réservation'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                Text(
                                    'Nom de l\'hôtel : ${reservations[index].nomHotel}',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 8),
                                Text('Pays : ${reservations[index].nomPays}',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 8),
                                Text('Ville : ${reservations[index].nomVille}',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 8),
                                Text(
                                    'Adresse de l\'hôtel : ${reservations[index].adresseHotel}',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 8),
                                Text(
                                    'Prix payé : ${reservations[index].prixPaye} €',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 8),
                                Text(
                                    'Heure de décollage de l\'avion (départ) : ${reservations[index].heureDecollageDepart}',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 8),
                                Text(
                                    'Heure de décollage de l\'avion (arrivée) : ${reservations[index].heureDecollageArrivee}',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 8),
                                Text(
                                    'Localisation de l\'aéroport de départ : ${reservations[index].localisationAeroportDepart}',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 8),
                                Text(
                                    'Localisation de l\'aéroport d\'arrivée : ${reservations[index].localisationAeroportArrivee}',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 8),
                                Text(
                                    'Description du voyage : ${reservations[index].descriptionVoyage}',
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text('Fermer'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
