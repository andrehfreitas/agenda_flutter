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


  // Construção da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda Flutter'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),

      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){ _showContactPage(); },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),

      body: ListView.builder(
        padding: EdgeInsets.all(10.0),  
        itemCount: contacts.length,
        itemBuilder: (context, index){
          return _contactCard(context, index);
        }
      ),
    );
  }


  // Mostra os dados de um contato dentro de um card
  Widget _contactCard(BuildContext context, index){
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children:<Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/image/person.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].name ?? '', 
                      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),

                    Text(
                      contacts[index].email ?? '', 
                      style: TextStyle(fontSize: 18.0),
                    ),

                    Text(
                      contacts[index].phone ?? '', 
                      style: TextStyle(fontSize: 18.0),
                    ),

                  ],
                ),              
              ),
            ],
          ),
        ),
      ),

      onTap: (){
        _showOptions(context, index);
      },
    );
  }


  // Exibe menu de opções ao tocar em um contato
  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(
      context: context, 
      builder: (context){
        return BottomSheet(
          onClosing: (){}, 
          builder: (context){
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _optionButton(context, 'Ligar', (){
                      launch('tel:${contacts[index].phone}');
                      Navigator.pop(context);
                    },
                  ),

                  _optionButton(context, 'Editar', (){
                      Navigator.pop(context);
                      _showContactPage(contact: contacts[index]);
                    },
                  ),

                  _optionButton(context, 'Excluir', (){
                      database.deleteContact(contacts[index].id);
                      setState(() {
                        contacts.removeAt(index);
                      });
                      Navigator.pop(context);
                    },
                  ),

                ],
              ),
            );
          },
        );
      }
    );
  }

  
  // Método que constrói o botão de opções
  Widget _optionButton(BuildContext context, title, pressedFunction){
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: FlatButton(
        onPressed: pressedFunction, 
        child: Text(
          title,
          style: TextStyle(color: Colors.blue, fontSize: 20.0),
        ),
      ),    
    );
  }


  // Método que abre a página para cadastro ou edição de um contato
  void _showContactPage({Contact contact}) async{
    final recContact = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact))
    );

    if(recContact != null){
      if(contact != null){
        await database.updateContact(recContact);
      }else{
        await database.saveContact(recContact);
      }
    }

    _getAllContacts();
  }
}