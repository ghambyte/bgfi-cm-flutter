
import 'dart:async';

import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/validator/transfert_cv_validator.dart';
import 'package:rxdart/rxdart.dart';

class VirementsVirtuelsFormBloc extends Object with TransfertCVValidator implements BlocBase {

  final BehaviorSubject<String> _secretController = BehaviorSubject<String>();
  final BehaviorSubject<String> _sourceController = BehaviorSubject<String>();
  final BehaviorSubject<String> _motifController = BehaviorSubject<String>();
  final BehaviorSubject<String> _nroCptController = BehaviorSubject<String>();
  final BehaviorSubject<String> _montantController = BehaviorSubject<String>();

  Function(String) get onSecretChanged => _secretController.sink.add;
  Function(String) get onSourceChanged => _sourceController.sink.add;
  Function(String) get onMotifChanged => _motifController.sink.add;
  Function(String) get onNroCptChanged => _nroCptController.sink.add;
  Function(String) get onMontantChanged => _montantController.sink.add;

  Stream<String> get secret => _secretController.stream.transform(validateSecret);
  Stream<String> get source => _sourceController.stream.transform(validateSource);
  Stream<String> get motif => _motifController.stream.transform(validateMotif);
  Stream<String> get nroCompteViruel => _nroCptController.stream.transform(validateNroCptVirtuel);
  Stream<String> get montant => _montantController.stream.transform(validateMontant);

  Stream<bool> get submitValidation => Observable.combineLatest4(
      secret,
      montant,
      motif,
      nroCompteViruel,
          (s, m, mo, c) => true
  );

  @override
  void dispose() {
    _secretController?.close();
    _motifController?.close();
    _nroCptController?.close();
    _montantController?.close();
    // TODO: implement dispose
  }


}