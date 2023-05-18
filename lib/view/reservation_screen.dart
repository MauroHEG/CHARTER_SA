import 'package:charter_appli_travaux_mro/models/reservation.dart';
import 'package:charter_appli_travaux_mro/view/review_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charter_appli_travaux_mro/view/reservation_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ReservationScreen extends StatefulWidget {
  final String userId;

  const ReservationScreen({super.key, required this.userId});

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

  void _lancerAppel() async {
    const url = 'tel:+41227343535';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Impossible de lancer l\'appel. Veuillez réessayer.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BF853),
        title: const Text("Mes réservations",
            style: TextStyle(color: Colors.black)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _reservationsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Reservation> reservations =
              snapshot.data!.docs.map((DocumentSnapshot document) {
            return Reservation.fromMap(document.data() as Map<String, dynamic>);
          }).toList();
          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (BuildContext context, int index) {
              DateTime finReservation =
                  (reservations[index].dateFin as Timestamp).toDate();
              bool reservationTerminee = DateTime.now().isAfter(finReservation);

              return Card(
                child: ListTile(
                  title: Text(
                    'Réservation ${index + 1} - ${reservations[index].nomPays} - ${reservations[index].nomVille}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  trailing: ElevatedButton(
                    child: const Text('Poster un avis'),
                    onPressed: reservationTerminee
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewScreen(
                                  userId: widget.userId,
                                  reservationDetails:
                                      reservations[index].toMap(),
                                ),
                              ),
                            );
                          }
                        : null,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservationDetailsScreen(
                          reservationDetails: reservations[index].toMap(),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _lancerAppel,
        tooltip: 'Contactez-nous',
        child: const Icon(Icons.phone),
      ),
    );
  }
}
