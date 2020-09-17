
import 'package:gui/models/reponse.dart';

abstract class TauxChangeRepository {

  Future<Reponse> getTauxChange(int index, String type);

}