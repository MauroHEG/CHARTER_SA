import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final String adresseHotel;
  final String descriptionVoyage;
  final String heureDecollageArrivee;
  final String heureDecollageDepart;
  final String nomHotel;
  final String nomPays;
  final String nomVille;
  final double prixPaye;
  final String localisationAeroportArrivee;
  final String localisationAeroportDepart;
  final Timestamp dateDebut;
  final Timestamp dateFin;

  Reservation(
      {required this.adresseHotel,
      required this.descriptionVoyage,
      required this.heureDecollageArrivee,
      required this.heureDecollageDepart,
      required this.nomHotel,
      required this.nomPays,
      required this.nomVille,
      required this.prixPaye,
      required this.localisationAeroportArrivee,
      required this.localisationAeroportDepart,
      required this.dateDebut,
      required this.dateFin});

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
        adresseHotel: map['adresseHotel'],
        descriptionVoyage: map['descriptionVoyage'],
        heureDecollageArrivee: map['heureDecollageArrivee'],
        heureDecollageDepart: map['heureDecollageDepart'],
        nomHotel: map['nomHotel'],
        nomPays: map['nomPays'],
        nomVille: map['nomVille'],
        prixPaye: map['prixPaye'].toDouble(),
        localisationAeroportArrivee: map['localisationAeroportArrivee'],
        localisationAeroportDepart: map['localisationAeroportDepart'],
        dateDebut: map['dateDebut'],
        dateFin: map['dateFin']);
  }

  Map<String, dynamic> toMap() {
    return {
      'nomHotel': nomHotel,
      'nomPays': nomPays,
      'nomVille': nomVille,
      'adresseHotel': adresseHotel,
      'prixPaye': prixPaye,
      'heureDecollageDepart': heureDecollageDepart,
      'heureDecollageArrivee': heureDecollageArrivee,
      'localisationAeroportDepart': localisationAeroportDepart,
      'localisationAeroportArrivee': localisationAeroportArrivee,
      'descriptionVoyage': descriptionVoyage,
      'dateDebut': dateDebut,
      'dateFin': dateFin
    };
  }
}
