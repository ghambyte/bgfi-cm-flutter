
import 'package:flutter/material.dart';
import 'package:gui/models/beneficiaire.dart';

abstract class ChoicePopup {

  void choice(Beneficiaire nfPrefBankAccount);

  void choiceString(String carte);

  Future<Null> dialogChoiceBenef(BuildContext context, String title, List<Beneficiaire> nfPrefItems, {bool items: true}) async{
    return showDialog(
        context: context,
        builder: (BuildContext context){
            return new SimpleDialog(
            title: new Text(title),
            children: nfPrefItems.map((Beneficiaire value) {
              return new SimpleDialogOption(
                child: new Text(value.nombeneficiaire),
                  onPressed: () {
                    Navigator.pop(context);
                    items?choice(value): choiceString(value.numerocompte);
                  }
                );
              }).toList(),
            );
        });

  }
}