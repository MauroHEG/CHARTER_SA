import 'package:charter_appli_travaux_mro/view/services/reservation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class ReservationDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> reservationDetails;

  ReservationDetailsScreen({super.key, required this.reservationDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BF853),
        title: const Text(
          'Détails de la réservation',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
            InkWell(
              onTap: () => _ouvrirMaps(reservationDetails['adresseHotel']),
              child: _buildDetailItem(
                  icon: FontAwesomeIcons.mapMarkerAlt,
                  label: 'Adresse de l\'hôtel',
                  value: reservationDetails['adresseHotel']),
            ),
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
            _buildDetailItem(
              icon: FontAwesomeIcons.calendarAlt,
              label: 'Date de début',
              value: reservationDetails['dateDebut'] != null
                  ? DateFormat('dd/MM/yyyy').format(
                      (reservationDetails['dateDebut'] as Timestamp).toDate())
                  : 'Pas de date de début spécifiée',
            ),
            _buildDetailItem(
              icon: FontAwesomeIcons.calendarAlt,
              label: 'Date de fin',
              value: reservationDetails['dateFin'] != null
                  ? DateFormat('dd/MM/yyyy').format(
                      (reservationDetails['dateFin'] as Timestamp).toDate())
                  : 'Pas de date de fin spécifiée',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _ouvrirMaps(String adresse) async {
    String url = 'https://www.google.com/maps/search/?api=1&query=$adresse';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Impossible de lancer l\'URL $url';
    }
  }

  Widget _buildDetailItem(
      {required IconData icon, required String label, required String value}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: FaIcon(icon, size: 24),
        title: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
