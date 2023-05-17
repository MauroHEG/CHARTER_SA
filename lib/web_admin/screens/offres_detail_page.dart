import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../view/services/offre_service.dart';

class OffreDetailPage extends StatefulWidget {
  final Map<String, dynamic> offreData;

  const OffreDetailPage({super.key, required this.offreData});

  @override
  _OffreDetailPageState createState() => _OffreDetailPageState();
}

class _OffreDetailPageState extends State<OffreDetailPage> {
  final OffreService offreService = OffreService();

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat("dd/MM/yyyy"); // Format de la date

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de l\'offre'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informations sur l\'offre',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('Titre: ${widget.offreData['titre']}'),
                      const SizedBox(height: 5),
                      Text('Prix: ${widget.offreData['prix']}'),
                      const SizedBox(height: 5),
                      Text('Description: ${widget.offreData['description']}'),
                      const SizedBox(height: 5),
                      Text(
                          'Date de début: ${format.format(widget.offreData['dateDebut'].toDate())}'),
                      const SizedBox(height: 5),
                      Text(
                          'Date de fin: ${format.format(widget.offreData['dateFin'].toDate())}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Documents',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        child: const Text('Télécharger le PDF'),
                        onPressed: () async {
                          String? pdfLink = widget.offreData['pdf'];
                          if (pdfLink != null) {
                            String downloadUrl =
                                await offreService.getDownloadUrl(pdfLink);
                            if (await canLaunch(downloadUrl)) {
                              await launch(downloadUrl);
                            } else {
                              throw 'Impossible de lancer $downloadUrl';
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Aucun lien PDF disponible pour ce document.'),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 5),
                      ...(widget.offreData['images'] != null
                          ? [
                              for (int i = 0;
                                  i < widget.offreData['images'].length;
                                  i++)
                                ElevatedButton(
                                  child: Text('Image ${i + 1}'),
                                  onPressed: () async {
                                    String imageUrl =
                                        widget.offreData['images'][i];
                                    if (await canLaunch(imageUrl)) {
                                      await launch(imageUrl);
                                    } else {
                                      throw 'Impossible de lancer $imageUrl';
                                    }
                                  },
                                )
                            ]
                          : []),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
