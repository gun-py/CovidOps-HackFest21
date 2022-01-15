import 'package:covigenix/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class EssentialCard extends StatelessWidget {
  final EssentialGridModel model;
  final Function onTap;
  EssentialCard({required this.model, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.black26,

        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.asset(model.path, fit:BoxFit.cover),
        )
      ),
      onTap: () => onTap(context, model),
    );
  }
}
