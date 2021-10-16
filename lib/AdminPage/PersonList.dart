import 'package:admin_project/model/Connectapi.dart';
import 'package:admin_project/model/personlist.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class PersonPage extends StatefulWidget {
  PersonPage({Key key}) : super(key: key);

  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  List<Person> datamember = [];
  List<Person> dataperson = [];

  var token;
  var psId;

  //connect server api
  Future<void> _getShowPersonList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // psId = prefs.getInt('ps_id');
    // print('psId = $psId');
    print('token = $token');
    var url = '${Connectapi().domain}/PersonList';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

//check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      PersonList members =
          PersonList.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        datamember = members.person;
        dataperson = datamember;
        // load = false;
      });
    }
  }

    Future onGoBack(dynamic value) {
    setState(() {
      _getShowPersonList();
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //call _getAPI
    _getShowPersonList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title:
      //       Text('รายชื่อพนักงานรับส่ง', style: TextStyle(color: Colors.black)),
      //   backgroundColor: Colors.amber,
      // ),
      floatingActionButton: Container(
        height: 50,
        width: 50,
        child: FloatingActionButton(
          child: Icon(
            Icons.person_add,
            size: 30,
            color: Colors.black,
          ),
          backgroundColor: Colors.amber,
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/addperson',
            );
          },
        ),
      ),
      body: Container(
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
                padding: EdgeInsets.only(right: 110),
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
                    Text('รายชื่อพนักงานรับส่ง',
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
                        // style: dropdownMenuItem,
                        decoration: InputDecoration(
                            fillColor: Colors.amber,
                            focusColor: Colors.amber,
                            hoverColor: Colors.amber,
                            hintText: 'ค้นหาพนักงาน',
                            hintStyle:
                                TextStyle(color: Colors.black38, fontSize: 16),
                            prefixIcon: Material(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: Icon(Icons.search),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 13)),
                        onChanged: (text) {
                          text = text.toLowerCase();
                          setState(() {
                            datamember = dataperson.where((note) {
                              var noteName = note.psName.toLowerCase();
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
                  'assets/images/person.png',
                ),
                title: Text(
                  'ชื่อ : ${datamember[index].psName} ${datamember[index].psLastname}',
                ),
                subtitle: Text(
                  'รหัสประจำตัว : ${datamember[index].psId}',
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, '/personpage', arguments: {
                    'ps_id': datamember[index].psId,
                    'ps_name': datamember[index].psName,
                    'ps_lastname': datamember[index].psLastname,
                    'ps_address': datamember[index].psAddress,
                    'ps_email': datamember[index].psEmail,
                    'ps_tel': datamember[index].psTel,
                  }).then((onGoBack));
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
}//class
