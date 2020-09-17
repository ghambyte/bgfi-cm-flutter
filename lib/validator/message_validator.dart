import 'dart:async';

class MessageValidator {

  final validateObjet = StreamTransformer<String, String>.fromHandlers(
    handleData: (objet, sink) {
      if (objet.length>1) {
        sink.add(objet);
      } else {
        print('OBJET INVALIDE');
        sink.addError('OBJET INVALIDE');
      }
    }
  );

  final validateMessage = StreamTransformer<String, String>.fromHandlers(
    handleData: (message, sink) {
      if (message.length>1) {
        sink.add(message);
      } else {
        print('MESSAGE INVALIDE');
        sink.addError('MESSAGE INVALIDE');
      }
    }
  );
}