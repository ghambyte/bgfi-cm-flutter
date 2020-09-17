
import 'dart:async';

class PasswordValidator {

  final StreamTransformer<String,String> secretValidation = StreamTransformer<String,String>.fromHandlers(handleData: (value, sink) {

    if (value.length == 4) {
      sink.add(value);
    } else {
      sink.addError('Code secret invalide.');
    }

  });

}