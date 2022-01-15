import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
class PredictionContent extends StatelessWidget {
  double pred;

  PredictionContent(this.pred);

  @override
  Widget build(BuildContext context) {
    Widget contentWidget = Text('');
    if (pred < 10.00) {
      contentWidget = RichText(
        text: TextSpan(children: [
          TextSpan(
            text: 'You are ',
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          TextSpan(
            text: 'safe',
            style: TextStyle(color: Colors.green, fontSize: 14),
          ),
          TextSpan(
            text: '. Please take precautions.',
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ]),
      );
    } else if (pred > 85.00) {
      contentWidget = RichText(
        text: TextSpan(children: [
          TextSpan(
            text: 'You are at a ',
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          TextSpan(
            text: 'high risk',
            style: TextStyle(color: Colors.red, fontSize: 14),
          ),
          TextSpan(
            text: '. Please consult a medical professional.',
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ]),
      );
    } else {
      contentWidget = Text('You have ${pred.toStringAsFixed(2)}% chances of being infected with COVID-19.');
    }
    return AlertDialog(
      title: Text("Results"),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            contentWidget,
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}


