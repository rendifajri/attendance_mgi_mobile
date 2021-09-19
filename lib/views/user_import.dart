import 'dart:convert';
import 'dart:io';
import 'package:attendance_mgi_mobile/helpers/config.dart';
import 'package:attendance_mgi_mobile/helpers/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class UserImport extends StatefulWidget {
  @override
  _UserImportState createState() => _UserImportState();
}

class _UserImportState extends State<UserImport> {
  TextEditingController nikController = TextEditingController();
  String textError = '';
  String textFile = '...';
  File? file;

  chooseAction() async {
    setState(() {
      textFile = '...';
    });
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        file = File(result.files.single.path);
        textFile = result.files.single.name;
      });
    } else {
      // User canceled the picker
    }
  }

  importAction() async {
    setState(() {
      textError = '';
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      MultipartRequest request = new MultipartRequest(
        "post",
        Uri.parse(RenConfig.renApiUrl + "/api/employee/import"),
      );
      request.headers["Authorization"] =
          'Bearer ' + prefs.getString('api_token').toString();
      var multipartFile = new MultipartFile(
        'file',
        file!.readAsBytes().asStream(),
        file!.lengthSync(),
        filename: textFile,
      );
      request.files.add(multipartFile);
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var body = json.decode(responseString);
      if (body['status'] == "success") {
        Navigator.pop(context);
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
      print('aa');
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
              height: 65,
              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: MaterialButton(
                textColor: Colors.white,
                color: RenStyle.renColorGrey,
                child: Text(
                  'Choose File',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  chooseAction();
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                textFile,
                style: TextStyle(
                  color: RenStyle.renColorBase,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
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
                  'Import',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  importAction();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
