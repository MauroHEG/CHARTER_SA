import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OffreDetailScreen extends StatefulWidget {
  final DocumentSnapshot offre;

  OffreDetailScreen({required this.offre});

  @override
  _OffreDetailScreenState createState() => _OffreDetailScreenState();
}

class _OffreDetailScreenState extends State<OffreDetailScreen> {
  String localPath = "";
  bool downloading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> downloadPDF() async {
    setState(() {
      downloading = true;
    });

    if (!kIsWeb) {
      String url = widget.offre.get('pdf');
      var dir = await getApplicationDocumentsDirectory();
      String fileName = "offre.pdf";
      localPath = "${dir.path}/$fileName";
      await Dio().download(url, localPath);
    }

    setState(() {
      downloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> images = List<String>.from(widget.offre.get('images'));
    String pdfUrl = widget.offre.get('pdf');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.offre.get('titre')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.gift, size: 24.0),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.offre.get('titre'),
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              CarouselSlider.builder(
                itemCount: images.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) =>
                        Container(
                  child: Image.network(
                    images[itemIndex],
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      // Vous pouvez retourner un widget d'erreur ici si l'image ne peut pas être chargée
                      return const Center(
                          child: Text('Erreur de chargement de l\'image'));
                    },
                  ),
                ),
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  widget.offre.get('description'),
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.euroSign, size: 18.0),
                    SizedBox(width: 10),
                    Text(
                      "Prix : ${widget.offre.get('prix')}€",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.calendarAlt, size: 18.0),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Début : ${DateFormat('dd/MM/yyyy').format(widget.offre.get('dateDebut').toDate())}\nFin : ${DateFormat('dd/MM/yyyy').format(widget.offre.get('dateFin').toDate())}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  icon: FaIcon(FontAwesomeIcons.fileDownload, size: 18.0),
                  label: Text('Télécharger le PDF'),
                  onPressed: downloading ? null : () => downloadPDF(),
                ),
              ),
              if (downloading)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(),
                ),
              SizedBox(height: 20),
              if (localPath.isNotEmpty && !downloading)
                Container(
                  height: 300,
                  child: PDFView(
                    filePath: localPath,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
