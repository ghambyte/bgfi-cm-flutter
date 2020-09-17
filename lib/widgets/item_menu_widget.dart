import 'package:flutter/material.dart';
import 'package:gui/models/item_menu.dart';
import 'package:gui/tools/color_app.dart';

class ItemMenuWidget extends StatefulWidget {

  ItemMenuWidget({Key key, @required this.itemMenu, @required this.width, @required this.height, @required this.heightText }): super(key: key);

  ItemMenu itemMenu;

  double width;

  double height;

  double heightText;

  @override
  _ItemMenuWidgetState createState() => _ItemMenuWidgetState();
}

class _ItemMenuWidgetState extends State<ItemMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Image.asset(
          widget.itemMenu.icon,
          width: widget.height,
          height: widget.height,
          fit: BoxFit.cover,
        ),
        Container(
          width: widget.width,
          height: widget.heightText,
          child:  Text(widget.itemMenu.texte,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.normal, // light
              fontSize: 12.0,
              color:ColorApp.white,
            ),
          ) ,
        )
      ],
    );
  }
}
