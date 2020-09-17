import 'dart:io';

import 'package:gui/models/agences.dart';
import 'package:gui/models/compte.dart';
import 'package:gui/models/plafonds.dart';
import 'package:gui/models/typeChequier.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseClient {

  Database _database;

  Future<Database> get database async {
    if (_database != null){
      return _database;
    }else{
      _database = await create();
      return _database;
    }
  }

  Future create() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String database_directory = join(directory.path, 'database.db');
    var bdd = await openDatabase(database_directory, version: 1, onCreate: _onCreate);
    return bdd;
  }

  Future delete()async{
    Directory directory = await getApplicationDocumentsDirectory();
    String database_directory = join(directory.path, 'database.db');
    await deleteDatabase(database_directory);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS comptes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numeroCompte TEXT,
        titulaire TEXT,
        libelleCompte TEXT,
        deviseDuCompte TEXT,
        solde TEXT,
        codeClient TEXT,
        agence TEXT,
        libelleAgence TEXT,
        nomCompletGestionnaire TEXT,
        typeCompte TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS plafonds (
        id TEXT PRIMARY KEY,
        valeur TEXT,
        service TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS agences (
        codeAgence TEXT PRIMARY KEY,
        nomAgence TEXT,
        telephone TEXT,
        email TEXT,
        contactAgence TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS horaireAgence (
        id TEXT PRIMARY KEY,
        jourSemaine TEXT,
        heureOuverture TEXT,
        heureFermeture TEXT,
        codeAgence TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS type_chequier (
        idType TEXT PRIMARY KEY,
        codeType TEXT,
        libelleType TEXT
      )
    ''');
  }

  Future<Compte> createCompte() async {
    Database myDatabase = await database;
    myDatabase.execute('''
      CREATE TABLE IF NOT EXISTS comptes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numeroCompte TEXT,
        titulaire TEXT,
        libelleCompte TEXT,
        deviseDuCompte TEXT,
        solde TEXT,
        codeClient TEXT,
        agence TEXT,
        libelleAgence TEXT,
        nomCompletGestionnaire TEXT,
        typeCompte TEXT
      )
    ''');
  }

  Future<Compte> deleteCompte() async {
    Database myDatabase = await database;
    myDatabase.delete("comptes");
  }

  Future<Compte> ajouterCompte(Compte compte) async {
    Database myDatabase = await database;
    myDatabase.rawInsert('INSERT INTO comptes(numeroCompte, titulaire, libelleCompte, deviseDuCompte, solde, '
        'codeClient, agence, libelleAgence, nomCompletGestionnaire, typeCompte) '
        'VALUES("${compte.numeroCompte}", "${compte.titulaire}", "${compte.libelleCompte}", '
        '"${compte.deviseDuCompte}", "${compte.solde}", "${compte.codeClient}", "${compte.agence}", '
        '"${compte.libelleAgence}", "${compte.nomCompletGestionnaire}", "${compte.typeCompte}")');
    return compte;
  }

  Future<Compte> createPlafonds() async {
    Database myDatabase = await database;
    myDatabase.execute('''
      CREATE TABLE IF NOT EXISTS plafonds (
        id TEXT PRIMARY KEY,
        valeur TEXT,
        service TEXT
      )
    ''');
  }

  Future<Compte> deletePlafonds() async {
    Database myDatabase = await database;
    myDatabase.delete("plafonds");
  }

  Future<Plafonds> ajouterPlafond(Plafonds plafonds) async {
    Database myDatabase = await database;
    myDatabase.rawInsert('INSERT INTO plafonds(id, service, valeur) '
        'VALUES("${plafonds.id}", "${plafonds.service}", "${plafonds.valeur}")');
//    print(await myDatabase.query('plafonds'));
    return plafonds;
  }

  Future<Compte> deleteAgences() async {
    Database myDatabase = await database;
    myDatabase.delete("agences");
  }

  Future<Compte> createAgences() async {
    Database myDatabase = await database;
    myDatabase.execute('''
      CREATE TABLE IF NOT EXISTS agences (
        codeAgence TEXT PRIMARY KEY,
        nomAgence TEXT,
        telephone TEXT,
        email TEXT,
        contactAgence TEXT
      )
    ''');
  }

  Future<Compte> deleteHorairesAgences() async {
    Database myDatabase = await database;
    myDatabase.delete("horaireAgence");
  }

  Future<Compte> createHorairesAgences() async {
    Database myDatabase = await database;
    myDatabase.execute('''
      CREATE TABLE IF NOT EXISTS horaireAgence (
        id TEXT PRIMARY KEY,
        jourSemaine TEXT,
        heureOuverture TEXT,
        heureFermeture TEXT,
        codeAgence TEXT
      )
    ''');
  }

  Future<Agences> ajouterAgence(Agences agences) async {
    Database myDatabase = await database;
    myDatabase.rawInsert('INSERT INTO agences(codeAgence, nomAgence, telephone, email, contactAgence) '
        'VALUES("${agences.codeAgence}", "${agences.nomAgence}", "${agences.telephone}", "${agences.email}", "${agences.contactAgence}")');
//    for (var i=0; i<agences.horaireAgence.length; i++) {
//      myDatabase.rawInsert('INSERT INTO horaireAgence(id, jourSemaine, heureOuverture, heureFermeture, codeAgence) '
//        'VALUES("${agences.codeAgence}", "${agences.horaireAgence[i].jourSemaine}", "${agences.horaireAgence[i].heureOuverture}", "${agences.horaireAgence[i].heureFermeture}", "${agences.horaireAgence[i].codeAgence}")');
////      print(await myDatabase.query('horaireAgence'));
//    }
    return agences;
  }

  Future<Compte> deleteChequier() async {
    Database myDatabase = await database;
    myDatabase.delete("type_chequier");
  }

  Future<Compte> createChequier() async {
    Database myDatabase = await database;
    myDatabase.execute('''
      CREATE TABLE IF NOT EXISTS type_chequier (
        idType TEXT PRIMARY KEY,
        codeType TEXT,
        libelleType TEXT
      )
    ''');
  }

  Future<TypeChequier> ajouterChequier(TypeChequier typeChequier) async {
    Database myDatabase = await database;
    myDatabase.rawInsert('INSERT INTO type_chequier(idType, codeType, libelleType) '
        'VALUES("${typeChequier.idType}", "${typeChequier.codeType}", "${typeChequier.libelleType}")');
//    print(await myDatabase.query('type_chequier'));
    return typeChequier;
  }

  Future<List<Compte>> allComptes() async {
    Database myDatabase = await database;
    List<Map<String, dynamic>> resultat = await myDatabase.rawQuery('SELECT * FROM comptes');
    List<Compte> comptesList = [];
    resultat.forEach((map){
      Compte compte = new Compte();
      compte.fromMap(map);
      comptesList.add(compte);
    });
    return comptesList;
  }

  Future<List<TypeChequier>> allChequiers() async {
    Database myDatabase = await database;
    List<Map<String, dynamic>> resultat = await myDatabase.rawQuery('SELECT * FROM type_chequier');
    List<TypeChequier> typeChequierList = [];
    resultat.forEach((map){
      TypeChequier typeChequier = new TypeChequier();
      typeChequier.fromMap(map);
      typeChequierList.add(typeChequier);
    });
    return typeChequierList;
  }

}
