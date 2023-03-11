import 'package:charter_appli_travaux_mro/utils/appStrings.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //final --> initialisé à l'éxécution et ne sera affectée qu'une seule fois
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 25,
          ),
          Image(image: AssetImage(AppStrings.cheminLogo)),
          SizedBox(
            height: 25,
          ),
          Container(
            //permet de rendre plus petit les champs de texte à
            margin: const EdgeInsets.all(50.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: AppStrings.txtEmail,
                        ),
                        validator: (value) {
                          //si la valeur est nulle alors condition se termine en retournant directement true
                          if (value?.isEmpty ?? true) {
                            return AppStrings.txtEmailNull;
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: AppStrings.txtMp,
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return AppStrings.txtMpNull;
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  //Pour mettre les deux bouttons sur la même ligne
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: Text(AppStrings.txtBtnConnexion),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: _registration,
                          child: Text(AppStrings.txtBtnInscription))
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? true) {
      _formKey.currentState?.save();

      // TODO: Do something with the login information
    }
  }

  void _registration() {
    print("Inscription !!");
    print(_email);
  }
}
