import 'dart:ffi';
import 'package:admin_project/model/CheckReceived.dart';
import 'package:admin_project/model/Connectapi.dart';
import 'package:admin_project/model/OrderImage.dart';
import 'package:admin_project/model/OrderList.dart';
import 'package:admin_project/model/OrderSent.dart';
import 'package:admin_project/modelPerson/CheckOrderPerson.dart';
import 'package:admin_project/modelPerson/OrderSentPerson.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOrder extends StatefulWidget {
  const CheckOrder({
    Key key,
  }) : super(key: key);

  @override
  _CheckOrderState createState() => _CheckOrderState();
}

class _CheckOrderState extends State<CheckOrder> {
  List<Order> status = [];
  List<Checkperson> checkperson = [];
  List<Sentperson> sentperson = [];
  Getorderimage orimg;
  // var uId;
  var psId;
  var token;
  var formatter = DateFormat('dd/MM/y');
  var formattime = DateFormat('HH:mm');

  var _Status0 = 'พัสดุที่ต้องไปรับ';
  var _Status1 = 'พัสดุที่เข้ารับแล้ว';
  var _Status2 = 'พัสดุที่นำส่งแล้ว';

  Future onGoBack(dynamic value) {
    setState(() {
      _getShowOrderList();
      _getCheckReceived();
      _getShowOrderSent();
    });
  }

//Order List (รายการที่ต้องไปรับ )
  Future<void> _getShowOrderList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    psId = prefs.getInt('psid');
    print('psId = $psId');
    print('token = $token');
    var url = '${Connectapi().domain}/ShowOrderList';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

//check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      OrderStatus members =
          OrderStatus.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        status = members.order;
        // load = false;
      });
    }
  }

  //Check Order List (รายการที่รับแล้ว )
  Future<void> _getCheckReceived() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    psId = prefs.getInt('psid');
    // print('psId = $psId');
    // print('token = $token');
    var url = '${Connectapi().domain}/CheckOderPerson/$psId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

//check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      CheckOrderPerson members =
          CheckOrderPerson.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        checkperson = members.checkperson;
        // load = false;
      });
    }
  }

  //Check Order List (รายการที่ส่งแล้ว )
  Future<void> _getShowOrderSent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    psId = prefs.getInt('psid');
    // print('psId = $psId');
    // print('token = $token');
    var url = '${Connectapi().domain}/OderSentPerson/$psId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

