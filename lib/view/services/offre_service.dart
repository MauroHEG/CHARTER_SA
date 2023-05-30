import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:html' as html show File, FileReader, Blob;
import 'dart:io' show Platform, File;
import 'package:flutter/foundation.dart' show kIsWeb;

class OffreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _stockage = FirebaseStorage.instance;
  List<XFile>? _imagesSelectionnees;
  Uint8List? _octetsPdfSelectionne;
  String? _nomPdfSelectionne;
  List<String>? _urlsImagesTelechargees;
  String? _urlPdfTelecharge;
  final _offresCollection = FirebaseFirestore.instance.collection('offres');

  final CollectionReference _offres =
      FirebaseFirestore.instance.collection('offres');

  Stream<QuerySnapshot> getOffresStream() {
    return _offres.snapshots();
  }

  Future<void> supprimerOffre(String documentId) async {
    await _offres.doc(documentId).delete();
  }

  Future<void> creerOffre({
    required String titre,
    required double prix,
    required String description,
    required DateTime dateDebut,
    required DateTime dateFin,
  }) async {
    try {
      await _televerserFichiers();
      await _offres.add({
        'titre': titre,
        'prix': prix,
        'description': description,
        'images': _urlsImagesTelechargees,
        'pdf': _urlPdfTelecharge,
        'dateDebut': dateDebut.toUtc(),
        'dateFin': dateFin.toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<String>?> selectionnerImages() async {
    List<String> nomsFichiers = [];
    final ImagePicker choixImage = ImagePicker();
    List<XFile>? images = await choixImage.pickMultiImage();
    if (_imagesSelectionnees == null) {
      _imagesSelectionnees = images;
    } else {
      _imagesSelectionnees!.addAll(images);
    }
    nomsFichiers = images?.map((file) => file.name).toList() ?? [];

    return nomsFichiers.isEmpty
        ? null
        : nomsFichiers; // Return the list of file names or null if no file is selected
  }

  Future<String?> selectionnerPdf() async {
    FilePickerResult? resultat = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (resultat != null) {
      Uint8List fichier = resultat.files.single.bytes!;
      String nomFichier = resultat.files.single.name;
      _octetsPdfSelectionne = fichier;
      _nomPdfSelectionne = nomFichier;
      return nomFichier; // Retourner le nom du fichier
    }
    return null; // Retourner null si aucun fichier n'est sélectionné
  }

  Future<void> _televerserFichiers() async {
    FirebaseStorage stockage = FirebaseStorage.instance;
    if (_imagesSelectionnees != null) {
      _urlsImagesTelechargees = [];
      for (var image in _imagesSelectionnees!) {
        String nomFichier =
            'images/${DateTime.now().millisecondsSinceEpoch}_${image.name}';
        Reference ref = stockage.ref().child(nomFichier);
        Uint8List data = await image.readAsBytes();
        await ref.putData(data);
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

  Future<Uint8List> _readData(html.File file) {
    final Completer<Uint8List> completer = Completer();
    final html.FileReader reader = html.FileReader();
    reader.readAsDataUrl(file);
    reader.onLoadEnd.listen((event) {
      final String result = reader.result as String;
      final String data = result.substring(result.indexOf(',') + 1);
      completer.complete(base64.decode(data));
    });
    return completer.future;
  }

  Future<String> getDownloadUrl(String filePath) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(filePath);
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }
}
