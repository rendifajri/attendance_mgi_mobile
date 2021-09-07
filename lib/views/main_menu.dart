import 'package:attendance_mgi_mobile/helpers/config.dart';
import 'package:attendance_mgi_mobile/helpers/style.dart';
import 'package:attendance_mgi_mobile/views/main_menu/user_list.dart';
import 'package:attendance_mgi_mobile/views/user_add.dart';
import 'package:attendance_mgi_mobile/views/user_import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'main_menu/home.dart';
import 'login.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _currentIndex = 0;
  bool _floatBtn = false;
  final List<Widget> _children = [
    Home("Rumah"),
    UserList(),
    Home("Kehadiran"),
    //Home("Seting"),
    Home("Profil"),
  ];

  void onTabTapped(int index) {
    if (index == 1)
      _floatBtn = true;
    else
      _floatBtn = false;

    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _onBackPressed() {
    Widget cancelButton = TextButton(
      child: Text("Yes"),
      style: TextButton.styleFrom(backgroundColor: Colors.white),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      },
    );
    Widget continueButton = TextButton(
      child: Text("No"),
      style: TextButton.styleFrom(backgroundColor: Colors.white),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(
        "Log out",
        style: TextStyle(color: Colors.white),
      ),
      content: Text(
        "You're logging out, are you sure?",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: RenStyle.renColorBase,
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    return Future<bool>.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  pinned: false,
                  snap: false,
                  floating: false,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  backgroundColor: RenStyle.renColorBase,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(RenConfig.renTitle),
                    titlePadding:
                        EdgeInsetsDirectional.only(start: 20.0, bottom: 17.0),
                  ),
                ),
              ];
            },
            body: _children[_currentIndex],
          ),
          floatingActionButton: SpeedDial(
            backgroundColor: RenStyle.renColorBase,
            animatedIcon: AnimatedIcons.menu_close,
            visible: _floatBtn,
            children: [
              SpeedDialChild(
                child: Icon(Icons.add),
                label: 'Add',
                backgroundColor: RenStyle.renColorBaseLight,
                foregroundColor: Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserAdd()),
                  );
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.note_add),
                label: 'Import',
                backgroundColor: RenStyle.renColorBaseLight,
                foregroundColor: Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserImport()),
                  );
                },
              )
            ],
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {},
          //   tooltip: 'Increment',
          //   child: Icon(Icons.add),
          // ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: RenStyle.renColorBase,
            selectedItemColor: Colors.white,
            unselectedItemColor: RenStyle.renColorGrey,
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.supervisor_account),
                label: 'Employee',
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.access_time),
                label: 'Attendance',
              ),
              // BottomNavigationBarItem(
              //   icon: new Icon(Icons.settings),
              //   label: 'Config',
              // ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ));
  }
}
