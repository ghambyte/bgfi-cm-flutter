
class VolumeChequier {

  String volume;

  VolumeChequier({this.volume});

  VolumeChequier.fromMap(Map<String, dynamic> map)
      : volume = map["volume"];
}