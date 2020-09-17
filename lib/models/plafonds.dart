import 'dart:core';

class Plafonds{

  String id;
  String service;
  String valeur;

  Plafonds(){}

  Plafonds.fromMap(Map<String, dynamic> map){
    this.service = map['service'];
    this.valeur = map['valeur'];
    this.id = map['id'];
  }

  fromMap(Map<String, dynamic> map){
    this.service = map['service'];
    this.valeur = map['valeur'];
    this.id = map['id'];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'service': this.service,
      'valeur': this.valeur,
      'id': this.id,
    };
    if(id != null){
      map['id'] = this.id;
      map['service'] = this.service;
      map['valeur'] = this.valeur;
    }
  }
}