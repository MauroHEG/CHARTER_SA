import 'package:flutter/material.dart';

class ContenuDossierScreen extends StatelessWidget {
  final String dossierId;
  final String dossierNom;

  ContenuDossierScreen({required this.dossierId, required this.dossierNom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7BF853),
        title: Text(dossierNom, style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Color(0xFFD9F5D0),
        child: Center(
          child: Text("Contenu du dossier: $dossierNom"),
        ),
      ),
    );
  }
}
