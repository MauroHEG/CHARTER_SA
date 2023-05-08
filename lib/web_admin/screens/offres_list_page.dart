import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'offres_detail_page.dart';
import 'offre_form_page.dart';

class OffresListPage extends StatefulWidget {
  const OffresListPage({super.key});

  @override
  _OffresListPageState createState() => _OffresListPageState();
}

class _OffresListPageState extends State<OffresListPage> {
  final Stream<QuerySnapshot> _offresStream =
      FirebaseFirestore.instance.collection('offres').snapshots();

  Future<void> _supprimerOffre(String documentId) async {
    await FirebaseFirestore.instance
        .collection('offres')
        .doc(documentId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des offres'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _offresStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Erreur: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Chargement...');
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              DateTime dateDebut = data['dateDebut'].toDate();
              DateTime dateFin = data['dateFin'].toDate();
              bool estProche = currentDate.isBefore(dateDebut);
              bool estExpire = currentDate.isAfter(dateFin);
              if (estExpire) {
                _supprimerOffre(document.id);
              }
              return InkWell(
                onTap: !estProche
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OffreDetailPage(
                              offreData: data,
                            ),
                          ),
                        );
                      }
                    : null,
                child: ListTile(
                  title: Text(
                    data['titre'],
                    style: TextStyle(
                      color: estProche ? Colors.grey : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    'Prix: ${data['prix']}',
                    style: TextStyle(
                      color: estProche ? Colors.grey : Colors.black,
                    ),
                  ),
                  trailing: estProche
                      ? Text(
                          'Débute le ${dateDebut.day}/${dateDebut.month}/${dateDebut.year}')
                      : IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirmation'),
                                  content: const Text(
                                      'Voulez-vous vraiment supprimer cette offre ?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Annuler'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await _supprimerOffre(document.id);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Supprimer'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
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
              builder: (context) => const PageFormulaireOffre(),
            ),
          );
        },
        tooltip: 'Créer une offre',
        child: const Icon(Icons.add),
      ),
    );
  }
}
