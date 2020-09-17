
import 'package:gui/models/reponse.dart';

abstract class CanalPlusRepository {

  Future<Reponse> payer(String secret, String carte, String formule, String duree, String charme, String ssport, String ecran);

  Future<Reponse> confirmer(String id, int action, String token);
}