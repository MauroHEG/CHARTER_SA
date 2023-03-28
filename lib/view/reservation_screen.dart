import 'package:flutter/material.dart';
import '../models/reservation.dart';

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

//IL FAUDRA AJOUTER LES CONDITIONS DE DATES POUR COMMENTER ET DONNER UN AVIS SUR LE VOYAGE
//SI DATE_AUJD > DATE_FIN ALORS DONNER AVIS

class _ReservationScreenState extends State<ReservationScreen> {
  List<Reservation> reservations = [
    Reservation(
        destination: 'Paris',
        dateDebut: '20/04/2023',
        dateFin: '27/04/2023',
        hotel: 'Hôtel Parisien',
        prix: 1200,
        heureDepart: '08:00',
        returnTime: '18:00',
        aeroportDepart: 'Aéroport de Paris-Charles de Gaulle',
        aeroportRetour: 'Aéroport de retour',
        adresseHotel: '1, Rue Parisienne, Paris',
        descriptionVoyage:
            'Une semaine de vacances à Paris, la ville de l\'amour.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7BF853),
        title: Text('Mes réservations', style: TextStyle(color: Colors.black)),
      ),
      body: ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ExpansionTile(
              title: Text(
                reservations[index].destination,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Dates : ${reservations[index].dateDebut} - ${reservations[index].dateFin}',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text('Nom de l\'hôtel : ${reservations[index].hotel}',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text('Prix payé : ${reservations[index].prix} €',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text(
                          'Heure de décollage de l\'avion : ${reservations[index].heureDepart}',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text(
                          'Localisation de l\'aéroport de départ : ${reservations[index].aeroportDepart}',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text(
                          'Localisation de l\'aéroport d\'arrivée : ${reservations[index].aeroportRetour}',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text(
                          'Adresse de l\'hôtel : ${reservations[index].adresseHotel}',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text(
                          'Description du voyage : ${reservations[index].descriptionVoyage}',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
