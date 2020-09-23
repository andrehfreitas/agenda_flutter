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
  List<Contact> contacts;

  // Guarda número de registros da tabela
  int count = 0;


  void _getAllContacts(){
    final dbFuture = database.initDb();

    dbFuture.then((result) {
      final contactsFuture = database.getAllContacts();

      contactsFuture.then((result) {
        List<Contact> contactsList = List<Contact>();
        count = result.length;

        for (int i=0; i<count; i++){
          contactsList.add(Contact.fromObject(result[i]));
        }

        setState(() {
          contacts = contactsList;
        });
      });
    });
  }


  // Construção da tela
  @override
  Widget build(BuildContext context) {

    if (contacts == null){
      contacts = List<Contact>();
    }

    _getAllContacts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda Flutter'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),

      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){ _showContactPage(Contact('','','')); },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),

      body: ListView.builder(
        padding: EdgeInsets.all(10.0),  
        itemCount: count,
        itemBuilder: (BuildContext context, int index){
          return _contactCard(context, index);
        }
      )
    );
  }


  // Mostra os dados de um contato dentro de um card
  Widget _contactCard(BuildContext context, int index){
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
                      _showContactPage(this.contacts[index]);
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


  // Método que abre a página para edição de um contato
  void _showContactPage(Contact contact) async{
    await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => ContactPage(contact))
    );
  }
}