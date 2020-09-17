
import 'package:flutter/material.dart';
import 'package:gui/tools/color_app.dart';

class ItemDetailsLineJournalBankingPage extends StatelessWidget {

  final String cle;

  final String value;

  ItemDetailsLineJournalBankingPage({this.cle, this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(cle, style : new TextStyle(color: ColorApp.darkblue, fontStyle: FontStyle.italic,fontSize:10.0),),
        Expanded(
          child: Text(value,
              textAlign: TextAlign.right,
              style : new TextStyle(color: ColorApp.darkblue,fontWeight: FontWeight.bold,fontSize:12.0)
          ),
        )
      ],
    );
  }
}
