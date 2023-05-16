import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../view/services/offre_service.dart';

class CreerOffrePage extends StatefulWidget {
  const CreerOffrePage({Key? key}) : super(key: key);

  @override
  _CreerOffrePageState createState() => _CreerOffrePageState();
}

class _CreerOffrePageState extends State<CreerOffrePage> {
  final _controleurTitre = TextEditingController();
  final _controleurPrix = TextEditingController();
  final _controleurDescription = TextEditingController();
  DateTime _dateDebut = DateTime.now();
  DateTime _dateFin = DateTime.now().add(Duration(days: 7));

  final _formatDate = DateFormat('dd/MM/yyyy');

  @override
  void dispose() {
    _controleurTitre.dispose();
    _controleurPrix.dispose();
    _controleurDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offreService = Provider.of<OffreService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Créer une offre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: _controleurTitre,
                decoration: InputDecoration(labelText: 'Titre'),
              ),
              TextFormField(
                controller: _controleurPrix,
                decoration: InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _controleurDescription,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              Row(
                children: [
                  Text('Date de début : ${_formatDate.format(_dateDebut)}'),
                  ElevatedButton(
                    child: Text('Sélectionner'),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _dateDebut,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          _dateDebut = date;
                        });
                      }
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Date de fin : ${_formatDate.format(_dateFin)}'),
                  ElevatedButton(
                    child: Text('Sélectionner'),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _dateFin,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          _dateFin = date;
                        });
                      }
                    },
                  ),
                ],
              ),
              ElevatedButton(
                child: Text('Sélectionner des images'),
                onPressed: offreService.selectionnerImages,
              ),
              ElevatedButton(
                child: Text('Sélectionner un PDF'),
                onPressed: offreService.selectionnerPdf,
              ),
              ElevatedButton(
                child: Text('Créer une offre'),
                onPressed: () {
                  final titre = _controleurTitre.text;
                  final prix = double.tryParse(_controleurPrix.text);
                  final description = _controleurDescription.text;

                  if (titre.isNotEmpty &&
                      prix != null &&
                      description.isNotEmpty) {
                    offreService.creerOffre(
                      titre: titre,
                      prix: prix,
                      description: description,
                      dateDebut: _dateDebut,
                      dateFin: _dateFin,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Veuillez remplir tous les champs et vérifier le format du prix.',
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
