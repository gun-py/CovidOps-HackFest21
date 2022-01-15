import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:covigenix/ui/Agreement_policy/disclaimer.dart';
import 'package:covigenix/ui/Agreement_policy/privacy_policy%20.dart';
import 'package:covigenix/ui/Agreement_policy/t%20_and_c.dart';

class HyperText extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: 'By clicking, I agree to the ',
          style: TextStyle(color: Colors.black),
        ),
        TextSpan(
          text: 'Terms and Conditions',
          style: TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              await showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Terms and Conditions"),
                    content: t_and_c(),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
        ),
        TextSpan(
          text: ', ',
          style: TextStyle(color: Colors.black),
        ),
        TextSpan(
          text: 'Privacy Policy',
          style: TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              await showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Privacy Policy"),
                    content: privacy_policy(),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
        ),
        TextSpan(
          text: ' and ',
          style: TextStyle(color: Colors.black),
        ),
        TextSpan(
          text: 'Disclaimer',
          style: TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              await showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Disclaimer"),
                    content: disclaimer(),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
        ),
        TextSpan(
          text: '.',
          style: TextStyle(color: Colors.black),
        ),
      ]),
    );
  }
}
