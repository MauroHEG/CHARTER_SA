import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReservationsListPage extends StatefulWidget {
  @override
  _ReservationsListPageState createState() => _ReservationsListPageState();
}

class _ReservationsListPageState extends State<ReservationsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des réservations'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('reservations').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Dismissible(
                key: Key(document.id),
                onDismissed: (direction) {
                  FirebaseFirestore.instance
                      .collection('reservations')
                      .doc(document.id)
                      .delete();
                },
                background: Container(color: Colors.red),
                child: ListTile(
                  title: Text('Réservation ${document.id}'),
                  subtitle: Text(
                      'Utilisateur: ${data['utilisateur']}\nHôtel: ${data['nomHotel']}\nDates: ${data['dateDebut']} - ${data['dateFin']}'),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
