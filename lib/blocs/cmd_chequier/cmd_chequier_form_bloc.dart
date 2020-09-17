
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/validator/chequier_validator.dart';
import 'package:rxdart/rxdart.dart';

class CmdChequierFormBloc extends Object with ChequierValidator implements BlocBase {

  final BehaviorSubject<String> _typeChequerController = BehaviorSubject<String>();
  final BehaviorSubject<String> _volumeChequeController = BehaviorSubject<String>();
  final BehaviorSubject<String> _compteController = BehaviorSubject<String>();

  Function(String) get onTypeCheque => _typeChequerController.sink.add;
  Function(String) get onVolumeCheque => _volumeChequeController.sink.add;
  Function(String) get onCompteCheque => _compteController.sink.add;

  Stream<String> get volume => _volumeChequeController.stream.transform(validateVolumeCheque);
  Stream<String> get type => _typeChequerController.stream.transform(validateTypeCheque);
  Stream<String> get compte => _compteController.stream.transform(validateCompteCheque);

  Stream<bool> get submitValidation => Observable.combineLatest2(
      type,
      volume,
          (t, v) => true
  );

  @override
  void dispose() {
    _volumeChequeController?.close();
    _typeChequerController?.close();
    _compteController?.close();
    // TODO: implement dispose
  }


}