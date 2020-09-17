
import 'package:gui/models/reponse.dart';

abstract class VirementCVRepository {

  Future<Reponse> getVirements(int index, String type);

  Future<Reponse> virement(String secret, String source, String codeAgence, String motif, String compteVirtuel, String montant);

}