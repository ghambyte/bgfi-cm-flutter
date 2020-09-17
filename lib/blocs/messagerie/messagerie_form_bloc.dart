
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/validator/message_validator.dart';
import 'package:rxdart/rxdart.dart';

class MessagerieFormBloc extends Object with MessageValidator implements BlocBase {

  final BehaviorSubject<String> _objetController = BehaviorSubject<String>();
  final BehaviorSubject<String> _messageController = BehaviorSubject<String>();

  Function(String) get onObjetChanged => _objetController.sink.add;
  Function(String) get onMessageChanged => _messageController.sink.add;

  Stream<String> get objet => _objetController.stream.transform(validateObjet);
  Stream<String> get message => _messageController.stream.transform(validateMessage);

  Stream<bool> get submitValidation => Observable.combineLatest2(
      objet,
      message,
          (s, c) => true
  );

  @override
  void dispose() {
    _objetController?.close();
    _messageController?.close();
    // TODO: implement dispose
  }


}