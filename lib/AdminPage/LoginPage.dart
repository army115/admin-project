import 'dart:convert';
import 'package:admin_project/AdminPage/HomePage.dart';
import 'package:admin_project/PersonPage/PersonHomepage.dart';
import 'package:admin_project/model/Login.dart';
import 'package:admin_project/utility/my_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool redEye = true;
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  Login login = Login();

  Future adminLogin() async {
    if (_formkey.currentState.validate()) {
      try {
        var rs = await login.adminLogin(_username.text, _password.text);
        if (rs.statusCode == 200) {
          print(rs.body);
          var jsonRes = json.decode(rs.body);
          if (jsonRes['ok']) {
            String token = jsonRes['token'];
            var adId = jsonRes['adid'];
            print(token);
            print(adId);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', token);
            await prefs.setInt('ad_id', adId);

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage()));
            _showSnack();
          } else {
            print(jsonRes['error']);
            // _showerror();
            normalDialog(context, 'ชื่อผู้ใช้หรือ\nรหัสผ่านไม่ถูกต้อง', 'โปรดลองอีกครั้ง');
          }
        } else {
          print('Connection Fail');
        }
      } catch (error) {
        print(error);
      }
    }
  }

  Future doLogin2() async {
    if (_formkey.currentState.validate()) {
      try {
        var rs = await login.doLogin2(_username.text, _password.text);
        if (rs.statusCode == 200) {
          print(rs.body);
          var jsonRes = json.decode(rs.body);
          if (jsonRes['ok']) {
            String token = jsonRes['token'];
            var psId = jsonRes['psid'];
            print(token);
            print(psId);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', token);
            await prefs.setInt('psid', psId);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePerson()));
                _showSnack();
            // }
          } else {
            print(jsonRes['error']);
            // _showerror();
            // normalDialog(context, 'ชื่อผู้ใช้หรือ\nรหัสผ่านไม่ถูกต้อง','โปรดลองอีกครั้ง');
          }
        } else {
          print('Connection Fail');
        }
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('assets/images/Logo.png'),
                  ),
                  SizedBox(height: 20),
                  Text('แอปพลิเคชันบริการรับฝากส่งพัสดุ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ,color: Theme.of(context).primaryColorDark),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: SafeArea(
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.orangeAccent[100],
                                        blurRadius: 10,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    //เส้นคั่น
                                    // decoration: BoxDecoration(
                                    //     border: Border(
                                    //         bottom: BorderSide(
                                    //             color: Colors.grey[200]))),
                                    child: username()
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: password()
                                  ),
                                  SizedBox(
                              height: 10,
                            ),
                                ],
                              ),
                            ),
                            // btnForgotPass(),
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              height: 50,
                              // margin: EdgeInsets.symmetric(horizontal: 50),
                              // decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(50),
                              //     color: Colors.orange[900]),
                              child: Center(
                                child: btnSubmit()
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget username() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white60, borderRadius: BorderRadius.circular(10.0)),
      width: 300,
      child: TextFormField(
        controller: _username,
        decoration: InputDecoration(
          // filled: true, ใส่พื้นหลัง
          // contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
          labelText: 'ชื่อผู้ใช้',
          hintText: 'กรอกชื่อผู้ใช้',
          prefixIcon: Icon(Icons.person,
              //prefixIcon ใส่กรอบครอบไอคอน
              size: 25),
          // border: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(10.0),
          // ),
          // border: InputBorder.none
        ),
        validator: (values) {
          if (values.isEmpty) {
            return 'กรุณากรอกชื่อผู้ใช้';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget password() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white60, borderRadius: BorderRadius.circular(10.0)),
      // margin: EdgeInsets.only(top: 16),
      width: 300,
      child: TextFormField(
        controller: _password,
        obscureText: redEye,
        decoration: InputDecoration(
          // contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
          labelText: 'รหัสผ่าน',
          hintText: 'กรอกรหัสผ่าน',
          prefixIcon: Icon(
            Icons.lock,
            //prefixIcon ใส่กรอบครอบไอคอน
            size: 25,
          ),
          // border: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(10.0),
          // ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                redEye = !redEye;
              });
            },
            icon: Icon(Icons.remove_red_eye),
          ),
        ),
        validator: (values) {
          if(values == null || values.isEmpty) {
            return 'กรุณากรอกรหัสผ่าน';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget btnSubmit() {
    return SizedBox(
      width: 270,
      height: 40,
      child: RaisedButton(
        child: Text('เข้าสู่ระบบ',
            style: TextStyle(
              fontSize: 20,fontWeight: FontWeight.bold
            )),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          adminLogin();
          doLogin2();
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
      ),
    );
  }

  Widget btnForgotPass() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            child: TextButton(
                child: Text('ลืมรหัสผ่าน?',
                style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColorDark),),
                //color: Colors.cyan,
                onPressed: () {
                  Navigator.pushNamed(context, '');
                }))
      ],
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
                child: Text('เข้าสู่ระบบสำเร็จ'),
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

      void _showerror() => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
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
                child: Text('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง'),
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