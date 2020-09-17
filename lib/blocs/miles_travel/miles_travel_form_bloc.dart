
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/validator/input_length_validator.dart';
import 'package:gui/validator/password_validator.dart';
import 'package:rxdart/rxdart.dart';

class MilesTravelFormBloc extends Object with PasswordValidator, InputLengthValidator implements BlocBase {

  final BehaviorSubject<String> _secretController = BehaviorSubject<String>();
  final BehaviorSubject<String> _montantController = BehaviorSubject<String>();

  Function(String) get onSecretChanged => _secretController.sink.add;
  Function(String) get onMontantChanged => _montantController.sink.add;

  Stream<String> get secret => _secretController.stream.transform(secretValidation);
  Stream<String> get montant => _montantController.stream.transform(inputValidation);

  Stream<bool> get submitValidation => Observable.combineLatest2(
      secret,
      montant,
          (s, c) => true
  );

  @override
  void dispose() {
    _secretController?.close();
    _montantController?.close();
    // TODO: implement dispose
  }


}