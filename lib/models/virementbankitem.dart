import 'dart:core';

import 'package:gui/models/horaireAgence.dart';

class VirementBankItem{

  String id;
  String numCptADebiter;
  String codeagence;
  String nomBanque;
  String nomBeneficiaire;
  String codeBanque;
  String codeGuichet;
  String compte;
  String libelle;
  String montant;


  VirementBankItem(this.numCptADebiter,this.codeagence, this.nomBanque, this.nomBeneficiaire,
      this.codeBanque, this.codeGuichet, this.compte, this.libelle,
      this.montant);

  VirementBankItem.fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.numCptADebiter = map['numCptADebiter'];
    this.codeagence = map['codeagence'];
    this.nomBanque = map['nomBanque'];
    this.nomBeneficiaire = map['nomBeneficiaire'];
    this.codeBanque = map['codeBanque'];
    this.codeGuichet = map['codeGuichet'];
    this.compte = map['compte'];
    this.libelle = map['libelle'];
    this.montant = map['montant'];
  }

  fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.numCptADebiter = map['numCptADebiter'];
    this.codeagence = map['codeagence'];
    this.nomBanque = map['nomBanque'];
    this.nomBeneficiaire = map['nomBeneficiaire'];
    this.codeBanque = map['codeBanque'];
    this.codeGuichet = map['codeGuichet'];
    this.compte = map['compte'];
    this.libelle = map['libelle'];
    this.montant = map['montant'];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'numCptADebiter': this.numCptADebiter,
      'codeagence': this.codeagence,
      'nomBanque': this.nomBanque,
      'nomBeneficiaire': this.nomBeneficiaire,
      'codeBanque': this.codeBanque,
      'codeGuichet': this.codeGuichet,
      'compte': this.compte,
      'libelle': this.libelle,
      'montant': this.montant
    };
    if(id != null){
      map['id'] = this.id;
      map['numCptADebiter'] = this.numCptADebiter;
      map['codeagence'] = this.codeagence;
      map['nomBanque'] = this.nomBanque;
      map['nomBeneficiaire'] = this.nomBeneficiaire;
      map['codeBanque'] = this.codeBanque;
      map['codeGuichet'] = this.codeGuichet;
      map['compte'] = this.compte;
      map['libelle'] = this.libelle;
      map['montant'] = this.montant;
    }
  }
}