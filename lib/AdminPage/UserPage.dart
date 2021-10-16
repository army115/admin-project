
import 'package:admin_project/model/profile.dart';
import 'package:flutter/material.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({Key key}) : super(key: key);

  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  // final _formkey = GlobalKey<FormState>();

  // TextEditingController _uuser;
  var _uId;
  var _uName;
  var _uLastname;
  var _uEmail;
  var _uTel;

  Map<String, dynamic> _rec_user;
  var token;
  var uId;
  var or_id;

  Future<Null> getInfo() async {
    // รับค่า
    _rec_user = ModalRoute.of(context).settings.arguments;

    _uId = _rec_user['u_id'];
    _uName = _rec_user['u_name'];
    _uLastname = _rec_user['u_lastname'];
    _uEmail = _rec_user['u_email'];
    _uTel = _rec_user['u_tel'];
  }

  @override
  Widget build(BuildContext context) {
    getInfo();
    return Scaffold(
      appBar: AppBar(
        title: Text('แสดงข้อมูลลูกค้า',style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.grey[300],
      body: Center(
          // child: Form(
          //   key: _formkey,
            child: Center(
              child: Column(
                children: [
                 ProfileHeader(
                   avatar: AssetImage('assets/images/user.png'),
                  coverImage: AssetImage('assets/images/background.png'),),
                  Padding(
                  padding: EdgeInsets.all(10.0),
                 child: Card(
                   child: Column(
                      children:[
                        ...ListTile.divideTiles(
                          color: Colors.grey,
                          tiles: [
                      //       ListTile(
                      //         leading: Icon(Icons.account_box,size: 30,),
                      //         title: Text('เลขประจำตัว',
                      // style: TextStyle(fontSize: 15,color: Colors.blue)),
                      //         subtitle: Text('$_uId',
                      //         style: TextStyle(fontSize: 19,color: Colors.black87)),
                      //       ),
                            ListTile(
                              leading: Icon(Icons.person,size: 30,),
                              title: Text('ชื่อ',
                      style: TextStyle(fontSize: 15,color: Colors.blue)),
                              subtitle: Text('$_uName',
                              style: TextStyle(fontSize: 19,color: Colors.black87)),
                            ),
                            ListTile(
                              leading: Icon(Icons.person_outline,size: 30,),
                              title: Text('สกุล',
                      style: TextStyle(fontSize: 15,color: Colors.blue)),
                              subtitle: Text('$_uLastname',
                              style: TextStyle(fontSize: 19,color: Colors.black87)),
                            ),
                            ListTile(
                              leading: Icon(Icons.phone,size: 30,),
                              title: Text('เบอร์โทร',
                      style: TextStyle(fontSize: 15,color: Colors.blue)),
                              subtitle: Text('$_uTel',
                              style: TextStyle(fontSize: 19,color: Colors.black87)),
                            ),
                            ListTile(
                              leading: Icon(Icons.email,size: 30,),
                              title: Text('อีเมล',
                      style: TextStyle(fontSize: 15,color: Colors.blue)),
                      subtitle: Text('$_uEmail',
                      style: TextStyle(fontSize: 19,color: Colors.black87)),
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
          // ),
      ),
    );
  }

} //class

