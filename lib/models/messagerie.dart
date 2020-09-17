import 'dart:core';

class Messagerie{

  String id;
  String objet;
  String corps;
  String dateDebut;
  String dateFin;
  String codeClient;


  Messagerie(this.id, this.objet, this.corps, this.dateDebut, this.dateFin,
      this.codeClient);

  Messagerie.fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.objet = map['objet'];
    this.corps = map['corps'];
    this.dateDebut = map['dateDebut'];
    this.dateFin = map['dateFin'];
    this.codeClient = map['codeClient'];
  }

  fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.objet = map['objet'];
    this.corps = map['corps'];
    this.dateDebut = map['dateDebut'];
    this.dateFin = map['dateFin'];
    this.codeClient = map['codeClient'];
  }
}