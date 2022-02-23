import 'dart:convert';
import 'package:attendance_mgi_mobile/helpers/config.dart';
import 'package:attendance_mgi_mobile/helpers/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserEdit extends StatefulWidget {
  UserEdit(this.data);
  final dynamic data;
  @override
  _UserEditState createState() => _UserEditState(data);
}

class _UserEditState extends State<UserEdit> {
  _UserEditState(this.data);
  final dynamic data;
  TextEditingController nikController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController shiftController = TextEditingController();
  TextEditingController deviceidController = TextEditingController();
  String textError = '';
  int id = 0;

  addAction() async {
    setState(() {
      textError = '';
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Response response = await put(
        Uri.parse(RenConfig.renApiUrl + "/api/employee/" + this.id.toString()),
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
          'device_id': deviceidController.text,
        }),
      ).timeout(Duration(seconds: 3));
      var body = json.decode(response.body);
      print(jsonDecode(response.body));
      if (body['status'] == "success") {
        Navigator.pop(context);
      } else {
        setState(() {
          body['message'].forEach(
            (k, v) => {
              for (var resLoop in v) {textError += resLoop + '\n'}
            },
          );
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
  void initState() {
    super.initState();
    print(this.data);
    this.id = data['id'];
    print(id);
    this.nikController.text = data['nik'];
    this.nameController.text = data['name'];
    this.departmentController.text = data['department'];
    this.shiftController.text = data['shift'].toString();
    this.deviceidController.text = data['user']['device_id'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Edit'),
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
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: deviceidController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Device ID',
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
                  'Edit',
                  style: TextStyle(fontSize: 18),
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
