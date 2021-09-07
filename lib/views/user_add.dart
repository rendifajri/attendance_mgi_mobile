import 'dart:convert';
import 'package:attendance_mgi_mobile/helpers/config.dart';
import 'package:attendance_mgi_mobile/helpers/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAdd extends StatefulWidget {
  @override
  _UserAddState createState() => _UserAddState();
}

class _UserAddState extends State<UserAdd> {
  TextEditingController nikController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController shiftController = TextEditingController();
  String textError = '';

  addAction() async {
    textError = '';
    try {
      setState(() {
        textError = '';
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Response response = await post(
        Uri.parse(RenConfig.renApiUrl + "/api/employee"),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': 'Bearer ' + prefs.getString('api_token').toString()
        },
        body: json.encode(<String, String>{
          'nik': nikController.text,
          'password': passwordController.text,
          'name': nameController.text,
          'department': departmentController.text,
          'shift': shiftController.text,
        }),
      ).timeout(Duration(seconds: 3));
      var body = json.decode(response.body);
      print(jsonDecode(response.body));
      if (body['status'] == "success") {
        Navigator.pop(context);
      } else {
        setState(() {
          body['message'].forEach((k, v) => {
                for (var res_loop in v) {textError += res_loop + '\n'}
              });
          textError = textError.substring(0, textError.length - 2);
        });
      }
    } catch (err) {
      print(err);
      setState(() {
        textError = "Tidak bisa mengakses server";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Add'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(0),
              child: Text(
                textError,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: nikController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'NIK',
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: departmentController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Department',
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: shiftController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Shift',
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                ),
              ),
            ),
            Container(
              height: 65,
              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: MaterialButton(
                textColor: Colors.white,
                color: RenStyle.renColorBase,
                child: Text(
                  'Add',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  addAction();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
