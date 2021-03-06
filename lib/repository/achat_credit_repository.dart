
import 'package:gui/models/reponse.dart';

abstract class AchatCreditRepository {

  Future<Reponse> payer(String secret, double montant, String mobile, String carrier);

  Future<Reponse> confirmer(String id, int action, String token);
}