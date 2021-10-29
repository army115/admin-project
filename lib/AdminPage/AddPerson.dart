import 'package:admin_project/model/Connectapi.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class AddPerson extends StatefulWidget {
  AddPerson({Key key}) : super(key: key);

  @override
  _AddPersonState createState() => _AddPersonState();
}

class _AddPersonState extends State<AddPerson> {
  //เช็คการกรอกข้อมูล
  final _formkey = GlobalKey<FormState>();
  final _psUser = TextEditingController();
  final _psPass = TextEditingController();
  final _conpass = TextEditingController();
  final _psName = TextEditingController();
  final _psLastname = TextEditingController();
  final _psAddress = TextEditingController();
  final _psTel = TextEditingController();
  final _psEmail = TextEditingController();

  bool redEyepass = true;
  bool redEyecon = true;
  var confirmPass;

  //connect server api
  void _addperson(Map<String, dynamic> values) async {
    var url = '${Connectapi().domain}/addperson';
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: convert.jsonEncode(values));

    if (response.statusCode == 200) {
      print('Add Success');
      _showSnack();
      Navigator.pop(context, true);
    } else {
      print('Add not Success');
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            Text('เพิ่มข้อมูลพนักงาน', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 10, right: 15, bottom: 10),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  // CircleAvatar(
                  //         radius: 30,
                  //       child: Column(children: [
                  //         Icon(Icons.account_circle,
                  //         size: 60,
                  //         ),
                  //       ],),
                  //       ),

                  //       Row(
                  //         children: [
                  //         SizedBox(width: 170),
                  //         Icon(Icons.add_circle,
                  //         color: Colors.blue[700]),
                  //         ],
                  //       ),

                  Column(
                    children: [
                      username(),
                      SizedBox(height: 10),
                      password(),
                      SizedBox(height: 10),
                      conpass(),
                      SizedBox(height: 10),
                      psname(),
                      SizedBox(height: 10),
                      pslastname(),
                      SizedBox(height: 10),
                      adress(),
                      SizedBox(height: 10),
                      phone(),
                      SizedBox(height: 5),
                      email(),
                      SizedBox(height: 30),
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
      ),
    );
  }

  Widget username() {
    return TextFormField(
      controller: _psUser,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
        labelText: 'ชื่อผู้ใช้',
        hintText: 'กรอกชื่อผู้ใช้',
        icon: Icon(Icons.account_circle, size: 35),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      validator: (values) {
        if (values == null || values.isEmpty) return 'กรุณากรอกชื่อผู้ใช้';
      },
    );
  }

