import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationService {
  final CollectionReference reservations =
      FirebaseFirestore.instance.collection('reservations');

  Future<void> deleteReservation(String id) async {
    await reservations.doc(id).delete();
  }

  Stream<QuerySnapshot> getReservations() {
    return reservations.snapshots();
  }
}
