import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttervoicegame/page/calender_page.dart';
import 'package:fluttervoicegame/page/profile_page.dart';
import 'package:fluttervoicegame/page/ranking_page.dart';
import 'package:fluttervoicegame/widget/tabbar.dart';

import '../page/home_page.dart';

class BottomNavgationBarPage extends StatefulWidget {
  @override
  _BottomNavgationBarPageState createState() => _BottomNavgationBarPageState();

}

var myselfUser;

class _BottomNavgationBarPageState extends State<BottomNavgationBarPage>
{
  int _selectedIndex = 0;

  final _pageWidgets = [
    // MyHomePage(title: "レベル選択"),
    TabBarPage(),
    CalendarPage(),
    RankingPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    TabBarPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pageWidgets.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.white,),
              label: 'ゲーム'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_rounded, color: Colors.white),
              label: 'カレンダ-'),
          BottomNavigationBarItem(
              icon: Icon(Icons.connect_without_contact, color: Colors.white),
              label: 'ランキング'),
          BottomNavigationBarItem(
              icon: Icon(Icons.privacy_tip, color: Colors.white),
              label: 'プロフィール'),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.white,
        backgroundColor: Colors.green,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}