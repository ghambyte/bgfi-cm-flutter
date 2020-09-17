
class NFDetailsInfo {

  String label;

  String value;

  NFDetailsInfo({this.label, this.value});

  NFDetailsInfo.fromMap(Map<String, dynamic> map)
      : label = map["label"],
        value = map["value"];
}