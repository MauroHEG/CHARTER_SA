import 'package:charter_appli_travaux_mro/utils/appStrings.dart';
import 'package:flutter/material.dart';
import 'package:charter_appli_travaux_mro/view/loginPage_view.dart';

class AppBar_profil_view extends StatefulWidget {
  const AppBar_profil_view(
      {super.key, required this.title, required this.page});

  //On récupère ces attributs lors de l'appel de la classe car il sera réutilisé plusieurs fois
  final String title;
  final Widget page;

  @override
  State<AppBar_profil_view> createState() => _AppBar_profil_viewState();
}

class _AppBar_profil_viewState extends State<AppBar_profil_view> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contraints) {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            actions: [
              IconButton(
                icon: CircleAvatar(
                  backgroundImage: AssetImage(AppStrings.cheminPhotoProfil),
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: widget.page);
    });
  }
}
