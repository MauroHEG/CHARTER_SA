class Avis {
  final String destination;
  final String ville;
  final String? titre;
  final String? avis;
  final int? note;
  final List<String>? images; // Liste d'URLs des images

  Avis(
      {required this.destination,
      required this.ville,
      this.titre,
      this.avis,
      this.note,
      this.images});

  Map<String, dynamic> toMap() {
    return {
      'destination': destination,
      'ville': ville,
      'titre': titre,
      'avis': avis,
      'note': note,
      'images': images,
    };
  }
}
