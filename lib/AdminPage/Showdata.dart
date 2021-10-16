import 'package:admin_project/model/Connectapi.dart';
import 'package:admin_project/model/OrderImage.dart';
import 'package:admin_project/model/OrderSent.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class Showdata extends StatefulWidget {
  Showdata({Key key}) : super(key: key);

  @override
  _ShowdataState createState() => _ShowdataState();
}

class _ShowdataState extends State<Showdata> {
  List<Sent> sent = [];
  Getorderimage orimg;
  bool load = true;
  var _Status2 = 'รอบันทึกข้อมูล';
  var token;

  var formatter = DateFormat('dd/MM/y');
  var formattime = DateFormat('HH:mm');

  Future onGoBack(dynamic value) {
    setState(() {
      _getShowOrderSent();
    });
  }

  Future<void> _getShowOrderSent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // uId = prefs.getInt('id');
    // print('uId = $uId');
    print('token = $token');
    var url = '${Connectapi().domain}/ShowOrderSent';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

//check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      OrderSent members = OrderSent.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        sent = members.sent;
        // load = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //call _getAPI
    _getShowOrderSent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'บันทึกข้อมูลการส่ง',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        color: Colors.grey[300],
        child: sent.length <= 0
            ? Container(
                padding: EdgeInsets.only(right: 110, left: 110, top: 20),
                child: Opacity(
                    opacity: 0.5,
                    child: Column(
                      children: [
                        Image.asset('assets/images/noorder.png'),
                        Text(
                          'ยังไม่มีรายการบันทึกข้อมูล',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15),
                        )
                      ],
                    )),
              )
            : Container(
                child: ListView.builder(
                  itemCount: sent.length,
                  itemBuilder: (context, index) {
                    DateTime orDate =
                            DateTime.parse('${sent[index].sentDate}');
                    return Card(
                        child: Column(
                          children: [
                            ListTile(
                              // leading: Image.asset('assets/images/save.png'),
                              title: Text(
                                'ผู้แจ้งส่ง : ${sent[index].uName} ${sent[index].uLastname}\nวันที่นำส่ง : ${formatter.format(orDate)}\nเวลานำส่ง : ${formattime.format(orDate)}',
                              ),
                              subtitle: Text(
                                'จำนวนพัสดุ : ${sent[index].sentNum} กล่อง',
                              ),
                              trailing: Image.asset('assets/images/save.png'),
                              onTap: () {
                                Navigator.pushNamed(context, '/savedata',
                                    arguments: {
                                      'or_id': sent[index].orId,
                                      'sent_date': sent[index].sentDate,
                                      'sent_time': sent[index].sentTime,
                                      'sent_num': sent[index].sentNum,
                                      'sent_id': sent[index].sentId,
                                      'or_address': sent[index].orAddress,
                                      'or_status': sent[index].orStatus,
                                      'u_name': sent[index].uName,
                                      'u_lastname': sent[index].uLastname,
                                      'ps_name': sent[index].psName,
                                      'ps_lastname': sent[index].psLastname,
                                    }).then((onGoBack));
                              },
                            ),
                            Padding(
                                  padding: const EdgeInsets.only(left: 18),
                                  child: Row(
                                    children: [
                                      Text(
                                        'สถานะ : ',
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                      _status2(context, sent[index].orStatus)
                                    ],
                                  ),
                                ),
                          ],
                        ),
                      
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    );
                  },
                ),
              ),
      ),
    );
  }
  Widget _status2(BuildContext context, orderStatus) {
    Widget child;
    if (orderStatus != '2') {
      child =
          Text(_Status2, style: TextStyle(fontSize: 14, color: Colors.blue));
    } else {}
    return new Container(child: child);
  }
}
