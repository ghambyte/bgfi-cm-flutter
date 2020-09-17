
  import 'package:flutter/material.dart';
  import 'package:gui/models/nf_pref_bank_account.dart';
  import 'package:gui/models/nf_pref_canal_item.dart';

  abstract class ChoiceCanalPopup {

    void choice(NFPrefBankAccount nfPrefBankAccount);

    void choiceString(String carte, String libelle);

    Future<Null> dialogChoice(BuildContext context, String title, List<NfPrefCanalItem> nfPrefItems, {bool items: true}) async{
      return showDialog(
          context: context,
          builder: (BuildContext context){
              return new SimpleDialog(
              title: new Text(title),
              children: nfPrefItems.map((NfPrefCanalItem value) {
                return new SimpleDialogOption(
                  child: new Text(value.libelle),
                    onPressed: () {
                      Navigator.pop(context);
                      items?choice(value.nfPrefBankAccount()): choiceString(value.carte(), value.libelle);
                    }
                  );
                }).toList(),
              );
          });

    }
  }