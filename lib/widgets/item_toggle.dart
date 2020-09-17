
import 'package:flutter/material.dart';
import 'package:gui/tools/color_app.dart';

class ItemTogglePage extends StatelessWidget {

  final bool leading;
  final String title;
  final trailing;

  ItemTogglePage({this.leading, this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          leading
            ? Icon(Icons.expand_less, color: ColorApp.green,)
            : Icon(Icons.expand_more, color: ColorApp.darkGreen,),
          Expanded(child: Text('$title XAF', style : new TextStyle(fontSize: 10.0, color: ColorApp.darkGreen,fontWeight: FontWeight.bold,),)),
        ],
      ),
      trailing: Container(
        decoration: new BoxDecoration(
          color: trailing=="C"?Colors.green:Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 15.0),
        margin: EdgeInsets.symmetric(vertical: 0.0,horizontal: 0.0),
        child: new Text(trailing,
            style : new TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:12.0)
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      dense: true,
    );
  }
}
