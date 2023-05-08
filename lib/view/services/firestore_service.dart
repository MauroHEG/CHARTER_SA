import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  Stream<QuerySnapshot> getDossiers() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    return firestore
        .collection('utilisateurs')
        .doc(auth.currentUser!.uid)
        .collection('dossiers')
        .snapshots();
  }

  Stream<QuerySnapshot> getDocuments(String dossierId) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    return firestore
        .collection('utilisateurs')
        .doc(auth.currentUser!.uid)
        .collection('dossiers')
        .doc(dossierId)
        .collection('documents')
        .snapshots();
  }
}
