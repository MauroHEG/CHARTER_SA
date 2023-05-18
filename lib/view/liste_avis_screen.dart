import 'package:charter_appli_travaux_mro/models/avis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ListeAvisScreen extends StatefulWidget {
  @override
  _ListeAvisScreenState createState() => _ListeAvisScreenState();
}

class _ListeAvisScreenState extends State<ListeAvisScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? currentUserId;
  String filterType = 'Tous';
  int? filterNote;

  Future<String> getUserName(String userId) async {
    var document = await _db.collection('utilisateurs').doc(userId).get();
    return '${document.data()?['prenom']} ${document.data()?['nom']}';
  }

  Stream<QuerySnapshot> getAvisStream() {
    Query query = _db.collection('avis');
    switch (filterType) {
      case 'Tous':
        return query.snapshots();
      case 'Par utilisateur':
        return query.where('userId', isEqualTo: currentUserId).snapshots();
      case 'Par note':
        return query.where('note', isEqualTo: filterNote).snapshots();
      default:
        return query.snapshots();
    }
  }

  @override
  void initState() {
    super.initState();
    currentUserId = _auth.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des avis'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String result) {
              setState(() {
                filterType = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Tous',
                child: Text('Tous les avis'),
              ),
              const PopupMenuItem<String>(
                value: 'Par utilisateur',
                child: Text('Mes avis'),
              ),
              const PopupMenuItem<String>(
                value: 'Par note',
                child: Text('Filtrer par note'),
              ),
            ],
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getAvisStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Avis avis = Avis.fromMap(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>);

              return FutureBuilder<String>(
                future: getUserName(
                    avis.userId), // Pass the userId to your function
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              avis.titre ?? 'Pas de titre',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              '${avis.destination} - ${avis.ville}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Écrit par ${snapshot.data}', // Use the data from the Future here
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                            SizedBox(height: 8.0),
                            RatingBarIndicator(
                              rating: avis.note!.toDouble(),
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Erreur : ${snapshot.error}');
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
