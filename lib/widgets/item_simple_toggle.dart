
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
            ? Icon(Icons.expand_less, color: ColorApp.blue,)
            : Icon(Icons.expand_more, color: ColorApp.blue,),
          Expanded(child: Text('$title', style : new TextStyle(color: ColorApp.darkGreen,fontWeight: FontWeight.bold,fontSize:12.0),)),
        ],
      ),
      trailing: Container(
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
