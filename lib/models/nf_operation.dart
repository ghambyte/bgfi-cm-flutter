
class NFOperation {
  String reference;
  String date;
  String montant;
  String sens;
  String libelle;


  NFOperation({this.reference, this.date, this.montant, this.sens, this.libelle});

  NFOperation.fromMap(Map<String, dynamic> map)
      : reference = map["reference"],
        date = map["date"],
        sens = map["sens"],
        montant = map["montant"],
        libelle = map["libelle"];
}