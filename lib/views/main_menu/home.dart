import 'package:attendance_mgi_mobile/helpers/style.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  // Home(this.title);
  // final String title;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String textWelcome = '';

  getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //String token = prefs.getString('token');
    String name = prefs.getString('name').toString();
    setState(() {
      textWelcome = 'Welcome, ' + name;
    });
  }

  @override
  void initState() {
    super.initState();
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Text(
              textWelcome,
              style: TextStyle(
                color: RenStyle.renColorBase,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
