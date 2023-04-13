import 'package:charter_appli_travaux_mro/utils/appStrings.dart';
import 'package:flutter/material.dart';

class AppBar_view extends StatefulWidget {
  const AppBar_view({super.key, required this.title, required this.page});

  //On récupère ces attributs lors de l'appel de la classe car il sera réutilisé plusieurs fois
  final String title;
  final Widget page;

  @override
  State<AppBar_view> createState() => _AppBar_viewState();
}

class _AppBar_viewState extends State<AppBar_view> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contraints) {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          body: widget.page);
    });
  }
}
