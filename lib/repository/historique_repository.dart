
import 'package:gui/models/reponse.dart';

abstract class HistoriqueRepository {

  //Recuperation du token mobile money
  Future<Reponse> getInfo(int index, String type);

  Future<Reponse> detailsInfo(String codeSecret, String reference);
}