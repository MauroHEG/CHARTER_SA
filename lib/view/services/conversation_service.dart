import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getOrCreateConversation(
      String clientId, String adminId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('conversations')
        .where('participants', arrayContains: clientId)
        .get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      List<String> participants = List<String>.from(doc['participants']);
      if (participants.contains(adminId)) {
        return doc.id;
      }
    }

    DocumentReference newConversationRef =
        await _firestore.collection('conversations').add({
      'participants': [clientId, adminId],
    });

    return newConversationRef.id;
  }
}
