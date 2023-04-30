import 'package:flutter/material.dart';

class OffreDetailPage extends StatefulWidget {
  final Map<String, dynamic> offreData;

  OffreDetailPage({required this.offreData});

  @override
  _OffreDetailPageState createState() => _OffreDetailPageState();
}

class _OffreDetailPageState extends State<OffreDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détail de l\'offre'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informations sur l\'offre',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Titre: ${widget.offreData['titre']}'),
                      SizedBox(height: 5),
                      Text('Prix: ${widget.offreData['prix']}'),
                      SizedBox(height: 5),
                      Text('Description: ${widget.offreData['description']}'),
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
