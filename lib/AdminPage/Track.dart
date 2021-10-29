import 'package:admin_project/model/Connectapi.dart';
import 'package:admin_project/model/OrderImage.dart';
import 'package:admin_project/model/Savedata.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class Track extends StatefulWidget {
  Track({Key key}) : super(key: key);

  @override
  _TrackState createState() => _TrackState();
}

class _TrackState extends State<Track> {
  List<Save> save = [];
  List<Save> track = [];
  bool load = true;
  var _orid;

  Map<String, dynamic> _rec_order;
  var token;

  // Future onGoBack(dynamic value) {
  //   setState(() {
  //     _getShowOrderSent();
  //   });
  // }

  Future getInfo() async {
    // รับค่า
    _rec_order = ModalRoute.of(context).settings.arguments;
    _orid = _rec_order['or_id'];
    print(_orid);
  }
  

  Future<void> _getShowTrack() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // uId = prefs.getInt('id');
    // print('uId = $uId');
    print('token = $token');
    var url = '${Connectapi().domain}/ShowSavetrack/$_orid';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

//check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      Savedata members = Savedata.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        track = members.save;
        // load = false;
      });
    }
  }

    Future<void> _getTrack() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // uId = prefs.getInt('id');
    // print('uId = $uId');
    print('token = $token');
    var url = '${Connectapi().domain}/ShowSavetrack/$_orid';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

//check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      Savedata members = Savedata.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        save = members.save;
        // load = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //call _getAPI
    _getShowTrack();
    _getTrack();
  }

  @override
  Widget build(BuildContext context) {
    getInfo();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.grey[300],
                padding: EdgeInsets.only(top: 110),
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
                  padding: EdgeInsets.only(right: 130),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                      Text('รายการเลขพัสดุ',
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
                              hintText: 'ค้นหาชื่อผู้รับ',
                              hintStyle: TextStyle(
                                  color: Colors.black38, fontSize: 16),
                              prefixIcon: Material(
                                color: Colors.white,
                                elevation: 0.0,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                child: Icon(
                                  Icons.search,
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 13)),
                          onChanged: (text) {
                            text = text.toLowerCase();
                            setState(() {
                              save = track.where((note) {
                                var noteName = note.trackName.toLowerCase();
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: save.length,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    ListTile(
                      // leading: Image.asset('assets/images/ps01.png'),
                      title: Text(
                        'ชื่อผู้รับ : ${save[index].trackName}\nเลขพัสดุ : ${save[index].trackNum}',
                      ),
                      subtitle: Text(
                        'ค่าส่งพัสดุ : ${save[index].trackSale}',
                      ),
                      trailing: Image.asset('assets/images/order.png'),
                    ),
                  ],
                ),
              ),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            );
          },
        ),
      ),
    );
  }
}
