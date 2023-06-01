import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart' show ImageSource;
import 'package:image_picker/image_picker.dart' show ImagePicker, XFile;
import 'package:file_picker/file_picker.dart'
    show FilePicker, FilePickerResult, FileType;

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

  Stream<QuerySnapshot> getOffresStreamClient() {
    return FirebaseFirestore.instance
        .collection('offres')
        .where('dateDebut', isLessThan: Timestamp.now())
        .snapshots();
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

  Future<String> getDownloadUrl(String filePath) async {
    if (kIsWeb) {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child(filePath);
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } else {
      // Retourner une valeur par défaut ou traiter différemment pour les plates-formes mobiles
      return 'Download URL not available on mobile';
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
}
