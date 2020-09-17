
import 'package:gui/prod/prod_achat_credit.dart';
import 'package:gui/prod/prod_beneficiaire.dart';
import 'package:gui/prod/prod_bgfi_express.dart';
import 'package:gui/prod/prod_canal_massando.dart';
import 'package:gui/prod/prod_canal_plus.dart';
import 'package:gui/prod/prod_canal_sol.dart';
import 'package:gui/prod/prod_cmd_chequier.dart';
import 'package:gui/prod/prod_compte_banque.dart';
import 'package:gui/prod/prod_dmd_rv.dart';
import 'package:gui/prod/prod_fenix.dart';
import 'package:gui/prod/prod_historique.dart';
import 'package:gui/prod/prod_journal_compte.dart';
import 'package:gui/prod/prod_messagerie.dart';
import 'package:gui/prod/prod_miles_travel.dart';
import 'package:gui/prod/prod_paiement_line.dart';
import 'package:gui/prod/prod_paiement_marchant.dart';
import 'package:gui/prod/prod_point_vente.dart';
import 'package:gui/prod/prod_preference_repository.dart';
import 'package:gui/prod/prod_reseau_gab.dart';
import 'package:gui/prod/prod_retrait_cash.dart';
import 'package:gui/prod/prod_security.dart';
import 'package:gui/prod/prod_taux_change.dart';
import 'package:gui/prod/prod_transfert_cpte_banque.dart';
import 'package:gui/prod/prod_transfert_cpte_virtuel.dart';
import 'package:gui/prod/prod_transfert_gab.dart';
import 'package:gui/prod/prod_virement_banque.dart';
import 'package:gui/prod/prod_virement_cpte_virtuel.dart';
import 'package:gui/repository/achat_credit_repository.dart';
import 'package:gui/repository/beneficiaire_repository.dart';
import 'package:gui/repository/bgfi_express_repository.dart';
import 'package:gui/repository/canal_massando_repository.dart';
import 'package:gui/repository/canal_plus_repository.dart';
import 'package:gui/repository/canal_sol_repository.dart';
import 'package:gui/repository/cmd_chequier_repository.dart';
import 'package:gui/repository/compte_banque_repository.dart';
import 'package:gui/repository/dmd_rv_repository.dart';
import 'package:gui/repository/historique_repository.dart';
import 'package:gui/repository/journal_banque_repository.dart';
import 'package:gui/repository/messagerie_repository.dart';
import 'package:gui/repository/miles_travel_repository.dart';
import 'package:gui/repository/paiement_line_repository.dart';
import 'package:gui/repository/paiement_marchant_repository.dart';
import 'package:gui/repository/point_vente_repository.dart';
import 'package:gui/repository/preference_repository.dart';
import 'package:gui/repository/reseau_gab_repository.dart';
import 'package:gui/repository/retrait_cash_repository.dart';
import 'package:gui/repository/security_repository.dart';
import 'package:gui/repository/taux_change_repository.dart';
import 'package:gui/repository/transfert_cpt_banque_repository.dart';
import 'package:gui/repository/transfert_cpt_virtuel_repository.dart';
import 'package:gui/repository/transfert_gab_repository.dart';
import 'package:gui/repository/fenix_repository.dart';
import 'package:gui/repository/virement_banque_repository.dart';
import 'package:gui/repository/virement_cv_repository.dart';
import 'package:gui/tools/config.dart';

class InjectorApp {

  static final InjectorApp _singleton = new InjectorApp._internal();

  static FLAVOR _flavor;

  static void configure( FLAVOR flavor) {
    _flavor = flavor;
  }

  factory InjectorApp() {
    return _singleton;
  }

  InjectorApp._internal();

  SecurityRepository get securityRepository {
      return new ProdSecurityRepository();
  }

  HistoriqueRepository get historiqueRepository {
      return new ProdHistoriqueRepository();
  }

  PaiementMarchantRepository get paiementMarchantRepository {
      return new ProdPaiementMarchantRepository();
  }

  TransfertGabRepository get transfertGabRepository => new ProdTransfertGabRepository();

  RetraitCashRepository get retraitCashRepository => new ProdRetraitCashRepository();

  MilesTravelRepository get milesTravelRepository => new ProdMilesTravelRepository();

  AchatCreditRepository get achatCreditRepository => new ProdAchatCreditRepository();

  TransfertCompteBanqueRepository get transfertCompteBanqueRepository => new ProdTransfertCompteBanqueRepository();

  PaiementLineRepository get paiementLineRepository => new ProdPaiementLineRepository();

  TransfertCompteVirtuelRepository get transfertCompteVirtuelRepository => new ProdTransfertCompteVirtuelRepository();

  FenixRepository get fenixRepository => new ProdFenixRepository();

  BgfiExpressRepository get bgfiExpressRepository => new ProdBgfiExpressRepository();

  PreferenceRepository get preferenceRepository => new ProdPreferenceRepository();

  CanalPlusRepository get canalPlusRepository => new ProdCanalPlusRepository();

  CanalSolRepository get canalSolRepository => new ProdCanalSolRepository();

  CanalMassandoRepository get canalMassandoRepository => new ProdCanalMassandoRepository();

  DmdRvRepository get dmdRvRepository => new ProdDmdRvRepository();

  CmdChequierRepository get cmdChequierRepository => new ProdCmdChequierRepository();

  PointVenteRepository get pointVenteRepository => new ProdPointVenteRepository();

  ReseauGabRepository get reseauGabRepository => new ProdReseauGabRepository();

  TauxChangeRepository get tauxChangeRepository => new ProdTauxChangeRepository();

  VirementCVRepository get virementsVirtuelsRepository => new ProdVirementCptVirtuelRepository();

  VirementBanqueRepository get virementsBanqueRepository => new ProdVirementBanqueRepository();

  BeneficiaireRepository get beneficiaireRepository => new ProdBeneficiaireRepository();

  MessagerieRepository get messagerieRepository => new ProdMessagerieRepository();

  JournalBanqueRepository get journalBanqueRepository => new ProdJournalCompteRepository();

  CompteBanqueRepository get compteBanqueRepository => new ProdCompteBanqueRepository();

  Map<String, String> get baseUrl {
    switch(_flavor) {
      case FLAVOR.MOCK:
        return Config.BASE_URL_TEST;
      default:
        return Config.BASE_URL_PROD;
    }
  }
}