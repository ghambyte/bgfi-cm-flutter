
import 'package:gui/models/reponse.dart';

abstract class PointVenteRepository {

  Future<Reponse> getPointsVente(int index, String type);

}