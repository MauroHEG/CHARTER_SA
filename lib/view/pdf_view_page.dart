import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewPage extends StatefulWidget {
  final String path;

  PdfViewPage({required this.path});

  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  bool pdfReady = false;
  PDFViewController? _pdfViewController;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  void _loadPdf() async {
    setState(() {
      pdfReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Document"),
      ),
      body: pdfReady
          ? PDFView(
              filePath: widget.path,
              onViewCreated: (PDFViewController pdfViewController) {
                _pdfViewController = pdfViewController;
              },
              onPageChanged: (int? page, int? total) {
                print('page change: $page/$total');
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
