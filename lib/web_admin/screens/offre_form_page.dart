import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OffreFormPage extends StatefulWidget {
  @override
  _OffreFormPageState createState() => _OffreFormPageState();
}

class _OffreFormPageState extends State<OffreFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _dateDebut;
  DateTime? _dateFin;

  @override
  void dispose() {
    _titreController.dispose();
    _prixController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer une offre'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _titreController,
                decoration: InputDecoration(labelText: 'Titre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prixController,
                decoration: InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _dateDebut = selectedDate;
                    });
                  }
                },
                child: Text(_dateDebut == null
                    ? 'Sélectionner la date de début'
                    : 'Date de début: ${_dateDebut!.day}/${_dateDebut!.month}/${_dateDebut!.year}'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _dateFin = selectedDate;
                    });
                  }
                },
                child: Text(_dateFin == null
                    ? 'Sélectionner la date de fin'
                    : 'Date de fin: ${_dateFin!.day}/${_dateFin!.month}/${_dateFin!.year}'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _dateDebut != null &&
                      _dateFin != null) {
                    _createOffre();
                  }
                },
                child: Text('Créer une offre'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createOffre() async {
    try {
      await FirebaseFirestore.instance.collection('offres').add({
        'titre': _titreController.text,
        'prix': double.parse(_prixController.text),
        'description': _descriptionController.text,
        'dateDebut': _dateDebut,
        'dateFin': _dateFin,
      });
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }
}
