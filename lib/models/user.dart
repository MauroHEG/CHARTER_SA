class User {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String motDePasse;
  final DateTime dateDeNaissance;
  final String telephone;
  final String adresse;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.motDePasse,
    required this.dateDeNaissance,
    required this.telephone,
    required this.adresse,
  });
}
