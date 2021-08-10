import 'package:attendance_mgi_mobile/helpers/config.dart';
import 'package:attendance_mgi_mobile/helpers/style.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    Home("Surat"),
    Home("Rumah"),
    Home("Pengguna"),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: false,
              snap: false,
              floating: false,
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: RenStyle.renColorGreen,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(RenConfig.renTitle),
                titlePadding: EdgeInsetsDirectional.only(
                  //start: 50.0,
                  start: 20.0,
                  bottom: 17.0,
                ),
              ),
            ),
          ];
        },
        body: _children[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: new Icon(Icons.mail), label: 'Mail'),
          BottomNavigationBarItem(icon: new Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: new Icon(Icons.person), label: 'User')
        ],
      ),
    );
  }
}
