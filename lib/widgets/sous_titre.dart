
import 'package:flutter/material.dart';

class SousTitre {

  static PreferredSizeWidget preference(String titre) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: Container(
          width: double.infinity,
          height: 200.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/barS.png',),
              ),
              color: Colors.blue
          ),
          child: new Text(''),
        )
    );
  }
}
