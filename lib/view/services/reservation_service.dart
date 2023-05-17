import 'package:charter_appli_travaux_mro/view/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReservationService {
  final UserService _userService = UserService();

  final CollectionReference reservations =
      FirebaseFirestore.instance.collection('reservations');

  Future<void> deleteReservation(String id) async {
    await reservations.doc(id).delete();
  }

  Stream<QuerySnapshot> getReservations() {
    return reservations.snapshots();
  }

  Future<String> fetchUserName(Map<String, dynamic> reservationData) async {
    String userId = reservationData['utilisateur'];
    return await _userService.getUserName(userId);
  }

  String formatDate(Map<String, dynamic> reservationData, String dateType) {
    DateTime date = (reservationData[dateType] as Timestamp).toDate();
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
