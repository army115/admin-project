import 'package:admin_project/AdminPage/PersonList.dart';
import 'package:admin_project/model/Connectapi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class UpdatePerson extends StatefulWidget {
  UpdatePerson({Key key}) : super(key: key);

  @override
  _UpdatePersonState createState() => _UpdatePersonState();
}

class _UpdatePersonState extends State<UpdatePerson> {
  final _formkey = GlobalKey<FormState>();

  //  TextEditingController _uuser;
  //  TextEditingController _upass;
  TextEditingController psName;
  TextEditingController psLastname;
  TextEditingController psAddress;
  TextEditingController psTel;
  TextEditingController psEmail;

  Map<String, dynamic> rec_person;
  var token;
  var psId;
  // var ps_Id;

  Future getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // ps_Id = prefs.getInt('psid');
    print('token = $token');
    // print('psId = $psId');
  }

  //connect server api
  Future<void> _updateperson(Map<String, dynamic> values) async {
    var url = '${Connectapi().domain}/updateperson/$psId';
    print(psId);
    var response = await http.put(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: convert.jsonEncode(values));
    print(values);
    if (response.statusCode == 200) {
      print('Accept Success');
      Navigator.pop(context, true);
      _showSnack();
    } else {
      print('Accept Fail');
    }
  }

  Future getInfoPerson() async {
    rec_person =
        ModalRoute.of(context).settings.arguments;

    psId = rec_person['_psId'];
    // _uuser = TextEditingController (text: rec_user['u_user']);
    // _upass = TextEditingController (text: rec_user['u_pass']);
    psName = TextEditingController(text: rec_person['_psName']);
    psLastname = TextEditingController(text: rec_person['_psLastname']);
    psAddress = TextEditingController(text: rec_person['_psaddress']);
    psEmail = TextEditingController(text: rec_person['_psEmail']);
    psTel = TextEditingController(text: rec_person['_psTel']);
    print(psId);
  }

  @override
  Widget build(BuildContext context) {
    getPrefs();
    getInfoPerson();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('แก้ไขข้อมูลพนักงานส่ง',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(height: 10),
                    // username(),
                    // SizedBox(height: 10),
                    name(),
                    SizedBox(height: 10),
                    lastname(),
                    SizedBox(height: 10),
                    address(),
                    SizedBox(height: 10),
                    phone(),
                    SizedBox(height: 10),
                    email(),
                    SizedBox(height: 20),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    btncancel(),
                    btnSubmit(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget username(){
  //   return TextFormField(
  //      controller: _uuser,
  //     decoration: InputDecoration(
  //         contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
  //           labelText: 'ชื่อผู้ใช้',
  //           hintText: 'กรอกชื่อผู้ใช้',
  //           icon: Icon(Icons.account_circle,
  //           size: 25),
  //           border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(5.0),
  //           ),
  //     ),
  //     validator: (values){
  //       if (values.isEmpty)
  //       return 'กรุณากรอกชื่อผู้ใช';
  //     },
  //   );
  // }

  // Widget password(){
  //   return TextFormField(
  //     controller: _upass,
  //     decoration: InputDecoration(
  //         contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
  //           labelText: 'รหัสผ่าน',
  //           hintText: 'กรอกรหัสผ่าน',
  //           icon: Icon(Icons.vpn_key,
  //           size: 25),
  //           border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(5.0),
  //           ),
  //     ),
  //     validator: (values){
  //       if (values.isEmpty)
  //       return 'กรุณากรอกรหัสผ่าน';
  //     },
  //   );
  // }

  Widget name() {
    return TextFormField(
      controller: psName,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
        labelText: 'ชื่อ',
        hintText: 'กรอกชื่อ',
        icon: Icon(Icons.person, size: 25),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(5.0),
        // ),
      ),
      validator: (values) {
        if (values.isEmpty) return 'กรุณากรอกชื่อ';
      },
    );
  }

  Widget lastname() {
    return TextFormField(
      controller: psLastname,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
        labelText: 'นามสกุล',
        hintText: 'กรอกนามสกุล',
        icon: Icon(Icons.person_outline, size: 25),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(5.0),
        // ),
      ),
      validator: (values) {
        if (values.isEmpty) return 'กรุณากรอกนามสกุล';
      },
    );
  }

  Widget address() {
    return TextFormField(
      controller: psAddress,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
        labelText: 'ที่อยู่',
        hintText: 'กรอกที่อยู่',
        icon: Icon(Icons.home, size: 25),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(5.0),
        // ),
      ),
      validator: (values) {
        if (values.isEmpty) return 'กรุณากรอกที่อยู่';
      },
    );
  }

  Widget phone() {
    return TextFormField(
      controller: psTel,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
        labelText: 'เบอร์โทร',
        hintText: 'กรอกเบอร์โทร',
        icon: Icon(Icons.phone_iphone, size: 25),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(5.0),
        // ),
      ),
      validator: (values) {
        if (values.isEmpty) return 'กรุณากรอกเบอร์';
      },
    );
  }

  Widget email() {
    return TextFormField(
      controller: psEmail,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
        labelText: 'อีเมล',
        hintText: 'กรอกอีเมล',
        icon: Icon(Icons.email, size: 25),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(5.0),
        // ),
      ),
      validator: (values) {
        if (values.isEmpty) return 'กรุณากรอกอีเมล';
      },
    );
  }

  Widget btnSubmit() {
    return SizedBox(
      width: 140,
      height: 38,
      child: RaisedButton(
        child: Text('ยืนยัน',
            style: TextStyle(
              fontSize: 18,
            )),
        color: Colors.amber,
        onPressed: () {
          //ถ้ากรอกครบทุกช่องมันจะเข้า if

          Map<String, dynamic> valuse = Map();
          valuse['ps_id'] = psId;
          // valuse['u_user'] = _uuser.text;
          // valuse['u_pass'] = _upass.text;
          valuse['ps_name'] = psName.text;
          valuse['ps_lastname'] = psLastname.text;
          valuse['ps_email'] = psEmail.text;
          valuse['ps_address'] = psAddress.text;
          valuse['ps_tel'] = psTel.text;

          print(psId);
          // print(_uuser.text);
          print(psName.text);
          // print(_upass.text);
          print(psLastname.text);
          print(psEmail.text);
          print(psAddress.text);
          print(psTel.text);

          print(valuse);
          _updateperson(valuse);
          // int count = 0;
          // Navigator.of(context).popUntil((_) => count++ >= 2);
          // MaterialPageRoute materialPageRoute = 
          //   MaterialPageRoute(builder: (context){
          //     return PersonPage();
          //   });
          //   Navigator.of(context).push(materialPageRoute).then((value) {
          //     setState(() {  
          //     });
          //   });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget btncancel() {
    return SizedBox(
      width: 140,
      height: 38,
      child: RaisedButton(
        child: Text('ยกเลิก',
            style: TextStyle(
              fontSize: 18,
            )),
        // color: Colors.red,
        onPressed: () {
          Navigator.pop(context,);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
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
              Icon(Icons.check,
              color: Colors.white,
              size: 30.0,),
              Expanded(
                child: Text('แก้ไขข้อมูลสำเร็จ'),
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
}//class