//check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      OrderSentPerson members =
          OrderSentPerson.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        sentperson = members.sentperson;
        // load = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //call _getAPI
    _getShowOrderList();
    _getCheckReceived();
    _getShowOrderSent();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: Text('รายการ', style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.amber,
              bottom: TabBar(
                unselectedLabelColor: Colors.black,
                labelColor: Colors.black,
                indicatorColor: Colors.black,
                labelStyle: TextStyle(
                  fontSize: 16.0,fontFamily: 'IBMPlexSansThai',
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.0,fontFamily: 'IBMPlexSansThai',
                ),
                tabs: [
                  Tab(
                    text: 'พัสดุที่ต้องรับ',
                  ),
                  Tab(
                    text: 'เข้ารับแล้ว',
                  ),
                  Tab(
                    text: 'นำส่งแล้ว',
                  ),
                ],
              ),
            ),
            body: Container(
              color: Colors.grey[300],
              padding: EdgeInsets.all(5),
              child: TabBarView(
                children: [
                  // Tab ที่ต้องไปรับ
                  Container(
                    child: status.length <= 0
                    ? Container(
                      padding: EdgeInsets.only(right: 120, left: 120,top: 20),
                      child: Opacity(
                        opacity : 0.5,
                        child: Column(
                            children: [
                              Image.asset('assets/images/noorder.png'),
                              Text('ยังไม่มีรายการแจ้งส่ง',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),)
                            ],
                          )),
                    ) :
                     Container(
                      child: ListView.builder(
                        itemCount: status.length,
                        itemBuilder: (context, index) {
                          DateTime orDate =
                              DateTime.parse('${status[index].orDate}');
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    // leading: Image.asset('assets/images/ps01.png'),
                                    title: Text(
                                      'ผู้แจ้งส่ง : ${status[index].uName} ${status[index].uLastname}\nวันที่แจ้งส่ง : ${formatter.format(orDate)}\nเวลาที่แจ้งส่ง : ${status[index].orTime}',
                                    ),
                                    subtitle: Text(
                                      'จำนวนพัสดุที่ส่ง : ${status[index].orNum} กล่อง',
                                    ),
                                    trailing: Image.asset('assets/images/ps01.png'),
                                    onTap: () {
                                      Navigator.pushNamed(context, '/changestatus',
                                          arguments: {
                                            'or_id': status[index].orId,
                                            'or_date': status[index].orDate,
                                            'or_time': status[index].orTime,
                                            'or_num': status[index].orNum,
                                            'or_status': status[index].orStatus,
                                            'or_address': status[index].orAddress,
                                            'or_office': status[index].orOffice,
                                            'or_detail': status[index].orDetail,
                                            'or_lat': status[index].orLat,
                                            'or_lng': status[index].orLng,
                                            'u_tel' : status[index].uTel,
                                            'u_name': status[index].uName,
                                            'u_lastname': status[index].uLastname,
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
                                        _status0(context, status[index].orStatus)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
                  ),
                  // Tab รับแล้ว
                  Container(
                    child: checkperson.length <= 0
                    ? Container(
                      padding: EdgeInsets.only(right: 120, left: 120,top: 20),
                      child: Opacity(
                        opacity : 0.5,
                        child: Column(
                            children: [
                              Image.asset('assets/images/noorder.png'),
                              Text('ยังไม่มีรายการแจ้งส่ง',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),)
                            ],
                          )),
                    ) :
                     Container(
                      child: ListView.builder(
                        itemCount: checkperson.length,
                        itemBuilder: (context, index) {
                          DateTime orDate =
                              DateTime.parse('${checkperson[index].checkDate}');
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    // leading: Image.asset('assets/images/ps01.png'),
                                    title: Text(
                                      'ผู้แจ้งส่ง : ${checkperson[index].uName} ${checkperson[index].uLastname}\nวันที่เข้ารับ : ${formatter.format(orDate)}\nเวลาเข้ารับ : ${checkperson[index].checkTime}',
                                    ),
                                    subtitle: Text(
                                      'จำนวนพัสดุที่รับ : ${checkperson[index].checkNum} กล่อง',
                                    ),
                                    trailing: Image.asset('assets/images/ps01.png'),
                                    onTap: () {
                                      Navigator.pushNamed(context, '/received',
                                          arguments: {
                                            'or_id': checkperson[index].orId,
                                            // 'or_sale': datamember[index].orSale,
                                            'or_date': checkperson[index].orDate,
                                            'or_time': checkperson[index].orTime,
                                            'or_num': checkperson[index].orNum,
                                            'or_status': checkperson[index].orStatus,
                                            'or_address':
                                                checkperson[index].orAddress,
                                            'or_office': checkperson[index].orOffice,
                                            'or_detail': checkperson[index].orDetail,
                                            'check_id':checkperson[index].checkId,
                                            'check_date':
                                                checkperson[index].checkDate,
                                            'check_time':
                                                checkperson[index].checkTime,
                                            'check_num': checkperson[index].checkNum,
                                            'u_tel' : checkperson[index].uTel,
                                            'u_name': checkperson[index].uName,
                                            'u_lastname':
                                                checkperson[index].uLastname,
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
                                        _status1(context, checkperson[index].orStatus)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
                  ),
                  // Tab ส่งแล้ว
                  Container(
                    child: sentperson.length <= 0
                    ? Container(
                      padding: EdgeInsets.only(right: 120, left: 120,top: 20),
                      child: Opacity(
                        opacity : 0.5,
                        child: Column(
                            children: [
                              Image.asset('assets/images/noorder.png'),
                              Text('ยังไม่มีรายการแจ้งส่ง',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),)
                            ],
                          )),
                    ) :
                     Container(
                      child: ListView.builder(
                        itemCount: sentperson.length,
                        itemBuilder: (context, index) {
                          DateTime orDate =
                              DateTime.parse('${sentperson[index].sentDate}');
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    // leading: Image.asset('assets/images/ps01.png'),
                                    title: Text(
                                      'ผู้แจ้งส่ง : ${sentperson[index].uName} ${sentperson[index].uLastname}\nวันที่นำส่ง : ${formatter.format(orDate)}\nเวลานำส่ง : ${sentperson[index].sentTime}',
                                    ),
                                    subtitle: Text(
                                      'จำนวนพัสดุส่ง : ${sentperson[index].sentNum} กล่อง',
                                    ),
                                    trailing: Image.asset('assets/images/ps01.png'),
                                    onTap: () {
                                      Navigator.pushNamed(context, '/sent',
                                          arguments: {
                                            'or_id': sentperson[index].orId,
                                            'check_id': sentperson[index].checkId,
                                            'sent_id':sentperson[index].sentId,
                                            'sent_date': sentperson[index].sentDate,
                                            'sent_time': sentperson[index].sentTime,
                                            'sent_num': sentperson[index].sentNum,
                                            'or_date': sentperson[index].orDate,
                                            'or_time': sentperson[index].orTime,
                                            'or_num': sentperson[index].orNum,
                                            'or_status': sentperson[index].orStatus,
                                            'or_address': sentperson[index].orAddress,
                                            'or_office': sentperson[index].orOffice,
                                            'or_detail': sentperson[index].orDetail,
                                            'or_lat': sentperson[index].orLat,
                                            'or_lng': sentperson[index].orLng,
                                            'u_tel' : sentperson[index].uTel,
                                            'u_name': sentperson[index].uName,
                                            'u_lastname': sentperson[index].uLastname,
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
                                        _status2(context, sentperson[index].orStatus)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
                  ),
                ],
              ),
            )));
  }

  Widget _status0(BuildContext context, orderStatus) {
    Widget child;
    if (orderStatus != '0') {
      child = Text(_Status0, style: TextStyle(fontSize: 14, color: Colors.red));
    } else {}
    return new Container(child: child);
  }

  Widget _status1(BuildContext context, orderStatus) {
    Widget child;
    if (orderStatus != '1') {
      child =
          Text(_Status1, style: TextStyle(fontSize: 14, color: Colors.blue));
    } else {}
    return new Container(child: child);
  }

  Widget _status2(BuildContext context, orderStatus) {
    Widget child;
    if (orderStatus != '2') {
      child =
          Text(_Status2, style: TextStyle(fontSize: 14, color: Colors.green));
    } else {}
    return new Container(child: child);
  }
} //class
