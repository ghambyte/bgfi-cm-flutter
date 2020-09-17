
import 'package:flutter/material.dart';
import 'package:gui/tools/color_app.dart';

class ItemDetailsLineJBPage extends StatelessWidget {

  final String cle;

  final String value;

  ItemDetailsLineJBPage({this.cle, this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(cle, style : new TextStyle(color: ColorApp.darkblue, fontStyle: FontStyle.italic),),
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
