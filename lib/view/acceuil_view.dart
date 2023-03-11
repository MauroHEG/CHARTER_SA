import 'package:charter_appli_travaux_mro/utils/appStrings.dart';
import 'package:charter_appli_travaux_mro/view/shared/bigCard_view.dart';
import 'package:flutter/material.dart';

class Acceuil_view extends StatefulWidget {
  @override
  _Acceuil_viewState createState() => _Acceuil_viewState();
}

class _Acceuil_viewState extends State<Acceuil_view> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          BigCard_View(
            title: 'Carte 1',
            subtitle: 'Sous-titre 1',
            color: Colors.red,
            icon: Icons.picture_as_pdf,
          ),
          BigCard_View(
            title: 'Carte 2',
            subtitle: 'Sous-titre 2',
            color: Colors.blue,
            icon: Icons.flight,
          ),
          BigCard_View(
            title: 'Carte 3',
            subtitle: 'Sous-titre 3',
            color: Colors.green,
            icon: Icons.add_comment,
          ),
          BigCard_View(
            title: 'Carte 4',
            subtitle: 'Sous-titre 4',
            color: Colors.orange,
            icon: Icons.business_outlined,
          ),
        ],
      ),
    );
  }
}
