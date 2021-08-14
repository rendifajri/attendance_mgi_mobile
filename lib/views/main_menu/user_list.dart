import 'dart:convert';

import 'package:attendance_mgi_mobile/helpers/config.dart';
import 'package:attendance_mgi_mobile/helpers/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
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

    return ListView(children: <Widget>[
      DataTable(
        sortColumnIndex: 2,
        sortAscending: true,
        columnSpacing: 0,
        dataRowHeight: 30,
        headingRowHeight: 30,
        columns: const <DataColumn>[
          DataColumn(
            label: Text('Name'),
          ),
          DataColumn(
            label: Text('Age'),
          ),
          DataColumn(
            label: Text('Job'),
          ),
        ],
        rows: const <DataRow>[
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Mohit')),
              DataCell(Text('23')),
              DataCell(Text('Professional')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Aditya')),
              DataCell(Text('24')),
              DataCell(Text('Associate Professor')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Mohit')),
              DataCell(Text('23')),
              DataCell(Text('Professional')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Aditya')),
              DataCell(Text('24')),
              DataCell(Text('Associate Professor')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Mohit')),
              DataCell(Text('23')),
              DataCell(Text('Professional')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Aditya')),
              DataCell(Text('24')),
              DataCell(Text('Associate Professor')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Mohit')),
              DataCell(Text('23')),
              DataCell(Text('Professional')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Aditya')),
              DataCell(Text('24')),
              DataCell(Text('Associate Professor')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Mohit')),
              DataCell(Text('23')),
              DataCell(Text('Professional')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Aditya')),
              DataCell(Text('24')),
              DataCell(Text('Associate Professor')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Mohit')),
              DataCell(Text('23')),
              DataCell(Text('Professional')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Aditya')),
              DataCell(Text('24')),
              DataCell(Text('Associate Professor')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Mohit')),
              DataCell(Text('23')),
              DataCell(Text('Professional')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Aditya')),
              DataCell(Text('24')),
              DataCell(Text('Associate Professor')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Mohit')),
              DataCell(Text('23')),
              DataCell(Text('Professional')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Aditya')),
              DataCell(Text('24')),
              DataCell(Text('Associate Professor')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Mohit')),
              DataCell(Text('23')),
              DataCell(Text('Professional')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Aditya')),
              DataCell(Text('24')),
              DataCell(Text('Associate Professor')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Mohit')),
              DataCell(Text('23')),
              DataCell(Text('Professional')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Aditya')),
              DataCell(Text('24')),
              DataCell(Text('Associate Professor')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Mohit')),
              DataCell(Text('23')),
              DataCell(Text('Professional')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Aditya')),
              DataCell(Text('24')),
              DataCell(Text('Associate Professor')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Mohit')),
              DataCell(Text('23')),
              DataCell(Text('Professional')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Aditya')),
              DataCell(Text('24')),
              DataCell(Text('Associate Professor')),
            ],
          ),
        ],
      ),
    ]);
  }
}
