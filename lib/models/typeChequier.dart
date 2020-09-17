import 'dart:core';

class TypeChequier{

  String idType;
  String codeType;
  String libelleType;


  TypeChequier({this.idType, this.codeType, this.libelleType});

  TypeChequier.fromMap(Map<String, dynamic> map){
    this.idType = map['idType'];
    this.codeType = map['codeType'];
    this.libelleType = map['libelleType'];
  }

  fromMap(Map<String, dynamic> map){
    this.idType = map['idType'];
    this.codeType = map['codeType'];
    this.libelleType = map['libelleType'];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'idType': this.idType,
      'codeType': this.codeType,
      'libelleType': this.libelleType,
    };
    if(idType != null){
      map['idType'] = this.idType;
      map['codeType'] = this.codeType;
      map['libelleType'] = this.libelleType;
    }
  }
}