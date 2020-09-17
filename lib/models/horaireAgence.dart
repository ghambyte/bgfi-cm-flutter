import 'dart:core';

class HoraireAgence{

  String id;
  String jourSemaine;
  String heureOuverture;
  String heureFermeture;
  String codeAgence;

  HoraireAgence(){}

  HoraireAgence.fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.jourSemaine = map['jourSemaine'];
    this.heureOuverture = map['heureOuverture'];
    this.heureFermeture = map['heureFermeture'];
    this.codeAgence = map['codeAgence'];
  }

  fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.jourSemaine = map['jourSemaine'];
    this.heureOuverture = map['heureOuverture'];
    this.heureFermeture = map['heureFermeture'];
    this.codeAgence = map['codeAgence'];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'id': this.id,
      'jourSemaine': this.jourSemaine,
      'heureOuverture': this.heureOuverture,
      'heureFermeture': this.heureFermeture,
      'codeAgence': this.codeAgence
    };
    if(id != null){
      map['id'] = this.id;
      map['jourSemaine'] = this.jourSemaine;
      map['heureOuverture'] = this.heureOuverture;
      map['heureFermeture'] = this.heureFermeture;
      map['codeAgence'] = this.codeAgence;
    }
  }
}