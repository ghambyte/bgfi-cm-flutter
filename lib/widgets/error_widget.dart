
import 'package:flutter/material.dart';

abstract class ErrorWideget {

  void refresh();

  Widget buildError(BuildContext context, String message, Color color) {
    return new Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('OUPS!', style: TextStyle(color: Colors.red, fontSize: 17.0, fontWeight: FontWeight.bold),),
          Text(message, style: TextStyle(color: Colors.black45, fontSize: 15.0, fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: RaisedButton(
              onPressed: () => refresh(),
              child: Text('RAFRAICHIR', style: TextStyle(color: Colors.white),),
              color: color,
            ),
          )
        ],
      ),
    );
  }
}