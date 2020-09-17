import 'package:gui/models/reponse.dart';

class FetchException implements Exception {

  final _message;

  FetchException([this._message]);

  String toString() {
    if(_message==null) return "Exception";
    return "$_message";
  }

  Reponse get response {
    return _message;
  }

}