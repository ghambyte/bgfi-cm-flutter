
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/validator/Login_validator.dart';
import 'package:gui/validator/input_length_validator.dart';
import 'package:rxdart/rxdart.dart';

class DmdRvFormBloc extends Object with InputLengthValidator implements BlocBase {

  final BehaviorSubject<String> _secretController = BehaviorSubject<String>();
  final BehaviorSubject<String> _objetController = BehaviorSubject<String>();
  final BehaviorSubject<String> _dateController = BehaviorSubject<String>();
  final BehaviorSubject<String> _compteController = BehaviorSubject<String>();

  Function(String) get onSecretChanged => _secretController.sink.add;
  Function(String) get onObjetChanged => _objetController.sink.add;
  Function(String) get onDateChanged => _dateController.sink.add;
  Function(String) get onCompteChanged => _compteController.sink.add;

  Stream<String> get secret => _secretController.stream.transform(inputValidation);
  Stream<String> get objet => _objetController.stream.transform(inputValidation);
  Stream<String> get date => _dateController.stream.transform(inputValidation);
  Stream<String> get compte => _compteController.stream.transform(inputValidation);

  Stream<bool> get submitValidation => Observable.combineLatest4(
      secret,
      objet,
      date,
      compte,
          (s, o, d, c) => true
  );

  @override
  void dispose() {
    _secretController?.close();
    _objetController?.close();
    _dateController?.close();
    _compteController?.close();
    // TODO: implement dispose
  }


}