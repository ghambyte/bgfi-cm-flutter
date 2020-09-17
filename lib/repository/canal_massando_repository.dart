
import 'package:gui/models/reponse.dart';

abstract class CanalMassandoRepository {

  Future<Reponse> payer(String secret, String carte, String formule, String duree, String adulte, String agence);

  Future<Reponse> confirmer(String id, int action, String token);
}