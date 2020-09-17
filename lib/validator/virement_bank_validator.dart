import 'dart:async';

class VirementBankValidator {

  final validateSecret = StreamTransformer<String, String>.fromHandlers(
    handleData: (secret, sink) {
      if (secret.length>1) {
        sink.add(secret);
      } else {
        print('SECRET INVALIDE');
        sink.addError('SECRET INVALIDE');
      }
    }
  );

  final validateNumCompteBeneficiaire = StreamTransformer<String, String>.fromHandlers(
    handleData: (numCompteBenef, sink) {
      if (numCompteBenef.length>1) {
        sink.add(numCompteBenef);
      } else {
        print('NUM COMPTE BENEF INVALIDE');
        sink.addError('NUM COMPTE BENEF INVALIDE');
      }
    }
  );

  final validateNomBanque = StreamTransformer<String, String>.fromHandlers(
    handleData: (nomBanque, sink) {
      if (nomBanque.length>1) {
        sink.add(nomBanque);
      } else {
        print('NOM BANQUE INVALIDE');
        sink.addError('NOM BANQUE INVALIDE');
      }
    }
  );

  final validateNomBenef = StreamTransformer<String, String>.fromHandlers(
    handleData: (nomBenef, sink) {
      if (nomBenef.length>1) {
        sink.add(nomBenef);
      } else {
        print('NOM BENEFIFICAIRE INVALIDE');
        sink.addError('NOM BENEFIFICAIRE INVALIDE');
      }
    }
  );

  final validateCodeBanque = StreamTransformer<String, String>.fromHandlers(
    handleData: (codeBanque, sink) {
      if (codeBanque.length>1) {
        sink.add(codeBanque);
      } else {
        print('CODE BANQUE INVALIDE');
        sink.addError('CODE BANQUE INVALIDE');
      }
    }
  );

  final validateCodeGuicher = StreamTransformer<String, String>.fromHandlers(
    handleData: (codeGuichet, sink) {
      if (codeGuichet.length>1) {
        sink.add(codeGuichet);
      } else {
        print('CODE GUICHET INVALIDE');
        sink.addError('CODE GUICHET INVALIDE');
      }
    }
  );

  final validateLibelle = StreamTransformer<String, String>.fromHandlers(
    handleData: (libelle, sink) {
      if (libelle.length>1) {
        sink.add(libelle);
      } else {
        print('LIBELLE INVALIDE');
        sink.addError('LIBELLE INVALIDE');
      }
    }
  );

  final validateCompte = StreamTransformer<String, String>.fromHandlers(
    handleData: (compte, sink) {
      if (compte.length>1) {
        sink.add(compte);
      } else {
        print('COMPTE INVALIDE');
        sink.addError('COMPTE INVALIDE');
      }
    }
  );

  final validateMontant = StreamTransformer<String, String>.fromHandlers(
    handleData: (montant, sink) {
      if (montant.length>1) {
        sink.add(montant);
      } else {
        print('MONTANT INVALIDE');
        sink.addError('MONTANT INVALIDE');
      }
    }
  );

  final StreamTransformer<String,String> validateType = StreamTransformer<String,String>.fromHandlers(handleData: (value, sink) {

    sink.add("0");

  });


}