class Avis {
  final String userId;
  final String destination;
  final String ville;
  final String? titre;
  final String? avis;
  final int? note;
  final List<String>? images; // Liste d'URLs des images

  Avis({
    required this.userId,
    required this.destination,
    required this.ville,
    this.titre,
    this.avis,
    this.note,
    this.images,
  });

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

  static Avis fromMap(Map<String, dynamic> map) {
    return Avis(
      userId: map['userId'] ?? '',
      destination: map['destination'] ?? '',
      ville: map['ville'] ?? '',
      titre: map['titre'],
      avis: map['avis'],
      note: map['note'] ?? 0,
      images: map['images'] != null ? List<String>.from(map['images']) : [],
    );
  }
}
