import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agenda_flutter/providers/database_provider.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage(this.contact);

  @override
  _ContactPageState createState() => _ContactPageState(contact);
}


class _ContactPageState extends State<ContactPage>{
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();
  Contact _editedContact;
  bool _userEdited = false;

  DatabaseProvider database = DatabaseProvider();

  _ContactPageState(this._editedContact);

  @override
  Widget build(BuildContext context) {

    _nameController.text = _editedContact.name;
    _emailController.text = _editedContact.email;
    _phoneController.text = _editedContact.phone;

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(_editedContact.name ?? 'Novo Contato'),
          centerTitle: true,
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if (_editedContact.name != null && _editedContact.name.isNotEmpty){
              _save();
            }else{
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.blue,
        ),

        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget> [
              Container(
                width: 140.0, height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/person.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: 'Nome'),
                onChanged: (value){
                  _userEdited = true;
                    _editedContact.name = _nameController.text;
                },
              ),

              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
                onChanged: (valeu) {
                  _userEdited = true;
                  _editedContact.email = _emailController.text;
                },
                keyboardType: TextInputType.emailAddress,
              ),

              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                onChanged: (value) {
                  _userEdited = true;
                  _editedContact.phone = _phoneController.text;
                },
                keyboardType: TextInputType.phone,
              ),
            
            ],
          ),
        ),
      ),
    );
  }

  void _save(){
    if(_editedContact.id != null){
      database.updateContact(_editedContact);
      debugPrint("Tapped on " + this._editedContact.name.toString());
    } else {
      database.saveContact(_editedContact);
    }
    Navigator.pop(context);
  }

  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Descartar alterações?'),
            content: Text('Se sair as alterações serão perdidas!'),
            actions: <Widget>[
              FlatButton(onPressed:() => Navigator.pop(context), child: Text('Cancelar')),
              FlatButton(
                onPressed:() {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }, 
                child: Text('Sim'),
              ),
            ],
          );
        }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

}
