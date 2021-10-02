import 'dart:convert';

import 'package:attendance_mgi_mobile/helpers/config.dart';
import 'package:attendance_mgi_mobile/helpers/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:geocoding/geocoding.dart';

import '../login.dart';

class HomeUser extends StatefulWidget {
  @override
  _HomeUserState createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  String textError = '';
  String textWelcome = '';
  String textMessage = '';
  String textButton = '';
  Table? _table;
  bool _buttonVisible = false;

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //String token = prefs.getString('token');
    String name = prefs.getString('name').toString();
    setState(() {
      textWelcome = 'Welcome, ' + name;
    });

    final Response response = await get(
      Uri.parse(RenConfig.renApiUrl + "/api/attendance/user_info"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + prefs.getString('api_token').toString()
      },
    );
    var body = await json.decode(response.body);
    //print(jsonDecode(response.body));
    if (body['status'] == "success") {
      setState(() {
        textMessage = body['message'];
        if (body['response']['attendance'] != null) {
          String checkin = body['response']['attendance']['checkin'] != null
              ? body['response']['attendance']['checkin']
                  .toString()
                  .split(" ")[1]
              : "";
          String checkout = body['response']['attendance']['checkout'] != null
              ? body['response']['attendance']['checkout']
                  .toString()
                  .split(" ")[1]
              : "";
          _table = Table(
            border: TableBorder.all(color: RenStyle.renColorBase),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(
                children: <Widget>[
                  Container(
                    color: RenStyle.renColorBaseLight,
                    padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                    child: Center(
                      child: Text(
                        "Checkin",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: RenStyle.renColorBaseLight,
                    padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                    child: Center(
                      child: Text(
                        "Checkout",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: <Widget>[
                  Container(
                    color: RenStyle.renColorBaseLight,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      checkin,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  Container(
                    color: RenStyle.renColorBaseLight,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      checkout,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          _table = null;
        }
        textButton = body['response']['action'];
        _buttonVisible = textButton != "";
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  tapAction() async {
    setState(() {
      textError = '';
      textButton = "";
      _buttonVisible = textButton != "";
    });
    try {
      // List<Placemark> placemarks = await placemarkFromCoordinates(
      //     aa.latitude, aa.longitude,
      //     localeIdentifier: "en");
      // print(placemarks[0]);
      // print(placemarks[0].locality);
      // print(placemarks[0].postalCode);
      // print(placemarks[0].country);
      // print(placemarks[0].street);

      Position aa = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      print(aa.latitude);
      print(aa.longitude);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //String token = prefs.getString('token');
      final Response response = await post(
        Uri.parse(RenConfig.renApiUrl + "/api/attendance"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + prefs.getString('api_token').toString()
        },
        body: json.encode(<String, String>{
          'lat': aa.latitude.toString(),
          'lon': aa.longitude.toString(),
        }),
      );
      var body = await json.decode(response.body);
      print(jsonDecode(response.body));
      if (body['status'] == "success") {
        getData();
      } else {
        setState(() {
          body['message'].forEach(
            (k, v) => {
              for (var res_loop in v) {textError += res_loop + '\n'}
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
    WidgetsBinding.instance!.addPostFrameCallback((_) => getData());
    // Future.delayed(Duration.zero, () {
    //   getData();
    // });
  }
  // @override
  // // ignore: override_on_non_overriding_member
  // void afterFirstLayout(BuildContext context) {
  //   // Calling the same function "after layout" to resolve the issue.
  //   getData();
  // }

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
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
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
            padding: EdgeInsets.all(0),
            child: Text(
              textMessage,
              style: TextStyle(
                color: RenStyle.renColorBlack,
                fontSize: 18,
              ),
            ),
          ),
          Container(padding: EdgeInsets.fromLTRB(50, 10, 50, 0), child: _table),
          Visibility(
            child: Container(
              height: 65,
              padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: MaterialButton(
                textColor: Colors.white,
                color: RenStyle.renColorBase,
                child: Text(
                  textButton,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  tapAction();
                },
              ),
            ),
            visible: _buttonVisible,
          ),
        ],
      ),
    );
  }
}
