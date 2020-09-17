import 'dart:core';

class Gabs{

  String id;
  String label;
  String latitude;
  String longitude;
  String telephone;
  String adresse;
  int etat;


  Gabs({this.id, this.label, this.latitude, this.longitude, this.telephone,
      this.adresse, this.etat});

  Gabs.fromMap(Map<String, dynamic> map){
    this.label = map['label'];
    this.latitude = map['latitude'];
    this.longitude = map['longitude'];
    this.telephone = map['telephone'];
    this.adresse = map['adresse'];
  }

  fromMap(Map<String, dynamic> map){
    this.label = map['label'];
    this.latitude = map['latitude'];
    this.longitude = map['longitude'];
    this.telephone = map['telephone'];
    this.adresse = map['adresse'];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'label': this.label,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'telephone': this.telephone,
      'adresse': this.adresse,
    };
    if(id != null){
      map['id'] = this.id;
      map['label'] = this.label;
      map['latitude'] = this.latitude;
      map['longitude'] = this.longitude;
      map['telephone'] = this.telephone;
      map['adresse'] = this.adresse;
    }
  }
}