import 'package:covigenix/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EssentialChecklist extends StatefulWidget{
  final Map<String, bool> status = Map<String, bool>();
  EssentialChecklist();

  @override
  _EssentialChecklistState createState() => _EssentialChecklistState();

}
class _EssentialChecklistState extends State<EssentialChecklist> {

  late List<EssentialGridModel> list;

  _EssentialChecklistState();

  @override
  void initState() {
    super.initState();
    list = Helper.getEssentialsListForMap();
    for(EssentialGridModel e in list){
      widget.status[e.arg] = e.checked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index){
        return CheckboxListTile(
          value: widget.status[list[index].arg]!,
          title: Text(list[index].proper),
          onChanged: (bool? val) => setState(() {
            widget.status[list[index].arg] = val!;
          }),
        );
      }
    );
  }
}
