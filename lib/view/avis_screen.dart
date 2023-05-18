

/*class AvisScreen extends StatefulWidget {
  const AvisScreen({super.key});

  @override
  _AvisScreenState createState() => _AvisScreenState();
}

class _AvisScreenState extends State<AvisScreen> {
  List<Avis> avisList = [
    Avis(
        titre: "Super expérience!",
        utilisateur: "Alice",
        description:
            "J'ai passé un excellent séjour dans cet hôtel. Le personnel était très sympathique et serviable. Je recommande fortement!",
        note: 4.5),
    Avis(
        titre: "Très déçu",
        utilisateur: "Bob",
        description:
            "La chambre n'était pas propre et le petit déjeuner était très limité. Je ne reviendrai pas dans cet établissement.",
        note: 2.0),
  ]; // Remplacer ceci par une fonction pour récupérer les avis depuis la base de données

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BF853),
        title: const Text("Avis", style: TextStyle(color: Colors.black)),
      ),
      body: ListView.builder(
        itemCount: avisList.length,
        itemBuilder: (BuildContext context, int index) {
          Avis avis = avisList[index];
          return _buildAvis(context, avis);
        },
      ),
    );
  }

  Widget _buildAvis(BuildContext context, Avis avis) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              avis.titre, // Titre de l'avis
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Écrit par ${avis.utilisateur}', // Nom de l'utilisateur qui a écrit l'avis
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            Text(
              avis.description, // Description de l'avis
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 24),
                const SizedBox(width: 4),
                Text(
                  avis.note.toString(), // Note de l'avis (ex: 4.5)
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}*/
