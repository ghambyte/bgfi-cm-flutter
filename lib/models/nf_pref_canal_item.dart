
import 'dart:convert';

import 'package:gui/models/nf_pref_bank_account.dart';
import 'package:gui/tools/utils.dart';

class NfPrefCanalItem {

  String valeur;

  String idpreference;

  String libelle;

  NfPrefCanalItem({this.valeur, this.idpreference, this.libelle});

  NfPrefCanalItem.fromMap(Map<String, dynamic> map)
      : valeur = map["valeur"],
        idpreference = map["idpreference"],
        libelle = map["libelle"];

  NFPrefBankAccount nfPrefBankAccount() => NFPrefBankAccount.fromMap(json.decode(valeur));

  String carte() => valeur;

}