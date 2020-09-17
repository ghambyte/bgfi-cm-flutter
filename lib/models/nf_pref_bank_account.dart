class NFPrefBankAccount {

  String pays;

  String codepays;

  String banque;

  String nom;

  String prenom;

  String codebanque;

  String codeagence;

  String compte;

  NFPrefBankAccount({this.pays, this.codepays, this.banque, this.nom, this.prenom, this.codebanque, this.codeagence, this.compte});

  NFPrefBankAccount.fromMap(Map<String, dynamic> map)
      : pays = map['pays'],
        codepays = map['codepays'],
        banque = map['banque'],
        nom = map['nom'],
        prenom = map['prenom'],
        codebanque = map['codebanque'],
        codeagence = map['codeagence'],
        compte = map['compte'];
}