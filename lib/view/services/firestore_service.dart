import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  Stream<QuerySnapshot> getDossiers() {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;

    return _firestore
        .collection('utilisateurs')
        .doc(_auth.currentUser!.uid)
        .collection('dossiers')
        .snapshots();
  }

  Stream<QuerySnapshot> getDocuments(String dossierId) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;

    return _firestore
        .collection('utilisateurs')
        .doc(_auth.currentUser!.uid)
        .collection('dossiers')
        .doc(dossierId)
        .collection('documents')
        .snapshots();
  }
}
