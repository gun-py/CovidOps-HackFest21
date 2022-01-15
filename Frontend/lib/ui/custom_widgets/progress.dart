import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';



class CustomProgressIndicator extends StatelessWidget {
  late ProgressDialog pr;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        backgroundColor: Colors.blue,
      ),
    );
    /*pr = new ProgressDialog(context);
    pr.style(
        message: 'Please Waiting...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(backgroundColor: Colors.blue),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    return Center(
      child:pr
    );*/
  }
}



