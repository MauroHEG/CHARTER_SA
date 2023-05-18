import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReviewsListPage extends StatefulWidget {
  const ReviewsListPage({Key? key}) : super(key: key);

  @override
  _ReviewsListPageState createState() => _ReviewsListPageState();
}

class _ReviewsListPageState extends State<ReviewsListPage> {
  CollectionReference reviews = FirebaseFirestore.instance.collection('avis');

  Future<void> deleteReview(String docId) async {
    return reviews.doc(docId).delete().then((_) => print('Review Deleted'));
  }

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
              int note = data['note'] ?? 0;
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.rate_review),
                  ),
                  title: Text(data['titre'] ?? 'Pas de titre'),
                  subtitle: Text(data['avis'] ?? 'Pas de commentaire'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        note.toString(),
                        style: TextStyle(
                          color: note < 3 ? Colors.red : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirmer la suppression"),
                                content: const Text(
                                    "Êtes-vous sûr de vouloir supprimer cet avis ?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text("ANNULER"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("SUPPRIMER"),
                                    onPressed: () {
                                      deleteReview(document.id);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
