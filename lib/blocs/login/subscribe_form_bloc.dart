
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/validator/subscribe_validator.dart';
import 'package:rxdart/rxdart.dart';

class SubscribeFormBloc extends Object with SubscribeValidator implements BlocBase {

  final BehaviorSubject<String> _datenaissanceController = BehaviorSubject<String>();
  final BehaviorSubject<String> _mobileController = BehaviorSubject<String>();
  final BehaviorSubject<String> _prenomController = BehaviorSubject<String>();
  final BehaviorSubject<String> _nomController = BehaviorSubject<String>();
  final BehaviorSubject<String> _reponseController = BehaviorSubject<String>();
  final BehaviorSubject<String> _questionController = BehaviorSubject<String>();
  final BehaviorSubject<String> _numeropieceController = BehaviorSubject<String>();
  final BehaviorSubject<String> _paysController = BehaviorSubject<String>();
  final BehaviorSubject<String> _lieuController = BehaviorSubject<String>();
  final BehaviorSubject<String> _sexeController = BehaviorSubject<String>();

  Function(String) get onDateNaissanceChanged => _datenaissanceController.sink.add;
  Function(String) get onMobileChanged => _mobileController.sink.add;
  Function(String) get onPrenomChanged => _prenomController.sink.add;
  Function(String) get onNomChanged => _nomController.sink.add;
  Function(String) get onReponseChanged => _reponseController.sink.add;
  Function(String) get onQuestionChanged => _questionController.sink.add;
  Function(String) get onNumeropieceChanged => _numeropieceController.sink.add;

  Stream<String> get date => _datenaissanceController.stream.transform(inputValidation);
  Stream<String> get mobile => _mobileController.stream.transform(inputValidation);
  Stream<String> get prenom => _prenomController.stream.transform(inputValidation);
  Stream<String> get nom => _nomController.stream.transform(inputValidation);
  Stream<String> get reponse => _reponseController.stream.transform(inputValidation);
  Stream<String> get question => _questionController.stream.transform(inputValidation);
  Stream<String> get numeropiece => _numeropieceController.stream.transform(inputValidation);
  Stream<String> get pays => _paysController.stream.transform(inputValidation);
  Stream<String> get lieu => _lieuController.stream.transform(inputValidation);
  Stream<String> get sexe => _sexeController.stream.transform(inputValidation);

  Stream<bool> get submitValidation => Observable.combineLatest9(
      date,
      mobile,
      prenom,
      reponse,
      question,
      numeropiece,
      pays,
      lieu,
      sexe,
          (d, m, p, r, q, n, y, l, s) => true
  );

  @override
  void dispose() {
    _datenaissanceController?.close();
    _mobileController?.close();
    _prenomController?.close();
    _reponseController?.close();
    _questionController?.close();
    _numeropieceController?.close();
    _paysController?.close();
    _lieuController?.close();
    _sexeController?.close();
    // TODO: implement dispose
  }


}