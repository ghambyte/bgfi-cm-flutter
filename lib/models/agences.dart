import 'dart:core';

import 'package:gui/models/horaireAgence.dart';

class Agences{

  int id;
  String codeAgence;
  String nomAgence;
  String adresseAgence;
  String telephone;
  String email;
  String contactAgence;
  List<HoraireAgence> horaireAgence;

  Agences({this.id, this.codeAgence, this.nomAgence, this.adresseAgence,
      this.telephone, this.email, this.contactAgence, this.horaireAgence});

  Agences.fromMap(Map<String, dynamic> map){
    this.codeAgence = map['codeAgence'];
    this.nomAgence = map['nomAgence'];
    this.adresseAgence = map['adresseAgence'];
    this.telephone = map['telephone'];
    this.email = map['email'];
    this.contactAgence = map['contactAgence'];
    this.horaireAgence = map['horaireAgence'].map<HoraireAgence>((recap) => HoraireAgence.fromMap(recap)).toList();
  }

  fromMap(Map<String, dynamic> map){
    this.codeAgence = map['codeAgence'];
    this.nomAgence = map['nomAgence'];
    this.adresseAgence = map['adresseAgence'];
    this.telephone = map['telephone'];
    this.email = map['email'];
    this.contactAgence = map['contactAgence'];
    this.horaireAgence = map['horaireAgence'].map<HoraireAgence>((recap) => HoraireAgence.fromMap(recap)).toList();
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'codeAgence': this.codeAgence,
      'nomAgence': this.nomAgence,
      'adresseAgence': this.adresseAgence,
      'telephone': this.telephone,
      'email': this.email,
      'contactAgence': this.contactAgence,
      'horaireAgence': this.horaireAgence
    };
    if(id != null){
      map['id'] = this.id;
      map['codeAgence'] = this.codeAgence;
      map['nomAgence'] = this.nomAgence;
      map['adresseAgence'] = this.adresseAgence;
      map['telephone'] = this.telephone;
      map['email'] = this.email;
      map['contactAgence'] = this.contactAgence;
      map['horaireAgence'] = this.horaireAgence;
    }
  }
}