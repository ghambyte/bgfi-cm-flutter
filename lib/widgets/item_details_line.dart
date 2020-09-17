
import 'package:flutter/material.dart';
import 'package:gui/tools/color_app.dart';

class ItemDetailsLinePage extends StatelessWidget {

  final String cle;

  final String value;

  ItemDetailsLinePage({this.cle, this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(cle, style : new TextStyle(color: ColorApp.darkGreen),),
        Expanded(
          child: Text(value,
              textAlign: TextAlign.right,
              style : new TextStyle(color: ColorApp.darkGreen,fontWeight: FontWeight.bold,fontSize:12.0)
          ),
        )
      ],
    );
  }
}
