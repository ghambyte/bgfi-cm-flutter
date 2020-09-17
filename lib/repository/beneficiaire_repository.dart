
import 'package:gui/models/reponse.dart';

abstract class BeneficiaireRepository {

  Future<Reponse> getBeneficiaires();

  Future<Reponse> addBeneficiaire(String numCpt,
      String nomTitulaire, String codeBanque, String codeGuichet,
      String nomBanque, String typeCompte);

  Future<Reponse> deleteBeneficiaire(String id);

}