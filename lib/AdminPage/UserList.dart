import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:admin_project/model/Connectapi.dart';
import 'package:admin_project/model/userlist.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<User> datamember = [];
  List<User> datauser = [];
  // var uId;
  var token;

  //connect server api
  Future<Null> _getShowUserList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // uId = prefs.getInt('id');
    // print('uId = $uId');
    print('token = $token');
    var url = '${Connectapi().domain}/UserList';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    //check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      UserList members = UserList.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        datamember = members.user;
        datauser = datamember;
        // load = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //call _getAPI
    _getShowUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.grey[300],
                padding: EdgeInsets.only(top: 115),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: list(),
              ),
              Container(
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Padding(
                  padding: EdgeInsets.only(right: 150),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context, '/homepage');
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                      Text('รายชื่อลูกค้า',
                          style: TextStyle(color: Colors.black, fontSize: 20)),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 85,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Material(
                        color: Colors.white,
                        elevation: 5.0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: TextField(
                          // controller: TextEditingController(text: locations[0]),
                          cursorColor: Colors.amber,
                          decoration: InputDecoration(
                              hintText: 'ค้นหาลูกค้า',
                              hintStyle: TextStyle(
                                  color: Colors.black38, fontSize: 16),
                              prefixIcon: Material(
                                color: Colors.white,
                                elevation: 0.0,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                child: Icon(Icons.search,),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 13)),
                          onChanged: (text) {
                            text = text.toLowerCase();
                            setState(() {
                              datamember = datauser.where((note) {
                                var noteName = note.uName.toLowerCase();
                                return noteName.contains(text);
                              }).toList();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget list() {
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(5),
      child: Container(
        child: ListView.builder(
          itemCount: datamember.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: Image.asset(
                  'assets/images/user.png',
                ),
                title: Text(
                  'ชื่อ : ${datamember[index].uName} ${datamember[index].uLastname}',
                ),
                subtitle: Text(
                  'รหัสประจำตัว : ${datamember[index].uId}',
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, '/userpage', arguments: {
                    'u_id': datamember[index].uId,
                    'u_name': datamember[index].uName,
                    'u_lastname': datamember[index].uLastname,
                    'u_email': datamember[index].uEmail,
                    'u_tel': datamember[index].uTel,
                  });
                },
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            );
          },
          // separatorBuilder: (context, index) => Divider(
          //   color: Colors.grey,
          // ),
        ),
      ),
    );
  }
}
