import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class VilleDetailsScreen extends StatefulWidget {
  final String ville;
  final String pays;

  const VilleDetailsScreen(
      {super.key, required this.ville, required this.pays});

  @override
  _VilleDetailsScreenState createState() => _VilleDetailsScreenState();
}

class _VilleDetailsScreenState extends State<VilleDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BF853),
        title: Text(widget.ville, style: const TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider(
              options: CarouselOptions(height: 200.0, autoPlay: true),
              items: [
                // Remplacez ces images par celles de la ville concernée
                const AssetImage('assets/images/ville1.jpg'),
                const AssetImage('assets/images/ville2.jpg'),
                const AssetImage('assets/images/ville3.jpg'),
              ].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Image(
                        image: i,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.ville,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Marseille est une ville vibrante située sur la côte méditerranéenne française. Un voyage à Marseille offre une expérience unique avec ses marchés animés, ses plages ensoleillées, son riche patrimoine culturel et ses délicieuses spécialités culinaires telles que la bouillabaisse et les célèbres navettes. Les visiteurs peuvent explorer le Vieux-Port, visiter le célèbre MUCEM, découvrir le quartier du Panier ou encore se détendre sur les plages de Prado. Marseille est une destination idéale pour ceux qui cherchent à s imprégner de la culture française tout en profitant d une ambiance dynamique et chaleureuse.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Code pour télécharger la brochure du voyage
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Télécharger la brochure'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7BF853)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
