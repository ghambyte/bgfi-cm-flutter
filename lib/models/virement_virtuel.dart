import 'dart:core';

class VirementVirtuel{

  int id;
  String virementId;
  String compteADebiter;
  String compteACrediter;
  String libelle;
  String montant;
  String dateDemande;
  String deviseTransfert;
  String dateExecutionDemande;
  String etatVirementId;
  String codeClient;
  String motif;
  String observation;
  String etat;


  VirementVirtuel(this.virementId, this.compteADebiter, this.compteACrediter,
      this.libelle, this.montant, this.dateDemande, this.deviseTransfert,
      this.dateExecutionDemande, this.etatVirementId, this.codeClient,
      this.motif, this.observation, this.etat);

  VirementVirtuel.fromMap(Map<String, dynamic> map){
    this.virementId = map['virementId'];
    this.compteADebiter = map['compteADebiter'];
    this.compteACrediter = map['compteACrediter'];
    this.libelle = map['libelle'];
    this.montant = map['montant'];
    this.dateDemande = map['dateDemande'];
    this.deviseTransfert = map['deviseTransfert'];
    this.dateExecutionDemande = map['dateExecutionDemande'];
    this.etatVirementId = map['etatVirementId'];
    this.codeClient = map['codeClient'];
    this.motif = map['motif'];
    this.observation = map['observation'];
    this.etat = map['etat'];
  }

  fromMap(Map<String, dynamic> map){
    this.virementId = map['virementId'];
    this.compteADebiter = map['compteADebiter'];
    this.compteACrediter = map['compteACrediter'];
    this.libelle = map['libelle'];
    this.montant = map['montant'];
    this.dateDemande = map['dateDemande'];
    this.deviseTransfert = map['deviseTransfert'];
    this.dateExecutionDemande = map['dateExecutionDemande'];
    this.etatVirementId = map['etatVirementId'];
    this.codeClient = map['codeClient'];
    this.motif = map['motif'];
    this.observation = map['observation'];
    this.etat = map['etat'];
  }
}