
import 'package:gui/models/reponse.dart';

abstract class CanalSolRepository {

  Future<Reponse> payer(String secret, String carte, String formule, String duree, String charme, String agence);

  Future<Reponse> confirmer(String id, int action, String token);
}