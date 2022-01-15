import 'package:flutter/material.dart';
class PredictionProgressIndicator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            //strokeWidth: 8.0,
            //backgroundColor: Colors.blue,
          ),
        ),
        Text('Prediction in progress..'),
      ],
    );
  }
}
