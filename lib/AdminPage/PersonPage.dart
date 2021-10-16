import 'package:admin_project/model/Connectapi.dart';
import 'package:admin_project/model/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';

class PersonDetail extends StatefulWidget {
  const PersonDetail({Key key}) : super(key: key);

  @override
  _PersonDetailState createState() => _PersonDetailState();
}

class _PersonDetailState extends State<PersonDetail> {
  // final _formkey = GlobalKey<FormState>();

  // Personinfo psdata;

  var psId;
  var _psName;
  var _psLastname;
  var _psAddress;
  var _psEmail;
  var _psTel;

  Map<String, dynamic> _rec_person;
  var token;
  // var psId;
  // var ps_id;

  Future onGoBack(dynamic value) {
    setState(() {
      getInfo();
    });
  }

  Future getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // psId = prefs.getInt('psid');
    print('token = $token');
    print('psId = $psId');
  }

  Future<void> getInfo() async {
    // รับค่า
    _rec_person = ModalRoute.of(context).settings.arguments;

    psId = _rec_person['ps_id'];
    _psName = _rec_person['ps_name'];
    _psLastname = _rec_person['ps_lastname'];
    _psAddress = _rec_person['ps_address'];
    _psEmail = _rec_person['ps_email'];
    _psTel = _rec_person['ps_tel'];
  }

  //Delete
  Future<void> _deleteperson(Map<String, dynamic> values) async {
    var url = '${Connectapi().domain}/deleteperson/$psId';
    var response = await http.delete(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: convert.jsonEncode(values));
    print(values);
    if (response.statusCode == 200) {
      print('Delete Success');
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);
      _showSnack();
    } else {
      print('Delete Fail');
    }
  }

  @override
  Widget build(BuildContext context) {
    getInfo();
    getPrefs();
    return Scaffold(
      appBar: AppBar(
        title:
            Text('แสดงข้อมูลพนักงานส่ง', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_forever,
              color: Colors.black,
            ),
            onPressed: () {
              listDialog();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/updateperson', arguments: {
                '_psId': psId,
                '_psName': _psName,
                '_psLastname': _psLastname,
                '_psaddress': _psAddress,
                '_psEmail': _psEmail,
                '_psTel': _psTel,
              }).then((onGoBack));
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ProfileHeader(
                avatar: AssetImage('assets/images/person.png'),
                coverImage: AssetImage('assets/images/background.png'),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Card(
                  child: Column(
                    children: [
                      ...ListTile.divideTiles(
                        color: Colors.grey,
                        tiles: [
                          // ListTile(
                          //   leading: Icon(
                          //     Icons.account_box,
                          //     size: 30,
                          //   ),
                          //   title: Text('เลขประจำตัว',
                          //       style: TextStyle(
                          //           fontSize: 15, color: Colors.blue)),
                          //   subtitle: Text('$psId',
                          //       style: TextStyle(
                          //           fontSize: 19, color: Colors.black87)),
                          // ),
                          ListTile(
                            leading: Icon(
                              Icons.person,
                              size: 30,
                            ),
                            title: Text('ชื่อ',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.blue)),
                            subtitle: Text('$_psName',
                                style: TextStyle(
                                    fontSize: 19, color: Colors.black87)),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.person_outline,
                              size: 30,
                            ),
                            title: Text('นามสกุล',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.blue)),
                            subtitle: Text('$_psLastname',
                                style: TextStyle(
                                    fontSize: 19, color: Colors.black87)),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.home,
                              size: 30,
                            ),
                            title: Text('ที่อยู่',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.blue)),
                            subtitle: Text('$_psAddress',
                                style: TextStyle(
                                    fontSize: 19, color: Colors.black87)),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.phone,
                              size: 30,
                            ),
                            title: Text('เบอร์โทร',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.blue)),
                            subtitle: Text('$_psTel',
                                style: TextStyle(
                                    fontSize: 19, color: Colors.black87)),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.email,
                              size: 30,
                            ),
                            title: Text('อีเมล',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.blue)),
                            subtitle: Text('$_psEmail',
                                style: TextStyle(
                                    fontSize: 19, color: Colors.black87)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future listDialog() async {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.delete_forever,
                    size: 30,
                    color: Colors.red,
                  ),
                  Expanded(
                    child: Text('ลบข้อมูลพนักงานรับส่ง'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'ไม่ใช่',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () => Navigator.pop(context, '/personlist'),
                ),
                TextButton(
                  child: Text(
                    'ใช่',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Map<String, dynamic> values = Map();
                    values['ps_id'] = psId;

                    _deleteperson(values);
                    // Navigator.pop(context, '/');
                    // int count = 0;
                    // Navigator.of(context).popUntil((_) => count++ >= 2);
                  },
                ),
              ],
            ));
  }

  void _showSnack() => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          // action: SnackBarAction(
          //   label: 'Action',
          //   onPressed: () {
          //     // Code to execute.
          //   },
          // ),
          content: Row(
            children: [
              Icon(
                Icons.check,
                color: Colors.white,
                size: 30.0,
              ),
              Expanded(
                child: Text('ลบข้อมูลพนักงานสำเร็จ'),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 1700),
          width: 350, // Width of the SnackBar.
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0, // Inner padding for SnackBar content.
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      );
} //class