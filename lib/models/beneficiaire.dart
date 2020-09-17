import 'dart:core';

import 'dart:convert';
import 'package:gui/models/horaireAgence.dart';
import 'package:gui/tools/utils.dart';

class Beneficiaire{

  String id;
  String nombeneficiaire;
  String nombanque;
  String actif;
  String codeClient;
  String dateDemande;
  String typeCompte;
  String codeBanque;
  String codeGuichet;
  String numerocompte;


  Beneficiaire({this.id, this.nombeneficiaire, this.nombanque, this.actif,
      this.codeClient, this.dateDemande, this.typeCompte, this.codeBanque,
      this.codeGuichet, this.numerocompte});

  Beneficiaire.fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.nombeneficiaire = map['nombeneficiaire'];
    this.nombanque = map['nombanque'];
    this.actif = map['actif'];
    this.codeClient = map['codeClient'];
    this.dateDemande = map['dateDemande'];
    this.typeCompte = map['typeCompte'];
    this.codeBanque = map['codeBanque'];
    this.codeGuichet = map['codeGuichet'];
    this.numerocompte = map['numerocompte'];
  }

  fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.nombeneficiaire = map['nombeneficiaire'];
    this.nombanque = map['nombanque'];
    this.actif = map['actif'];
    this.codeClient = map['codeClient'];
    this.dateDemande = map['dateDemande'];
    this.typeCompte = map['typeCompte'];
    this.codeBanque = map['codeBanque'];
    this.codeGuichet = map['codeGuichet'];
    this.numerocompte = map['numerocompte'];
  }

  Beneficiaire nfPrefBeneficiaire() => Beneficiaire.fromMap(json.decode(Utils.decodeBase64(numerocompte)));

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'nombeneficiaire': this.nombeneficiaire,
      'nombanque': this.nombanque,
      'actif': this.actif,
      'codeClient': this.codeClient,
      'dateDemande': this.dateDemande,
      'typeCompte': this.typeCompte,
      'codeBanque': this.codeBanque,
      'codeGuichet': this.codeGuichet,
      'numerocompte': this.numerocompte
    };
    if(id != null){
      map['id'] = this.id;
      map['nombeneficiaire'] = this.nombeneficiaire;
      map['nombanque'] = this.nombanque;
      map['actif'] = this.actif;
      map['codeClient'] = this.codeClient;
      map['dateDemande'] = this.dateDemande;
      map['typeCompte'] = this.typeCompte;
      map['codeBanque'] = this.codeBanque;
      map['codeGuichet'] = this.codeGuichet;
      map['numerocompte'] = this.numerocompte;
    }
  }
}