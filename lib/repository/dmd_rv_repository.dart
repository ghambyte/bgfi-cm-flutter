
import 'package:gui/models/reponse.dart';

abstract class DmdRvRepository {

  Future<Reponse> demanderRV(/*String secret, */String compte, String objet, String date, String agence);

}