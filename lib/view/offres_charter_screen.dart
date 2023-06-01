import 'package:charter_appli_travaux_mro/view/services/offre_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'offre_detail_screen.dart';

class OffresCharterScreen extends StatefulWidget {
  @override
  _OffresCharterScreenState createState() => _OffresCharterScreenState();
}

class _OffresCharterScreenState extends State<OffresCharterScreen> {
  late Stream<QuerySnapshot> _offresStream;
  final _offreService = OffreService();

  @override
  void initState() {
    super.initState();
    _offresStream = _offreService.getOffresStreamClient();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BF853),
        title:
            const Text("Offres Charter", style: TextStyle(color: Colors.black)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _offresStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot offre = snapshot.data!.docs[index];

              return Card(
                child: ListTile(
                  title: Text(
                    offre.get('titre'),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OffreDetailScreen(offre: offre),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
