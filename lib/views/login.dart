import 'dart:convert';
import 'package:attendance_mgi_mobile/helpers/config.dart';
import 'package:attendance_mgi_mobile/helpers/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_menu.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String textError = '';

  getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('id')) {
      String id = prefs.getString('id').toString();
      print('id = ' + id);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainMenu()),
      );
    }
  }

  loginAction() async {
    textError = '';
    Response response = await post(
      Uri.parse(RenConfig.renApiUrl + "/api/login"),
      headers: <String, String>{"Content-Type": "application/json"},
      body: json.encode(<String, String>{
        'username': usernameController.text,
        'password': passwordController.text,
      }),
    );
    var body = json.decode(response.body);
    print(jsonDecode(response.body));
    if (body['status'] == "success") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("username", body['response']['username']);
      prefs.setString("name", body['response']['name']);
      prefs.setString("role", body['response']['role']);
      prefs.setString("api_token", body['response']['api_token']);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainMenu()),
      );
    } else {
      setState(() {
        textError = body['message'];
      });
    }
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
                backgroundColor: RenStyle.renColorGreen,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(RenConfig.renTitle),
                  titlePadding: EdgeInsetsDirectional.only(
                    start: 20.0,
                    bottom: 17.0,
                  ),
                ),
              ),
            ];
          },
          body: Padding(
              padding: EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: RenStyle.renColorGreen,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(0),
                      child: Text(
                        textError,
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      )),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User Name',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  Container(
                    height: 70,
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: MaterialButton(
                      textColor: Colors.white,
                      color: RenStyle.renColorGreen,
                      child: Text('Login'),
                      onPressed: () {
                        loginAction();
                      },
                    ),
                  ),
                ],
              ))),
    );
  }
}
