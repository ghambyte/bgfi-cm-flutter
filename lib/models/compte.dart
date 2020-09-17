import 'dart:core';

class Compte{

  int id;
  String numeroCompte;
  String titulaire;
  String libelleCompte;
  String deviseDuCompte;
  String solde;
  String codeClient;
  String agence;
  String libelleAgence;
  String nomCompletGestionnaire;
  String typeCompte;

  Compte({this.numeroCompte, this.titulaire, this.libelleCompte,
      this.deviseDuCompte, this.solde, this.codeClient, this.agence,
      this.libelleAgence, this.nomCompletGestionnaire, this.typeCompte});

  Compte.fromMap(Map<String, dynamic> map){
    this.numeroCompte = map['numeroCompte'];
    this.titulaire = map['titulaire'];
    this.libelleCompte = map['libelleCompte'];
    this.deviseDuCompte = map['deviseDuCompte'];
    this.solde = map['solde'];
    this.codeClient = map['codeClient'];
    this.agence = map['agence'];
    this.libelleAgence = map['libelleAgence'];
    this.nomCompletGestionnaire = map['nomCompletGestionnaire'];
    this.typeCompte = map['typeCompte'];
  }

  fromMap(Map<String, dynamic> map){
    this.numeroCompte = map['numeroCompte'];
    this.titulaire = map['titulaire'];
    this.libelleCompte = map['libelleCompte'];
    this.deviseDuCompte = map['deviseDuCompte'];
    this.solde = map['solde'];
    this.codeClient = map['codeClient'];
    this.agence = map['agence'];
    this.libelleAgence = map['libelleAgence'];
    this.nomCompletGestionnaire = map['nomCompletGestionnaire'];
    this.typeCompte = map['typeCompte'];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'numeroCompte': this.numeroCompte,
      'titulaire': this.titulaire,
      'libelleCompte': this.libelleCompte,
      'deviseDuCompte': this.deviseDuCompte,
      'solde': this.solde,
      'codeClient': this.codeClient,
      'agence': this.agence,
      'libelleAgence': this.libelleAgence,
      'nomCompletGestionnaire': this.nomCompletGestionnaire,
      'typeCompte': this.typeCompte
    };
    if(id != null){
      map['id'] = this.id;
      map['numeroCompte'] = this.numeroCompte;
      map['titulaire'] = this.titulaire;
      map['libelleCompte'] = this.libelleCompte;
      map['deviseDuCompte'] = this.deviseDuCompte;
      map['solde'] = this.solde;
      map['codeClient'] = this.codeClient;
      map['agence'] = this.agence;
      map['libelleAgence'] = this.libelleAgence;
      map['nomCompletGestionnaire'] = this.nomCompletGestionnaire;
      map['typeCompte'] = this.typeCompte;
    }
    return map;
  }
}