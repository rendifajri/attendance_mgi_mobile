import 'dart:convert';

import 'package:attendance_mgi_mobile/helpers/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  int page = 1;
  int maxPage = 1;
  dynamic apiResult = [];
  List<DataRow> dr = [];

  getData(int page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Response response = await get(
      Uri.parse(RenConfig.renApiUrl +
          "/api/employee?page=" +
          page.toString() +
          "&limit=10"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + prefs.getString('api_token').toString()
      },
    );
    var body = await json.decode(response.body);
    //print(jsonDecode(response.body));
    dr = <DataRow>[];
    if (body['status'] == "success") {
      apiResult = body['response'];
      maxPage = int.parse(body['response_total_page'].toString());
      setState(() {
        for (var res in apiResult) {
          dr.add(DataRow(
            cells: <DataCell>[
              DataCell(Text(res['nik'])),
              DataCell(Text(res['name'])),
              DataCell(Text(res['department'])),
              DataCell(Text(res['shift'].toString())),
            ],
          ));
        }
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getData(page);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        DataTable(
          //sortColumnIndex: 2,
          //sortAscending: true,
          columnSpacing: 0,
          dataRowHeight: 30,
          headingRowHeight: 30,
          columns: const <DataColumn>[
            DataColumn(label: Text('NIK')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Department')),
            DataColumn(label: Text('Shift')),
          ],
          rows: this.dr,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  page--;
                  if (page < 1) page = 1;
                  getData(page);
                },
                child: Text("Prev"),
              ),
              Text(page.toString() + "/" + maxPage.toString()),
              TextButton(
                onPressed: () {
                  page++;
                  if (page > maxPage) page = maxPage;
                  getData(page);
                },
                child: Text("Next"),
              ),
            ],
          ),
        )
      ],
    );
  }
}
