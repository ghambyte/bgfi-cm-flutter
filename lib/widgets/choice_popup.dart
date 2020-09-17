
  import 'package:flutter/material.dart';
  import 'package:gui/models/nf_pref_bank_account.dart';
  import 'package:gui/models/nf_pref_item.dart';

  abstract class ChoicePopup {

    void choice(NFPrefBankAccount nfPrefBankAccount);

    void choiceString(String carte);

    Future<Null> dialogChoice(BuildContext context, String title, List<NfPrefItem> nfPrefItems, {bool items: true}) async{
      return showDialog(
          context: context,
          builder: (BuildContext context){
              return new SimpleDialog(
              title: new Text(title),
              children: nfPrefItems.map((NfPrefItem value) {
                return new SimpleDialogOption(
                  child: new Text(value.libelle),
                    onPressed: () {
                      Navigator.pop(context);
                      items?choice(value.nfPrefBankAccount()): choiceString(value.carte());
                    }
                  );
                }).toList(),
              );
          });

    }
  }