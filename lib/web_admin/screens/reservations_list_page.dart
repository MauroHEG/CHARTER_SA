import 'package:charter_appli_travaux_mro/web_admin/screens/reservation_detail_page.dart';
import 'package:charter_appli_travaux_mro/web_admin/screens/reservation_form_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationsListPage extends StatefulWidget {
  const ReservationsListPage({super.key});

  @override
  _ReservationsListPageState createState() => _ReservationsListPageState();
}

class _ReservationsListPageState extends State<ReservationsListPage> {
  CollectionReference reservations =
      FirebaseFirestore.instance.collection('reservations');
  String searchCountryString = "";

  Future<void> deleteReservation(String id) async {
    await reservations.doc(id).delete();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des réservations'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchCountryString = value.toLowerCase();
                });
              },
              decoration: const InputDecoration(
                  labelText: "Rechercher par pays",
                  suffixIcon: Icon(Icons.search)),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: reservations.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Une erreur s\'est produite');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                // Filtrer les réservations par le nom du pays
                final results = snapshot.data!.docs.where((res) {
                  final reservationData = res.data() as Map<String, dynamic>;
                  final countryNameMatches = reservationData['nomPays']
                      .toString()
                      .toLowerCase()
                      .contains(searchCountryString);
                  return countryNameMatches;
                }).toList();

                return ListView(
                  children: results.map((DocumentSnapshot document) {
                    Map<String, dynamic> donnees =
                        document.data() as Map<String, dynamic>;
                    return InkWell(
                      onTap: () {
                        // Naviguer vers la page de détail de la réservation
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReservationDetailPage(
                              reservationData: donnees,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(donnees['nomPays']),
                        subtitle: FutureBuilder<String>(
                          future: getUserName(donnees['utilisateur']),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.hasData) {
                              return Text(snapshot.data!);
                            } else if (snapshot.hasError) {
                              return Text('Erreur: ${snapshot.error}');
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirmer la suppression'),
                                  content: const Text(
                                      'Voulez-vous vraiment supprimer cette réservation ?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('ANNULER'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('CONFIRMER'),
                                      onPressed: () {
                                        // Supprimer la réservation de la base de données
                                        FirebaseFirestore.instance
                                            .collection('reservations')
                                            .doc(document.id)
                                            .delete();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
// Naviguer vers la page de formulaire de réservation
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReservationFormPage(),
            ),
          );
        },
        tooltip: 'Créer une réservation',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<String> getUserName(String userId) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('utilisateurs')
        .doc(userId)
        .get();
    return (userSnapshot.data() as Map<String, dynamic>)['nom'];
  }
}
