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
  // Récupérer la collection "reservations" depuis Firebase
  final Stream<QuerySnapshot> _reservationsStream =
      FirebaseFirestore.instance.collection('reservations').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Liste des réservations'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _reservationsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Chargement...');
            }

            // Affichage de la liste des réservations
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
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
        ));
  }

  Future<String> getUserName(String userId) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('utilisateurs')
        .doc(userId)
        .get();
    return (userSnapshot.data() as Map<String, dynamic>)['nom'];
  }
}
