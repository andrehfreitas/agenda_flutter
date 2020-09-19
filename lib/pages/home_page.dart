import 'package:flutter/material.dart';
import 'contact_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:agenda_flutter/providers/database_provider.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  
  // Variável que recebe instância Singleton da classe DatabaseProvider
  DatabaseProvider database = DatabaseProvider();

  // Lista que receberá todos os contatos que serão exibidos na tela
  List<Contact> contacts = List();

  // Sobrescrita do método initState de State para que quando o estado for iniciado
  // junto com a tela, seja feita a busca de todos os contatos cadastrados através
  // do método _getAllContacts, preenchendo a lista
  @override
  void initState() {
    super.initState();

    _getAllContacts();
  }

  void _getAllContacts(){
    
    // Depois de pronto ver se as duas formas funcionam
    /*
    var list = database.getAllContacts();
    setState(() {
      contacts = list as List<Contact>;
    }); */


    database.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  } 
}