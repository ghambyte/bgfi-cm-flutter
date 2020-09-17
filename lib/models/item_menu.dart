
import 'package:flutter/material.dart';

class ItemMenu {

  String icon;

  String texte;

  Widget widget;

  bool hist;

  bool compte;
  bool gab;

  int index;

  Widget image;

  ItemMenu({this.icon, this.texte, this.widget, this.hist: false, this.compte: false, this.gab: false, this.index, this.image});
}