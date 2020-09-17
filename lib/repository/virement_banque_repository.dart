
import 'package:gui/models/beneficiaire.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/models/virementbankitem.dart';

abstract class VirementBanqueRepository {

  Future<Reponse> getVirements(int index, String type);

  Future<Reponse> virement(String secret, List<VirementBankItem> beneficiaires);

}