class Offre {
  final String titre;

  Offre({required this.titre});

  factory Offre.fromMap(Map<String, dynamic> map) {
    return Offre(
      titre: map['titre'],
    );
  }
}
