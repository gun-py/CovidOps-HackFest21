import 'package:flutter/material.dart';

class RowWidget extends StatelessWidget {
  final IconData icon;
  final String str;

  RowWidget(this.icon, this.str);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          Expanded(child: Text(str))
        ],
      ),
    );
  }
}
