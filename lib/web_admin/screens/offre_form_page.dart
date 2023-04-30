import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class PageFormulaireOffre extends StatefulWidget {
  @override
  _PageFormulaireOffreState createState() => _PageFormulaireOffreState();
}

class _PageFormulaireOffreState extends State<PageFormulaireOffre> {
  final GlobalKey<FormState> _cleFormulaire = GlobalKey<FormState>();
  final TextEditingController _controleurTitre = TextEditingController();
  final TextEditingController _controleurPrix = TextEditingController();
  final TextEditingController _controleurDescription = TextEditingController();
  DateTime? _dateDebut;
  DateTime? _dateFin;
  List<XFile>? _imagesSelectionnees;
  File? _pdfSelectionne;
  List<String>? _urlsImagesTelechargees;
  String? _urlPdfTelecharge;
  Uint8List? _octetsPdfSelectionne;
  String? _nomPdfSelectionne;

  @override
  void dispose() {
    _controleurTitre.dispose();
    _controleurPrix.dispose();
    _controleurDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer une offre'),
      ),
      body: Form(
        key: _cleFormulaire,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _controleurTitre,
                decoration: InputDecoration(labelText: 'Titre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _controleurPrix,
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
                controller: _controleurDescription,
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
                  DateTime? dateSelectionnee = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (dateSelectionnee != null) {
                    setState(() {
                      _dateDebut = dateSelectionnee;
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
                  DateTime? dateSelectionnee = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (dateSelectionnee != null) {
                    setState(() {
                      _dateFin = dateSelectionnee;
                    });
                  }
                },
                child: Text(_dateFin == null
                    ? 'Sélectionner la date de fin'
                    : 'Date de fin: ${_dateFin!.day}/${_dateFin!.month}/${_dateFin!.year}'),
              ),
              ElevatedButton(
                onPressed: _selectionnerImages,
                child: Text('Sélectionner des images'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _selectionnerPdf,
                child: Text('Sélectionner un PDF'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_cleFormulaire.currentState!.validate() &&
                      _dateDebut != null &&
                      _dateFin != null) {
                    _creerOffre();
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

  Future<void> _creerOffre() async {
    try {
      await _televerserFichiers();
      await FirebaseFirestore.instance.collection('offres').add({
        'titre': _controleurTitre.text,
        'prix': double.parse(_controleurPrix.text),
        'description': _controleurDescription.text,
        'images': _urlsImagesTelechargees,
        'pdf': _urlPdfTelecharge,
      });
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _selectionnerImages() async {
    final ImagePicker _choixImage = ImagePicker();
    List<XFile>? images = await _choixImage.pickMultiImage();
    setState(() {
      _imagesSelectionnees = images;
    });
  }

  Future<void> _selectionnerPdf() async {
    FilePickerResult? resultat = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (resultat != null) {
      setState(() {
        _octetsPdfSelectionne = resultat.files.single.bytes;
        _nomPdfSelectionne = resultat.files.single.name;
      });
    }
  }

  Future<void> _televerserFichiers() async {
    FirebaseStorage stockage = FirebaseStorage.instance;
    if (_imagesSelectionnees != null) {
      _urlsImagesTelechargees = [];
      for (XFile image in _imagesSelectionnees!) {
        String nomFichier =
            'images/${DateTime.now().millisecondsSinceEpoch}_${image.name}';
        Reference ref = stockage.ref().child(nomFichier);
        await ref.putFile(File(image.path));
        String urlTelechargement = await ref.getDownloadURL();
        _urlsImagesTelechargees!.add(urlTelechargement);
      }
    }

    if (_octetsPdfSelectionne != null && _nomPdfSelectionne != null) {
      String nomFichier =
          'pdfs/${DateTime.now().millisecondsSinceEpoch}_$_nomPdfSelectionne';
      Reference ref = stockage.ref().child(nomFichier);
      await ref.putData(_octetsPdfSelectionne!);
      _urlPdfTelecharge = await ref.getDownloadURL();
    }
  }
}