  Widget password() {
    return TextFormField(
      controller: _psPass,
      obscureText: redEyepass,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
        labelText: 'รหัสผ่าน',
        hintText: 'กรอกรหัสผ่าน อย่างน้อย 8 ตัว',
        icon: Icon(Icons.vpn_key, size: 35),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              redEyepass = !redEyepass;
            });
          },
          icon: redEyepass
              ? Icon(
                  Icons.visibility,
                  // color: MyConstant.dark,
                )
              : Icon(
                  Icons.visibility_off,
                  // color: MyConstant.dark,
                ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      validator: (values) {
        confirmPass = values;
        if (values.isEmpty) {
          return 'กรุณากรอกรหัสผ่าน';
        } else if (values.length < 8) {
          return "รหัสผ่านอย่างน้อย 8 ตัว";
        } else {
          return null;
        }
      },
    );
  }

  Widget conpass() {
    return TextFormField(
      controller: _conpass,
      obscureText: redEyecon,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
        labelText: 'ยืนยันรหัสผ่าน',
        hintText: 'กรุณากรอกรหัสผ่านให้ตรงกัน',
        icon: Icon(Icons.vpn_key_outlined, size: 35),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              redEyecon = !redEyecon;
            });
          },
          icon: redEyecon
              ? Icon(
                  Icons.visibility,
                  // color: MyConstant.dark,
                )
              : Icon(
                  Icons.visibility_off,
                  // color: MyConstant.dark,
                ),
        ),
      ),
      validator: (values) {
        if (values.isEmpty) {
          return 'กรุณากรอกรหัสผ่าน';
        } else if (values != confirmPass) {
          return "รหัสผ่านไม่ตรงกัน";
        } else {
          return null;
        }
      },
    );
  }

  Widget psname() {
    return TextFormField(
      controller: _psName,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
        labelText: 'ชื่อ',
        hintText: 'กรอกชื่อ',
        icon: Icon(Icons.person, size: 35),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      validator: (values) {
        if (values.isEmpty) return 'กรุณากรอกชื่อ';
      },
    );
  }

  Widget pslastname() {
    return TextFormField(
      controller: _psLastname,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
        labelText: 'นามสกุล',
        hintText: 'กรอกนามสกุล',
        icon: Icon(Icons.person_outline, size: 35),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      validator: (values) {
        if (values.isEmpty) return 'กรุณากรอกนามสกุล';
      },
    );
  }

  Widget adress() {
    return TextFormField(
      maxLines: 2,
      controller: _psAddress,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
        labelText: 'ที่อยู่',
        hintText: 'กรอกที่อยู่',
        icon: Icon(Icons.home, size: 35),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      validator: (values) {
        if (values.isEmpty) return 'กรุณากรอกที่อยู่';
      },
    );
  }

  Widget phone() {
    return TextFormField(
      maxLength: 10,
      controller: _psTel,
      decoration: InputDecoration(
        counter: Offstage(),
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
        labelText: 'เบอร์โทร',
        hintText: 'กรอกเบอร์โทร',
        icon: Icon(Icons.phone_iphone, size: 35),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      validator: (values) {
        if (values.isEmpty) {
          return 'กรุณากรอกเบอร์โทร';
        } else if (values.length < 10) {
          return "กรุณากรอกเบอร์โทรให้ครบ 10 ตัว";
        } else {
          return null;
        }
      },
    );
  }

  Widget email() {
    return TextFormField(
      controller: _psEmail,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
        labelText: 'อีเมล',
        hintText: 'กรอกอีเมล',
        icon: Icon(Icons.email, size: 35),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      validator: (values) {
        if (values.isEmpty) {
          return 'กรุณากรอกอีเมล';
        } else if (values.isEmpty || !values.contains("@")) {
          return "รูปแบบอีเมลไม่ถูกต้อง";
        } else {
          return null;
        }
      },
    );
  }

  Widget btnSubmit() {
    return SizedBox(
      width: 150,
      height: 45,
      child: RaisedButton(
        child: Text(
          'ยืนยัน',
          style: TextStyle(fontSize: 20),
        ),
        color: Colors.amber,
        onPressed: () {
          //ถ้ากรอกครบทุกช่องมันจะเข้า if
          if (_formkey.currentState.validate()) {
            Map<String, dynamic> valuse = Map();
            valuse['ps_user'] = _psUser.text;
            valuse['ps_pass'] = _psPass.text;
            valuse['ps_name'] = _psName.text;
            valuse['ps_lastname'] = _psLastname.text;
            valuse['ps_address'] = _psAddress.text;
            valuse['ps_email'] = _psEmail.text;
            valuse['ps_tel'] = _psTel.text;

            print(_psUser.text);
            print(_psPass.text);
            print(_psName.text);
            print(_psLastname.text);
            print(_psAddress.text);
            print(_psEmail.text);
            print(_psTel.text);
            // print(valuse);
            _addperson(valuse);
            // Navigator.pop(context,);
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
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
                child: Text('เพิ่มข้อมูลพนักงานรับส่งสำเร็จ'),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 1500),
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

  Widget btncancel() {
    return SizedBox(
      width: 150,
      height: 45,
      child: RaisedButton(
        child: Text(
          'ยกเลิก',
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () {
          Navigator.pop(context, '/');
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
      ),
    );
  }
}//class