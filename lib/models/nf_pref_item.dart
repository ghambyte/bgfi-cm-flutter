
import 'dart:convert';

import 'package:gui/models/nf_pref_bank_account.dart';
import 'package:gui/tools/utils.dart';

class NfPrefItem {

  String valeur;

  String idpreference;

  String libelle;

  NfPrefItem({this.valeur, this.idpreference, this.libelle});

  NfPrefItem.fromMap(Map<String, dynamic> map)
      : valeur = map["valeur"],
        idpreference = map["idpreference"],
        libelle = map["libelle"];

  NFPrefBankAccount nfPrefBankAccount() => NFPrefBankAccount.fromMap(json.decode(Utils.decodeBase64(valeur)));

  String carte() => Utils.decodeBase64(valeur);

}