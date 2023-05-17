import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('utilisateurs');

  Stream<QuerySnapshot> getUsersStream(String searchString) {
    return searchString.isEmpty
        ? _users.snapshots()
        : _users.orderBy('nom_lower').startAt([searchString]).endAt(
            [searchString + '\uf8ff']).snapshots();
  }

  Future<void> deleteUser(String id) async {
    await _users.doc(id).delete();
  }

  Future<String> getUserName(String userId) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('utilisateurs')
        .doc(userId)
        .get();
    return (userSnapshot.data() as Map<String, dynamic>)['nom'];
  }
}
