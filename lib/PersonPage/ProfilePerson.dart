import 'package:admin_project/Widgets/Show_progress.dart';
import 'package:admin_project/model/Connectapi.dart';
import 'package:admin_project/model/person.dart';
import 'package:admin_project/model/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePerson extends StatefulWidget {
  ProfilePerson({Key key}) : super(key: key);

  @override
  _ProfilePersonState createState() => _ProfilePersonState();
}

class _ProfilePersonState extends State<ProfilePerson> {
  // String psId;
  Personinfo psdata;
  bool load = true;

//connect server api
  Future<void> _getProfilePerson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var psId = prefs.getInt('psid');
    print('psId = $psId');
    print('token = $token');
    var url = '${Connectapi().domain}/getprofilePerson/$psId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    //check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      Person members = Person.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        psdata = members.personinfo;
        load = false;
      });
    }
  }

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    // Call _getProfile
    _getProfilePerson();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('โปรไฟล์', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context, '/homeperson');
          },
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: load ? ShowProgress() : buildCenter(),
    );
  }
  Center buildCenter() {
    return Center(
        child: Container(
              child: Column(
                children: [ 
                   ProfileHeader(
                avatar: AssetImage('assets/images/person.png'),
                coverImage: AssetImage('assets/images/background.png'),
              ),
                  PersonInfo()
                ],
              ),
        ),
      );
}

Widget PersonInfo () {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Card(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Column(
                    children:[
                      ...ListTile.divideTiles(
                        color: Colors.grey,
                        tiles: [
                          ListTile(
                            leading: Icon(Icons.person,size: 30,),
                            title: Text('ชื่อ',
                    style: TextStyle(fontSize: 15,color: Colors.blue)),
                            subtitle: Text(' ${psdata.psName}',
                            style: TextStyle(fontSize: 19,color: Colors.black87)),
                          ),
                          ListTile(
                            leading: Icon(Icons.person_outline,size: 30,),
                            title: Text('สกุล',
                    style: TextStyle(fontSize: 15,color: Colors.blue)),
                            subtitle: Text('${psdata.psLastname}',
                            style: TextStyle(fontSize: 19,color: Colors.black87)),
                          ),
                          ListTile(
                            leading: Icon(Icons.home,size: 30,),
                            title: Text('ที่อยู่',
                    style: TextStyle(fontSize: 15,color: Colors.blue)),
                            subtitle: Text('${psdata.psAddress}',
                            style: TextStyle(fontSize: 19,color: Colors.black87)),
                          ),
                          ListTile(
                            leading: Icon(Icons.phone,size: 30,),
                            title: Text('เบอร์',
                    style: TextStyle(fontSize: 15,color: Colors.blue)),
                            subtitle: Text('${psdata.psTel}',
                            style: TextStyle(fontSize: 19,color: Colors.black87)),
                          ),
                          ListTile(
                            leading: Icon(Icons.email,size: 30,),
                            title: Text('อีเมล',
                    style: TextStyle(fontSize: 15,color: Colors.blue)),
                    subtitle: Text('${psdata.psEmail}',
                    style: TextStyle(fontSize: 19,color: Colors.black87)),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            elevation: 10,
          )
        ],
      ),
    );
  }
}//class
