import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:html' as html;
//import 'dart:typed_data';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
//import 'package:mime/mime.dart';
import 'package:mime_type/mime_type.dart';

class OffreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _stockage = FirebaseStorage.instance;
  List<XFile>? _imagesSelectionnees;
  List<html.File>? _imagesSelectionneesHtml;
  Uint8List? _octetsPdfSelectionne;
  String? _nomPdfSelectionne;
  List<String>? _urlsImagesTelechargees;
  String? _urlPdfTelecharge;

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

  Future<List<Uint8List>?> convertXFilesToUint8List(List<XFile>? xfiles) async {
    if (xfiles == null) return null;
    List<Uint8List> byteDataList = [];
    for (XFile xfile in xfiles) {
      Uint8List byteData = await File(xfile.path).readAsBytes();
      byteDataList.add(byteData);
    }
    return byteDataList;
  }

  Future<List<String>?> selectionnerImages() async {
    List<String> nomsFichiers = [];

    if (kIsWeb) {
      List<html.File>? imageFiles = await ImagePickerWeb.getMultiImagesAsFile();
      if (imageFiles != null) {
        if (_imagesSelectionneesHtml == null) {
          _imagesSelectionneesHtml = imageFiles;
        } else {
          _imagesSelectionneesHtml!.addAll(imageFiles);
        }
        nomsFichiers = imageFiles.map((file) => file.name).toList();
      }
    } else {
      final ImagePicker choixImage = ImagePicker();
      List<XFile>? images = await choixImage.pickMultiImage();
      if (_imagesSelectionnees == null) {
        _imagesSelectionnees = images;
      } else {
        _imagesSelectionnees!.addAll(images);
      }
      nomsFichiers = images?.map((file) => file.name).toList() ?? [];
    }

    return nomsFichiers.isEmpty
        ? null
        : nomsFichiers; // Retourner la liste des noms de fichiers ou null si aucun fichier n'est sélectionné
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
      if (files != null && files.isNotEmpty) {
        completer.complete(files);
      } else {
        completer.complete(null);
      }
    });

    uploadInput.click();
    return completer.future;
  }

  Future<String?> selectionnerPdf() async {
    FilePickerResult? resultat = await FilePickerWeb.platform.pickFiles(
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
