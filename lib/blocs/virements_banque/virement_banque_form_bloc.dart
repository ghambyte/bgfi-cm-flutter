
import 'dart:async';

import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/validator/virement_bank_validator.dart';
import 'package:rxdart/rxdart.dart';

class VirementBanqueFormBloc extends Object with VirementBankValidator implements BlocBase {

  final BehaviorSubject<String> _secretController = BehaviorSubject<String>();
  final BehaviorSubject<String> _numCompteBeneficiaireController = BehaviorSubject<String>();
  final BehaviorSubject<String> _nomBanqueController = BehaviorSubject<String>();
  final BehaviorSubject<String> _nomBeneficiaireController = BehaviorSubject<String>();
  final BehaviorSubject<String> _codeBanqueController = BehaviorSubject<String>();
  final BehaviorSubject<String> _codeGuichetController = BehaviorSubject<String>();
  final BehaviorSubject<String> _libelleController = BehaviorSubject<String>();
  final BehaviorSubject<String> _numCompteController = BehaviorSubject<String>();
  final BehaviorSubject<String> _montantController = BehaviorSubject<String>();
  final BehaviorSubject<String> _typeCompteController = BehaviorSubject<String>();

  Function(String) get onSecretChanged => _secretController.sink.add;
  Function(String) get onNumCompteBeneficiaireChanged => _numCompteBeneficiaireController.sink.add;
  Function(String) get onNumCompteChanged => _numCompteController.sink.add;
  Function(String) get onNomBanqueChanged => _nomBanqueController.sink.add;
  Function(String) get onNomBeneficiaireChanged => _nomBeneficiaireController.sink.add;
  Function(String) get onCodeBanqueChanged => _codeBanqueController.sink.add;
  Function(String) get onCodeGuichetChanged => _codeGuichetController.sink.add;
  Function(String) get onLibelleChanged => _libelleController.sink.add;
  Function(String) get onMontantChanged => _montantController.sink.add;

  Stream<String> get secret => _secretController.stream.transform(validateSecret);
  Stream<String> get numCompteBenef => _numCompteBeneficiaireController.stream.transform(validateNumCompteBeneficiaire);
  Stream<String> get nomBanque => _nomBanqueController.stream.transform(validateNomBanque);
  Stream<String> get nomBenef => _nomBeneficiaireController.stream.transform(validateNomBenef);
  Stream<String> get codeBanque => _codeBanqueController.stream.transform(validateCodeBanque);
  Stream<String> get codeGuichet => _codeGuichetController.stream.transform(validateCodeGuicher);
  Stream<String> get libelle => _libelleController.stream.transform(validateLibelle);
  Stream<String> get compte => _numCompteController.stream.transform(validateCompte);
  Stream<String> get montant => _montantController.stream.transform(validateMontant);
  Stream<String> get carrier => _typeCompteController.stream.transform(validateType);


  Stream<bool> get submitValidation => Observable.combineLatest4(
      secret,
      numCompteBenef,
      nomBenef,
      codeGuichet,
          (s, m, mo, c) => true
  );

  Stream<bool> get submitPreference => Observable.combineLatest3(
      numCompteBenef,
      nomBenef,
      codeGuichet,
          (b, p, tn) => true
  );

  @override
  void dispose() {
    _secretController?.close();
    _numCompteBeneficiaireController?.close();
    _nomBanqueController?.close();
    _nomBeneficiaireController?.close();
    _codeBanqueController?.close();
    _libelleController?.close();
    _codeGuichetController?.close();
    _numCompteController?.close();
    _montantController?.close();
    // TODO: implement dispose
  }


}