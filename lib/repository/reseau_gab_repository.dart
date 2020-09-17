
import 'package:gui/models/reponse.dart';

abstract class ReseauGabRepository {

  Future<Reponse> getReseauGab(int index, String type);

}