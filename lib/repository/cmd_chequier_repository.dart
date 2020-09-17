
import 'package:gui/models/reponse.dart';

abstract class CmdChequierRepository {

  Future<Reponse> request(String compte, String agence, String typeChequier, String volumeChequier);

}