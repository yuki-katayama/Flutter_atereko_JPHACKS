import 'package:flutter/material.dart';
import 'package:fluttervoicegame/ui/difficult_home_panel.dart';
import 'package:fluttervoicegame/ui/home_panel.dart';
import 'package:fluttervoicegame/ui/normal_home_panel.dart';

class TabBarPage extends StatefulWidget {
  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  TabController _tabController;
  @override
  Widget build(BuildContext context) {
   return DefaultTabController(
      length: 3,
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            leading: Container(),
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(
                  isScrollable: true,
                  unselectedLabelColor: Colors.black.withOpacity(0.5),
                  unselectedLabelStyle: TextStyle(fontSize: 13.0),
                  labelColor: Colors.white,
                  labelStyle: TextStyle(fontSize: 16.0),
                  indicatorColor: Colors.white,
                  indicatorWeight: 2.0,
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Easy'),
                    Tab(text: 'Normal'),
                    Tab(text: 'Difficult'),
                  ],
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              HomePanel(), NormalHomePanel(), DifficultHomePanel()
            ],
          ),
        ),
      ),
    );

  }
}
