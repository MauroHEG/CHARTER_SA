import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'offres_detail_page.dart';
import 'offre_form_page.dart';

class OffresListPage extends StatefulWidget {
  @override
  _OffresListPageState createState() => _OffresListPageState();
}

class _OffresListPageState extends State<OffresListPage> {
  final Stream<QuerySnapshot> _offresStream =
      FirebaseFirestore.instance.collection('offres').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des offres'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _offresStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Erreur: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Chargement...');
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OffreDetailPage(
                        offreData: data,
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(data['titre']),
                  subtitle: Text('Prix: ${data['prix']}'),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OffreFormPage(),
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Créer une offre',
      ),
    );
  }
}
