import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
class CustomDialog extends StatelessWidget {
  String title, body, yesTitle, noTitle;
  Function yesFunction;

  CustomDialog({
    required this.title,
    required this.body,
    required this.yesTitle,
    this.noTitle = "Cancel",
    required this.yesFunction,
  });

  @override
  Widget build(BuildContext context) {
    return AssetGiffyDialog(
      image: Image.asset('assets/images/giff.gif',  fit: BoxFit.fill),
      title: Text(title,
        style: TextStyle(
            fontSize: 22.0, fontWeight: FontWeight.w600),
      ),
      description: Text(body,
        textAlign: TextAlign.center,
        style: TextStyle(),
      ),
      entryAnimation: EntryAnimation.DEFAULT,
      buttonOkColor: Colors.blue,
      onOkButtonPressed: () {

        Navigator.of(context).pop();
        yesFunction();
      },
      onCancelButtonPressed: (){
        Navigator.of(context).pop();
      },
    );
  }
}
