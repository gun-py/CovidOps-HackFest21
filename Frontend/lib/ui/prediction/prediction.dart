import 'package:covigenix/ui/prediction/image.dart' as ImagePage;
import 'package:covigenix/ui/prediction/audio.dart' as AudioPage;
import 'package:flutter/material.dart';

class Prediction extends StatefulWidget {
  @override
  _PredictionState createState() => _PredictionState();
}

class _PredictionState extends State<Prediction> {
  final List<Tab> _tabs = <Tab>[
    Tab(text: "X-Ray Image"),
    Tab(text: "Cough Audio"),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColor,
            tabs: _tabs,
          ),
          body: TabBarView(
            children: [
              ImagePage.ImagePage(),
              AudioPage.Audio(),
            ],
          ),
        )
    );
  }
}
