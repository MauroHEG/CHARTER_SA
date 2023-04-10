import 'package:charter_appli_travaux_mro/web_admin/screens/reservation_form_page.dart';
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
        stream: FirebaseFirestore.instance
            .collection('reservations')
            .orderBy('pays')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Group reservations by country
          Map<String, List<QueryDocumentSnapshot>> reservationsParPays = {};
          for (var doc in snapshot.data!.docs) {
            final pays = doc['pays'];
            if (reservationsParPays.containsKey(pays)) {
              reservationsParPays[pays]!.add(doc);
            } else {
              reservationsParPays[pays] = [doc];
            }
          }

          return ListView(
            children: reservationsParPays.keys.map((pays) {
              return ListTile(
                title: Text(pays),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservationsParVillePage(
                          pays, reservationsParPays[pays]!),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReservationFormPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

class ReservationsParVillePage extends StatelessWidget {
  final String pays;
  final List<QueryDocumentSnapshot> reservations;

  ReservationsParVillePage(this.pays, this.reservations);

  @override
  Widget build(BuildContext context) {
    Map<String, List<QueryDocumentSnapshot>> reservationsParVille = {};
    for (var doc in reservations) {
      final ville = doc['ville'];
      if (reservationsParVille.containsKey(ville)) {
        reservationsParVille[ville]!.add(doc);
      } else {
        reservationsParVille[ville] = [doc];
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Réservations en $pays'),
      ),
      body: ListView(
        children: reservationsParVille.entries.map((entry) {
          String ville = entry.key;
          List<QueryDocumentSnapshot> reservations = entry.value;

          return ExpansionTile(
            title: Text(ville),
            children: reservations.map((doc) {
              Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
              return Dismissible(
                key: Key(doc.id),
                onDismissed: (direction) {
                  FirebaseFirestore.instance
                      .collection('reservations')
                      .doc(doc.id)
                      .delete();
                },
                background: Container(color: Colors.red),
                child: ListTile(
                  title: Text('Réservation ${doc.id}'),
                  subtitle: Text(
                      'Utilisateur: ${data['utilisateur']}\nHôtel: ${data['nomHotel']}\nDates: ${data['dateDebut']} - ${data['dateFin']}'),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
