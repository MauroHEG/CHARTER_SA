import 'package:flutter/material.dart';
// Importez le package des icônes Font Awesome
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReservationDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> reservationDetails;

  ReservationDetailsScreen({required this.reservationDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7BF853),
        title: Text(
          'Détails de la réservation',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem(
                icon: FontAwesomeIcons.hotel,
                label: 'Nom de l\'hôtel',
                value: reservationDetails['nomHotel']),
            _buildDetailItem(
                icon: FontAwesomeIcons.mapMarkedAlt,
                label: 'Pays',
                value: reservationDetails['nomPays']),
            _buildDetailItem(
                icon: FontAwesomeIcons.city,
                label: 'Ville',
                value: reservationDetails['nomVille']),
            _buildDetailItem(
                icon: FontAwesomeIcons.mapMarkerAlt,
                label: 'Adresse de l\'hôtel',
                value: reservationDetails['adresseHotel']),
            _buildDetailItem(
                icon: FontAwesomeIcons.moneyBillAlt,
                label: 'Prix payé',
                value: '${reservationDetails['prixPaye']} €'),
            _buildDetailItem(
                icon: FontAwesomeIcons.planeDeparture,
                label: 'Heure de décollage de l\'avion (départ)',
                value: reservationDetails['heureDecollageDepart']),
            _buildDetailItem(
                icon: FontAwesomeIcons.planeArrival,
                label: 'Heure de décollage de l\'avion (arrivée)',
                value: reservationDetails['heureDecollageArrivee']),
            _buildDetailItem(
                icon: FontAwesomeIcons.mapPin,
                label: 'Localisation de l\'aéroport de départ',
                value: reservationDetails['localisationAeroportDepart']),
            _buildDetailItem(
                icon: FontAwesomeIcons.mapPin,
                label: 'Localisation de l\'aéroport d\'arrivée',
                value: reservationDetails['localisationAeroportArrivee']),
            _buildDetailItem(
                icon: FontAwesomeIcons.suitcase,
                label: 'Description du voyage',
                value: reservationDetails['descriptionVoyage']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
      {required IconData icon, required String label, required String value}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: FaIcon(icon, size: 24),
        title: Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
