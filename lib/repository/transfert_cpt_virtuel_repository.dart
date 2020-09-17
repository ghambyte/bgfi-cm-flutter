
import 'package:gui/models/reponse.dart';

abstract class TransfertCompteVirtuelRepository {

  Future<Reponse> payer(String secret, double montant, String compteBeneficiaire, String iden);

  Future<Reponse> confirmer(String id, int action, String token, String isgimac);

}