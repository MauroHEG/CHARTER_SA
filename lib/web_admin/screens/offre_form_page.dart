import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:universal_io/io.dart';
import 'dart:html' as html;

import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';

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
  List<html.File>? _imagesSelectionneesHtml;
  List<Uint8List>? _imagesSelectionneesBytes;

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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _cleFormulaire,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Informations sur l\'offre',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
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
                  Text(
                    'Dates',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                            ? 'Date de début'
                            : 'Date de début: ${_dateDebut!.day}/${_dateDebut!.month}/${_dateDebut!.year}'),
                      ),
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
                            ? 'Date de fin'
                            : 'Date de fin: ${_dateFin!.day}/${_dateFin!.month}/${_dateFin!.year}'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Fichiers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _selectionnerImages,
                        child: Text('Images'),
                      ),
                      ElevatedButton(
                        onPressed: _selectionnerPdf,
                        child: Text('PDF'),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  if (_imagesSelectionnees != null ||
                      _imagesSelectionneesHtml != null)
                    Container(
                      height: 200,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: kIsWeb
                            ? _imagesSelectionneesHtml!.length
                            : _imagesSelectionnees!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FutureBuilder<Uint8List>(
                                    future: _convertirFichierHtmlEnUint8List(
                                        _imagesSelectionneesHtml![index]),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<Uint8List> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator(); // Affiche un indicateur de chargement pendant la conversion
                                      } else if (snapshot.hasError) {
                                        return Text(
                                            "Erreur lors de la conversion du fichier en Uint8List : ${snapshot.error}");
                                      } else {
                                        return Image.memory(
                                          snapshot.data!,
                                          fit: BoxFit.cover,
                                        );
                                      }
                                    },
                                  ),
                                  Text(
                                    'Image ${index + 1}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  SizedBox(height: 10),
                  if (_nomPdfSelectionne != null)
                    Text(
                      'Fichier sélectionné: $_nomPdfSelectionne',
                      style:
                          TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_cleFormulaire.currentState!.validate() &&
                            _dateDebut != null &&
                            _dateFin != null) {
                          _creerOffre();
                        }
                      },
                      child: Text('Créer une offre'),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
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

  Future<List<Uint8List>?> convertXFilesToUint8List(List<XFile>? xfiles) async {
    if (xfiles == null) return null;
    List<Uint8List> byteDataList = [];
    for (XFile xfile in xfiles) {
      Uint8List byteData = await File(xfile.path).readAsBytes();
      byteDataList.add(byteData);
    }
    return byteDataList;
  }

  Future<void> _selectionnerImages() async {
    if (kIsWeb) {
      List<html.File>? imageFiles = await ImagePickerWeb.getMultiImagesAsFile();
      if (imageFiles != null) {
        setState(() {
          if (_imagesSelectionneesHtml == null) {
            _imagesSelectionneesHtml = imageFiles;
          } else {
            _imagesSelectionneesHtml!.addAll(imageFiles);
          }
        });
      }
    } else {
      final ImagePicker _choixImage = ImagePicker();
      List<XFile>? images = await _choixImage.pickMultiImage();
      setState(() {
        if (_imagesSelectionnees == null) {
          _imagesSelectionnees = images;
        } else {
          _imagesSelectionnees!.addAll(images!);
        }
      });
    }
  }

  Future<Uint8List> _convertirFichierHtmlEnUint8List(html.File fichier) async {
    final completer = Completer<Uint8List>();
    final reader = html.FileReader();

    reader.onLoadEnd.listen((event) {
      completer.complete(reader.result as Uint8List);
    });
    reader.onError.listen((event) {
      completer.completeError(event);
    });
    reader.readAsArrayBuffer(fichier);

    return completer.future;
  }

  Future<List<html.File>?> _pickMultiWebFiles() async {
    final completer = Completer<List<html.File>>();
    html.InputElement uploadInput = html.InputElement(type: 'file');
    uploadInput.multiple = true;
    uploadInput.accept =
        'image/jpeg, image/png, image/gif, image/webp, image/svg+xml, image/bmp, image/tiff, image/x-icon';

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.length > 0) {
        completer.complete(files);
      } else {
        completer.complete(null);
      }
    });

    uploadInput.click();
    return completer.future;
  }

  Future<void> _selectionnerPdf() async {
    FilePickerResult? resultat = await FilePickerWeb.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (resultat != null) {
      Uint8List fichier = resultat.files.single.bytes!;
      String nomFichier = resultat.files.single.name;
      setState(() {
        _octetsPdfSelectionne = fichier;
        _nomPdfSelectionne = nomFichier;
      });
    }
  }

  Future<void> _televerserFichiers() async {
    FirebaseStorage stockage = FirebaseStorage.instance;
    if (_imagesSelectionnees != null || _imagesSelectionneesHtml != null) {
      _urlsImagesTelechargees = [];
      if (kIsWeb) {
        for (html.File image in _imagesSelectionneesHtml!) {
          String nomFichier =
              'images/${DateTime.now().millisecondsSinceEpoch}_${image.name}';
          Reference ref = stockage.ref().child(nomFichier);
          String mimeType = mime(image.name)!;
          await ref.putBlob(image, SettableMetadata(contentType: mimeType));
          String urlTelechargement = await ref.getDownloadURL();
          _urlsImagesTelechargees!.add(urlTelechargement);
        }
      } else {
        for (XFile image in _imagesSelectionnees!) {
          String nomFichier =
              'images/${DateTime.now().millisecondsSinceEpoch}_${image.name}';
          Reference ref = stockage.ref().child(nomFichier);
          await ref.putFile(File(image.path));
          String urlTelechargement = await ref.getDownloadURL();
          _urlsImagesTelechargees!.add(urlTelechargement);
        }
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
