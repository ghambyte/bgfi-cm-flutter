import 'dart:core';

class JournalCompte{

  int id;
  String dateMouvement;
  String libelle;
  String montant;
  String dateValeur;
  String sens;
  String soldeCourant;
  String numeroCompte;
  String idMouvement;


  JournalCompte(this.dateMouvement, this.libelle, this.montant, this.dateValeur,
      this.sens, this.soldeCourant, this.numeroCompte, this.idMouvement);

  JournalCompte.fromMap(Map<String, dynamic> map){
    this.dateMouvement = map['dateMouvement'];
    this.libelle = map['libelle'];
    this.montant = map['montant'];
    this.dateValeur = map['dateValeur'];
    this.sens = map['sens'];
    this.soldeCourant = map['soldeCourant'];
    this.numeroCompte = map['numeroCompte'];
    this.idMouvement = map['idMouvement'];
  }

  fromMap(Map<String, dynamic> map){
    this.dateMouvement = map['dateMouvement'];
    this.libelle = map['libelle'];
    this.montant = map['montant'];
    this.dateValeur = map['dateValeur'];
    this.sens = map['sens'];
    this.soldeCourant = map['soldeCourant'];
    this.numeroCompte = map['numeroCompte'];
    this.idMouvement = map['idMouvement'];
  }
}