import 'dart:core';

import 'package:gui/models/horaireAgence.dart';
import 'package:gui/models/journal_compte.dart';

class JournalCompteBank{

  int id;
  List<JournalCompte> journalJour;
  List<JournalCompte> journal;

  JournalCompteBank({this.journalJour, this.journal});

  JournalCompteBank.fromMap(Map<String, dynamic> map){
    this.journal = map['journal'];
    this.journalJour = map['journal_jour'];
  }

  fromMap(Map<String, dynamic> map){
    this.journal = map['journal'];
    this.journalJour = map['journal_jour'];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'journal': this.journal,
      'journalJour': this.journalJour,
    };
  }
}