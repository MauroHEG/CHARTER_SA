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
  DateTime _dateFin = DateTime.now().add(const Duration(days: 7));
  List<String> _imagesSelectionnees = [];
  List<String> _pdfsSelectionnes = [];
  String? _pdfSelectionne;

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
        title: const Text('Créer une offre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: ListView(
            children: [
              _buildTextField(_controleurTitre, 'Titre'),
              const SizedBox(height: 20),
              _buildTextField(_controleurPrix, 'Prix', TextInputType.number),
              const SizedBox(height: 20),
              _buildTextField(
                  _controleurDescription, 'Description', TextInputType.text, 3),
              const SizedBox(height: 20),
              _buildDatePicker(
                  'Date de début :', _dateDebut, (date) => _dateDebut = date!),
              const SizedBox(height: 20),
              _buildDatePicker(
                  'Date de fin :', _dateFin, (date) => _dateFin = date!),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Sélectionner des images'),
                onPressed: () async {
                  List<String>? images =
                      await offreService.selectionnerImages();
                  if (images != null) {
                    setState(() {
                      _imagesSelectionnees.addAll(images);
                    });
                  }
                },
              ),
              _buildDocumentList(
                  _imagesSelectionnees, 'Images sélectionnées :'),
              const SizedBox(height: 20),
              _buildDocumentList(_pdfsSelectionnes, 'PDFs sélectionnés :'),
              ElevatedButton(
                child: const Text('Sélectionner un PDF'),
                onPressed: () async {
                  String? pdf = await offreService.selectionnerPdf();
                  if (pdf != null) {
                    setState(() {
                      _pdfSelectionne = pdf;
                    });
                  } else {
                    final snackBar = SnackBar(
                      content: Text('Aucun PDF sélectionné.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
              if (_pdfSelectionne != null) _buildSelectedPdf(),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Créer une offre'),
                onPressed: () => _creerOffre(context, offreService),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField(
      TextEditingController controller, String labelText,
      [TextInputType keyboardType = TextInputType.text, int maxLines = 1]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }

  Widget _buildDatePicker(String labelText, DateTime initialDate,
      Function(DateTime?) onDateSelected) {
    return Row(
      children: [
        Text('$labelText ${_formatDate.format(initialDate)}'),
        ElevatedButton(
          child: const Text('Sélectionner'),
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              setState(() {
                onDateSelected(date);
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildSelectedImages() {
    if (_imagesSelectionnees != null && _imagesSelectionnees!.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _imagesSelectionnees!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_imagesSelectionnees![index]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _imagesSelectionnees!.removeAt(index);
                });
              },
            ),
          );
        },
      );
    } else {
      return Text('Aucune image sélectionnée.');
    }
  }

  Widget _buildSelectedPdf() {
    if (_pdfSelectionne != null) {
      return ListTile(
        title: Text(_pdfSelectionne!),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setState(() {
              _pdfSelectionne = null;
            });
          },
        ),
      );
    } else {
      return Text('Aucun PDF sélectionné.');
    }
  }

  void _creerOffre(BuildContext context, OffreService offreService) async {
    final titre = _controleurTitre.text;
    final prix = double.tryParse(_controleurPrix.text);
    final description = _controleurDescription.text;

    if (titre.isNotEmpty && prix != null && description.isNotEmpty) {
      await offreService.creerOffre(
        titre: titre,
        prix: prix,
        description: description,
        dateDebut: _dateDebut,
        dateFin: _dateFin,
      );
      Navigator.pop(context, 'Offre créée');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez remplir tous les champs et vérifier le format du prix.',
          ),
        ),
      );
    }
  }

  Widget _buildDocumentList(List<String>? documents, String labelText) {
    if (documents == null || documents.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText),
        for (var document in documents)
          ListTile(
            title: Text(document),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  documents.remove(document);
                });
              },
            ),
          ),
      ],
    );
  }
}
