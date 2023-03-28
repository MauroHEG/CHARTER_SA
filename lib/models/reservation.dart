class Reservation {
  final String destination;
  final String dateDebut;
  final String dateFin;
  final String hotel;
  final double prix;
  final String heureDepart;
  final String returnTime;
  final String aeroportDepart;
  final String aeroportRetour;
  final String adresseHotel;
  final String descriptionVoyage;

  Reservation({
    required this.destination,
    required this.dateDebut,
    required this.dateFin,
    required this.hotel,
    required this.prix,
    required this.heureDepart,
    required this.returnTime,
    required this.aeroportDepart,
    required this.aeroportRetour,
    required this.adresseHotel,
    required this.descriptionVoyage,
  });
}
