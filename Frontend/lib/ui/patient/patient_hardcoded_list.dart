import 'package:covigenix/ui/custom_widgets/row_widget.dart';
import 'package:flutter/material.dart';

import '../../helper.dart';

class PatientHardcodedList extends StatefulWidget {

  @override
  _PatientHardcodedListState createState() => _PatientHardcodedListState();
}

class _PatientHardcodedListState extends State<PatientHardcodedList> {

  bool isLoading = true;
  late List<HospitalListModel> master;
  List<HospitalListModel> filtered = List.empty(growable: true);
  final List<String> states = Helper.getStates();
  String? dropdownValue = null;

  //API Calls
  @override
  void initState(){
    super.initState();
    loadList();
  }

  List<HospitalListModel> filterData(String state){
    return master.where((item) => item.State == state).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //title: Center(child: Text('Hospitals', style: TextStyle(fontSize: 24),)),
          title: Text('Hospitals'),
        ),
        body: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text("Select state"),
                    value: dropdownValue,
                    items: states.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
                    onChanged: (newVal) => setState((){
                      dropdownValue = newVal!;
                      filtered = filterData(newVal);
                    }),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RowWidget(Icons.account_circle, "Provider: ${filtered[index].Name}"),
                            RowWidget(Icons.business_outlined, "Area: ${filtered[index].Area}"),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            )
        ),
    );
  }

  void loadList() async{
    master = await Helper.getHospitalsFromJson();
    setState(() {
      isLoading = false;
    });
  }
}