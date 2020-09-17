import 'dart:core';

import 'package:gui/models/horaireAgence.dart';

class TauxChange{

  int id;
  String codeDevise;
  String abrege;
  String libelle;
  String achat_bb;
  String vente_bb;
  String achat_tc;
  String vente_tc;
  String achat_tr;
  String vente_tr;
  String date_maj;


  TauxChange(this.codeDevise, this.abrege, this.libelle, this.achat_bb,
      this.vente_bb, this.achat_tc, this.vente_tc, this.achat_tr, this.vente_tr,
      this.date_maj);

  TauxChange.fromMap(Map<String, dynamic> map){
    this.codeDevise = map['codeDevise'];
    this.abrege = map['abrege'];
    this.libelle = map['libelle'];
    this.achat_bb = map['achat_bb'];
    this.vente_bb = map['vente_bb'];
    this.achat_tc = map['achat_tc'];
    this.vente_tc = map['vente_tc'];
    this.achat_tr = map['achat_tr'];
    this.vente_tr = map['vente_tr'];
    this.date_maj = map['date_maj'];
  }

  fromMap(Map<String, dynamic> map){
    this.codeDevise = map['codeDevise'];
    this.abrege = map['abrege'];
    this.libelle = map['libelle'];
    this.achat_bb = map['achat_bb'];
    this.vente_bb = map['vente_bb'];
    this.achat_tc = map['achat_tc'];
    this.vente_tc = map['vente_tc'];
    this.achat_tr = map['achat_tr'];
    this.vente_tr = map['vente_tr'];
    this.date_maj = map['date_maj'];
  }
}