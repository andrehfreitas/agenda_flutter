import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agenda_flutter/providers/database_provider.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();

}


class _ContactPageState extends State<ContactPage>{
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();
  bool _userEdited = false;
  Contact _editedContact;


  // Sobrescrição do método initState para verificação se a tela foi chamada
  // em modo de edição ou de cadastro
  @override
  void initState(){
    
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}
