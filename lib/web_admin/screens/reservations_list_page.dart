import 'package:charter_appli_travaux_mro/web_admin/screens/reservation_form_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return InkWell(
                  onTap: () {
                    // Naviguer vers la page de détail de la réservation
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservationDetailPage(
                          reservationData: data,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(data['nomPays']),
                    subtitle: Text(data['utilisateur']),
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
}

class ReservationDetailPage extends StatefulWidget {
  final Map<String, dynamic> reservationData;

  const ReservationDetailPage({super.key, required this.reservationData});

  @override
  _ReservationDetailPageState createState() => _ReservationDetailPageState();
}

class _ReservationDetailPageState extends State<ReservationDetailPage> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    fetchUserName();
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
