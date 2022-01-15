import 'package:covigenix/helper.dart';
import 'package:covigenix/ui/custom_widgets/essential_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EssentialGrid extends StatelessWidget {
  final List<EssentialGridModel> list = Helper.essentialsList;

  final Function onTap;
  EssentialGrid(this.onTap);
  
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 4.0,
      //mainAxisSpacing: 8.0,
      children: List.generate(
        list.length,
            (index) => EssentialCard(
              model: list[index],
              onTap: onTap,
            ),
      ),
    );
  }
}
