import 'package:covigenix/helper.dart';
import 'package:covigenix/ui/community/community_add.dart';
import 'package:covigenix/ui/community/community_page.dart' as CommunityPage;
import 'package:flutter/material.dart';

class Community extends StatefulWidget{

  @override
  _CommunityState createState() => _CommunityState();
}
class _CommunityState extends State<StatefulWidget> {
  final List<Tab> _tabs = <Tab>[
    Tab(text: "Requests"),
    Tab(text: "Availability"),
  ];

  void openAddCommunity(BuildContext context, int index){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCommunity(index)),
    );
  }

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
              CommunityPage.Page(Helper.TYPE_REQUEST),
              CommunityPage.Page(Helper.TYPE_AVAILABILITY),
            ],
          ),
          floatingActionButton: FAB(openAddCommunity),
        )
    );
  }
}

class FAB extends StatelessWidget {

  final Function openAddCommunity;

  FAB(this.openAddCommunity);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => openAddCommunity(context, DefaultTabController.of(context)!.index),
      child: const Icon(Icons.add),
    );
  }
}

