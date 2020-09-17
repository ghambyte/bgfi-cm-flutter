
class NFTCVInfo {

  String label;

  String value;

  String code;

  NFTCVInfo({this.label, this.value, this.code});

  NFTCVInfo.fromMap(Map<String, dynamic> map)
      : label = map["label"],
        value = map["value"],
        code = map["code"];
}