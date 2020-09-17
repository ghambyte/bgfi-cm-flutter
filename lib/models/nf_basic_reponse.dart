class NFBasicResponse {


  int code;
  String message;
  int factor;

  NFBasicResponse({this.code, this.message, this.factor});

  NFBasicResponse.fromMap(Map<String, dynamic> map)
      : code = map["code"],
        message = map["message"],
        factor = map["factor"];

}