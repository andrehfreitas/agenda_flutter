import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

final String contactTable = 'contactTable';
final String idColumn = 'idColumn';
final String nameColumn = 'nameColumn';
final String emailColumn = 'emailColumn';
final String phoneColumn = 'phoneColumn';


class DatabaseProvider {
  DatabaseProvider.internal();
  static final DatabaseProvider _instance = DatabaseProvider.internal();
  factory DatabaseProvider() => _instance;

  Database _db;

  // Se o BD existir retona ele, senão ocorre sua inicialização 
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }


  // Inicializa o banco de dados, caso ele não exista cria ele com a chamada do
  // método createDB
  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'contactsnew.db');

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  
  // Método que cria o banco de dados caso ele não exista
  void _createDb (Database db, int newerVersion) async {
    await db.execute(
      'CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, ' +
      '$emailColumn TEXT, $phoneColumn TEXT)'
    );
  }


  // Método que salva um contato no banco de dados
  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await this.db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }


  // Método que retorna um contato específico do banco de dados
  Future<Contact> getContact(int id) async {
    Database dbContact = await this.db;
    List<Map> maps = await dbContact.query(
      contactTable,
      columns: [idColumn, nameColumn, emailColumn, phoneColumn],
      where: '$idColumn = ?',
      whereArgs: [id]
    );

    // Verifica se algum resultado foi obtido da busca pelo id
    if (maps.length > 0 ) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }


  // Método que deleta um contato do banco de dados
  Future<int> deleteContact(int id) async {
    Database dbContact = await this.db;
    return await dbContact.delete(
      contactTable,
      where: '$idColumn = ?', 
      whereArgs: [id]
    );
  }


  // Método que atualiza um contato do banco de dados
  Future<int> updateContact(Contact contact) async {
    Database dbContact = await this.db;
    return await dbContact.update(
      contactTable,
      contact.toMap(),
      where: '$idColumn = ?', 
      whereArgs: [contact.id]
    );
  }


  // Método que retorna todos os registros do banco de dados
  Future<List> getAllContacts() async {
    Database dbContact = await this.db;
    List listMap = await dbContact.rawQuery('SELECT * FROM $contactTable');

    // Analisar a necessidade deste trecho de código
    // seu funcionamento com e sem esse trecho
    List<Contact> listContact = List();
    for (Map m in listMap) {
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  } 
} 


class Contact {
  int id;
  String name;
  String email;
  String phone;

  Contact();

  // Construtor que converte objetos de mapa (JSON) para objetos de Contato
  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
  }

  // Método que transforma o objeto do contato em Mapa (JSON) para armazenar no banco de dados
  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
    };

    // O id pode ser nulo caso o registro esteja sendo criado já que é o banco de dados que
    // atribui o ID ao registro no ato de salvar. Por isso de vemos testar antes de atribuir
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

}