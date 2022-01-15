import 'package:flutter/material.dart';
class CustomButton extends StatelessWidget {

  final String text;
  final void Function() onPressed;
  final MaterialColor color;

  CustomButton(this.text, this.onPressed, {this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color
      ),
      child: Center(
          child:TextButton(
            onPressed: onPressed,
            child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          )
      ),
    );
  }
}
