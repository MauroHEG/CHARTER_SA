import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReviewsListPage extends StatefulWidget {
  const ReviewsListPage({super.key});

  @override
  _ReviewsListPageState createState() => _ReviewsListPageState();
}

class _ReviewsListPageState extends State<ReviewsListPage> {
  CollectionReference reviews = FirebaseFirestore.instance.collection('avis');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des avis'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: reviews.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Une erreur s'est produite");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.rate_review),
                  ),
                  title: Text(data['titre'] ?? 'Pas de titre'),
                  subtitle: Text(data['commentaire'] ?? 'Pas de commentaire'),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
