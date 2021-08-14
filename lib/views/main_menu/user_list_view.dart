import 'dart:convert';

import 'package:attendance_mgi_mobile/helpers/config.dart';
import 'package:attendance_mgi_mobile/helpers/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';

class UserListView extends StatefulWidget {
  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  int value = 0;
  dynamic apiResult = [];

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Response response = await get(
      Uri.parse(RenConfig.renApiUrl + "/api/employee"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + prefs.getString('api_token').toString()
      },
    );
    var body = json.decode(response.body);
    //print(jsonDecode(response.body));
    if (body['status'] == "success") {
      apiResult = body['response'];
      //print(apiResult);
      setState(() {
        value = body['response'].length;
        print(value);
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    print(apiResult);

    return ListView.separated(
      padding: EdgeInsets.all(10),
      itemCount: this.value,
      itemBuilder: (context, index) => this._buildRow(index),
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  _buildRow(int index) {
    print(apiResult);

    return InkWell(
      onTap: () {
        print('clicked' + index.toString());
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => DataDetail(apiResult[index])));
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: RenStyle.renColorBase)),
        child: Center(
          child: Text(
            apiResult[index]['department_id'].toString() +
                ' - ' +
                apiResult[index]['name'],
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: RenStyle.renColorBase,
            ),
          ),
        ),
      ),
    );
  }
}
