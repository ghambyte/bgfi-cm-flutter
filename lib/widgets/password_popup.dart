
import 'package:flutter/material.dart';

abstract class PasswodPopup {

  passwordSubmit(String secret, String reference);

  void dialogShow(BuildContext context, String reference, String title, String buttonTitle) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String codesecret;
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: Form (
              key: formKey,
              child:new TextFormField(

                decoration: new InputDecoration(labelText: "CODE SECRET",
                    labelStyle: new TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    )),
                keyboardType: TextInputType.number,
                validator: (val) => val.length!=4 ? 'CODE SECRET INVALIDE' : null,
                onSaved: (val) => codesecret = val,
                obscureText: true,
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            new FlatButton(
                child: new Text("FERMER", style: new TextStyle(color: Colors.black)),
                onPressed: (){
                  Navigator.of(context).pop();
                }
            ),
            new FlatButton(
                child: new Text(buttonTitle),
                onPressed: (){
                  print("ACTION SUBMIT");
                  final form = formKey.currentState;
                  if (form.validate()) {
                    form.save();
                    // Navigator.of(context).pop();
                    passwordSubmit(codesecret, reference);
                  }
                }
            ),

          ],
        );
      },
    );
  }
}