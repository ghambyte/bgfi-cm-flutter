
class ReponseList<T> {

  int statutcode;

  int currentStatut;

  int page;

  String message;

  List<T> reponses;

  Map<String, dynamic> reponse;

  ReponseList({this.statutcode, this.message, this.reponses, this.page, this.currentStatut});

}