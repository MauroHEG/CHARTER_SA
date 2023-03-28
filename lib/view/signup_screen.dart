import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _firstName,
      _lastName,
      _email,
      _password,
      _confirmPassword,
      _phoneNumber;
  DateTime? _dateOfBirth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7BF853),
        title: Text('Inscription', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Color(0xFFD9F5D0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildFirstNameField(),
              _buildLastNameField(),
              _buildEmailField(),
              _buildPasswordField(),
              _buildConfirmPasswordField(),
              _buildPhoneNumberField(),
              _buildDateOfBirthField(),
              _buildSignUpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Prénom'),
      validator: (String? value) {
        if (value!.isEmpty) return 'Le prénom est obligatoire.';
        return null;
      },
      onSaved: (String? value) => _firstName = value!,
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Nom'),
      validator: (String? value) {
        if (value!.isEmpty) return 'Le nom est obligatoire.';
        return null;
      },
      onSaved: (String? value) => _lastName = value!,
    );
  }

  Widget _buildEmailField() {
    String? _email;
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      validator: (String? value) {
        if (value!.isEmpty) return 'L\'email est obligatoire.';
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
          return 'Entrez un email valide.';
        return null;
      },
      onSaved: (String? value) => _email = value,
    );
  }

  Widget _buildPasswordField() {
    String? _password;
    return TextFormField(
      decoration: InputDecoration(labelText: 'Mot de passe'),
      obscureText: true,
      validator: (String? value) {
        if (value!.isEmpty) return 'Le mot de passe est obligatoire.';
        if (value.length < 6)
          return 'Le mot de passe doit contenir au moins 6 caractères.';
        return null;
      },
      onSaved: (String? value) => _password = value,
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Confirmer le mot de passe'),
      obscureText: true,
      validator: (String? value) {
        if (value!.isEmpty)
          return 'La confirmation du mot de passe est obligatoire.';
        if (_password != null && value != _password)
          return 'Les mots de passe ne correspondent pas.';
        return null;
      },
      onSaved: (String? value) => _confirmPassword = value!,
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Téléphone'),
      keyboardType: TextInputType.phone,
      validator: (String? value) {
        if (value!.isEmpty) return 'Le numéro de téléphone est obligatoire.';
        return null;
      },
      onSaved: (String? value) => _phoneNumber = value!,
    );
  }

  Widget _buildDateOfBirthField() {
    return GestureDetector(
      onTap: () async {
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          setState(() => _dateOfBirth = date);
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Date de naissance',
            hintText: _dateOfBirth != null
                ? '${_dateOfBirth?.day}/${_dateOfBirth?.month}/${_dateOfBirth?.year}'
                : 'Sélectionnez une date',
          ),
          validator: (String? value) {
            if (_dateOfBirth == null) {
              return 'La date de naissance est obligatoire.';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF7BF853),
      ),
      child: Text('S\'inscrire'),
      onPressed: () {
        if (!_formKey.currentState!.validate()) return;
        _formKey.currentState?.save();

        // Traiter les données saisie dans le formulaire ici
      },
    );
  }
}
