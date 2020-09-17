import 'dart:core';

class NewVirementItem{

  int id;
  String numCptADebiter;
  String nomBanque;
  String nomBeneficiaire;
  String codeBanque;
  String codeGuichet;
  String compte;
  String libelle;
  String montant;


  NewVirementItem(this.numCptADebiter, this.nomBanque, this.nomBeneficiaire,
      this.codeBanque, this.codeGuichet, this.compte, this.libelle,
      this.montant);

  NewVirementItem.fromMap(Map<String, dynamic> map){
    this.numCptADebiter = map['numCptADebiter'];
    this.nomBanque = map['nomBanque'];
    this.nomBeneficiaire = map['nomBeneficiaire'];
    this.codeBanque = map['codeBanque'];
    this.codeGuichet = map['codeGuichet'];
    this.compte = map['compte'];
    this.libelle = map['libelle'];
    this.montant = map['montant'];
  }

  fromMap(Map<String, dynamic> map){
    this.numCptADebiter = map['numCptADebiter'];
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
      map['nomBanque'] = this.nomBanque;
      map['nomBeneficiaire'] = this.nomBeneficiaire;
      map['codeBanque'] = this.codeBanque;
      map['codeGuichet'] = this.codeGuichet;
      map['compte'] = this.compte;
      map['libelle'] = this.libelle;
      map['montant'] = this.montant;
    }
    return map;
  }

  @override
  String toString() {
    return 'NewVirementItem{numCptADebiter: $numCptADebiter, nomBanque: $nomBanque, nomBeneficiaire: $nomBeneficiaire, codeBanque: $codeBanque, codeGuichet: $codeGuichet, compte: $compte, libelle: $libelle, montant: $montant}';
  }


}