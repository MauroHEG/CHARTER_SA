import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardService {
  Future<int> getNombreTotalUtilisateurs() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('utilisateurs').get();
    return querySnapshot.size;
  }

  Future<int> getNombreTotalAvis() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('avis').get();
    return querySnapshot.size;
  }

  Future<int> getNombreTotalReservations() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('reservations').get();
    return querySnapshot.size;
  }

  Future<int> getNombreTotalOffres() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('offres').get();
    return querySnapshot.size;
  }

  Future<List<int>> getReservationsParMois() async {
    List<int> reservationsParMois =
        List.filled(12, 0); // Initialiser la liste avec zéro
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('reservations').get();

    for (var doc in querySnapshot.docs) {
      DateTime dateDebut =
          (doc.data() as Map<String, dynamic>)['dateDebut'].toDate();
      int mois = dateDebut.month - 1; // Ajuster l'index car il commence à 0
      reservationsParMois[mois]++;
    }
    return reservationsParMois;
  }

  Future<List<int>> getReservationsAvecOffreParMois() async {
    List<int> reservationsAvecOffreParMois = List.filled(12, 0);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('reservations')
        .where('isOffer', isEqualTo: true)
        .get();

    for (var doc in querySnapshot.docs) {
      DateTime date =
          (doc.data() as Map<String, dynamic>)['dateDebut'].toDate();
      reservationsAvecOffreParMois[date.month - 1]++;
    }

    return reservationsAvecOffreParMois;
  }

  Future<List<int>> getReservationsStandardParMois() async {
    List<int> reservationsStandardParMois = List.filled(12, 0);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('reservations')
        .where('isOffer', isEqualTo: false)
        .get();

    for (var doc in querySnapshot.docs) {
      DateTime date =
          (doc.data() as Map<String, dynamic>)['dateDebut'].toDate();
      reservationsStandardParMois[date.month - 1]++;
    }

    return reservationsStandardParMois;
  }
}
