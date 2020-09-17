
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/validator/Login_validator.dart';
import 'package:gui/validator/input_length_validator.dart';
import 'package:rxdart/rxdart.dart';

class BgfiExpressFormBloc extends Object with LoginValidator, InputLengthValidator implements BlocBase {

  final BehaviorSubject<String> _secretController = BehaviorSubject<String>();
  final BehaviorSubject<String> _montantController = BehaviorSubject<String>();
  final BehaviorSubject<String> _mobileController = BehaviorSubject<String>();
  final BehaviorSubject<String> _paysController = BehaviorSubject<String>();
  final BehaviorSubject<String> _nomController = BehaviorSubject<String>();
  final BehaviorSubject<String> _prenomController = BehaviorSubject<String>();
  final BehaviorSubject<String> _questionController = BehaviorSubject<String>();
  final BehaviorSubject<String> _reponseController = BehaviorSubject<String>();

  Function(String) get onSecretChanged => _secretController.sink.add;
  Function(String) get onMontantChanged => _montantController.sink.add;
  Function(String) get onMobileChanged => _mobileController.sink.add;
  Function(String) get onPaysChanged => _paysController.sink.add;
  Function(String) get onNomChanged => _nomController.sink.add;
  Function(String) get onPrenomChanged => _prenomController.sink.add;
  Function(String) get onQuestionChanged => _questionController.sink.add;
  Function(String) get onReponseChanged => _reponseController.sink.add;

  Stream<String> get secret => _secretController.stream.transform(validatepassword);
  Stream<String> get montant => _montantController.stream.transform(inputValidation);
  Stream<String> get mobile => _mobileController.stream.transform(validateMobileMM);
  Stream<String> get pays => _paysController.stream.transform(inputValidation);
  Stream<String> get nom => _nomController.stream.transform(inputValidation);
  Stream<String> get prenom => _prenomController.stream.transform(inputValidation);
  Stream<String> get question => _questionController.stream.transform(inputValidation);
  Stream<String> get reponse => _reponseController.stream.transform(inputValidation);

  Stream<bool> get submitValidation => Observable.combineLatest7(
      secret,
      montant,
      mobile,
      nom,
      prenom,
      question,
      reponse,
          (s, mn, mb, n, p, q, r) => true
  );

  @override
  void dispose() {
    _secretController?.close();
    _montantController?.close();
    _mobileController?.close();
    _questionController?.close();
    _reponseController?.close();
    _nomController?.close();
    _prenomController?.close();
    _paysController?.close();
    // TODO: implement dispose
  }


}