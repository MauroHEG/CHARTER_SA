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
  List<String>? _urlsImagesTelechargees;
  String? _urlPdfTelecharge;
  Uint8List? _octetsPdfSelectionne;
  String? _nomPdfSelectionne;
  List<html.File>? _imagesSelectionneesHtml;
  String? _pays;
  String? _ville;

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
        title: const Text('Créer une offre'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _cleFormulaire,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Informations sur l\'offre',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Titre',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextFormField(
                    controller: _controleurTitre,
                    decoration: const InputDecoration(
                      labelText: 'Entrez le titre',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un titre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Pays',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Entrez le nom du pays',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _pays = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ville',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Entrez le nom de la ville',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _ville = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Prix',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextFormField(
                    controller: _controleurPrix,
                    decoration: const InputDecoration(
                      labelText: 'Entrez le prix',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un prix';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextFormField(
                    controller: _controleurDescription,
                    decoration: const InputDecoration(
                      labelText: 'Entrez la description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Dates',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          DateTime? dateSelectionnee = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
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
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
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
                  const SizedBox(height: 20),
                  const Text(
                    'Fichiers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _selectionnerImages,
                        child: const Text('Images'),
                      ),
                      ElevatedButton(
                        onPressed: _selectionnerPdf,
                        child: const Text('PDF'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (_imagesSelectionnees != null ||
                      _imagesSelectionneesHtml != null ||
                      _nomPdfSelectionne != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Fichiers sélectionnés',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        if (_imagesSelectionnees != null)
                          for (int index = 0;
                              index < _imagesSelectionnees!.length;
                              index++)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    _imagesSelectionnees![index].name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        _imagesSelectionnees!.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                        if (_imagesSelectionneesHtml != null)
                          for (int index = 0;
                              index < _imagesSelectionneesHtml!.length;
                              index++)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    _imagesSelectionneesHtml![index].name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        _imagesSelectionneesHtml!
                                            .removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                        if (_nomPdfSelectionne != null)
                          Row(
                            children: [
                              Text(
                                'PDF sélectionné: $_nomPdfSelectionne',
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _octetsPdfSelectionne = null;
                                    _nomPdfSelectionne = null;
                                  });
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_cleFormulaire.currentState!.validate() &&
                            _dateDebut != null &&
                            _dateFin != null) {
                          _creerOffre();
                        }
                      },
                      child: const Text('Créer une offre'),
                    ),
                  ),
                  const SizedBox(height: 20),
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
        'dateDebut': _dateDebut!.toUtc(),
        'dateFin': _dateFin!.toUtc(),
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
