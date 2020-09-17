
class User {

  int id;

  String nom;

  String caisse;

  String mobile;

  String type;

  String message;

  int code;

  int factor;

  User({this.caisse, this.nom, this.mobile, this.type, this.message, this.code, this.factor});

  User.fromMap(Map<String, dynamic> map)
      : nom= map['nom'],
        caisse= map['caisse'],
        mobile = map['mobile'],
        type = map['type'],
        message = map['message'],
        code = map['code'],
        factor = map['factor'];

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["caisse"] = caisse;
    map["nom"] = nom;
    map["mobile"] = mobile;
    map["type"] = type;
    map["message"] = message;
    map["code"] = code;
    map["factor"] = factor;

    return map;
  }
}