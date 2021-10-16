import 'dart:ffi';
import 'package:admin_project/model/CheckReceived.dart';
import 'package:admin_project/model/Connectapi.dart';
import 'package:admin_project/model/OrderImage.dart';
import 'package:admin_project/model/OrderList.dart';
import 'package:admin_project/model/OrderSent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({
    Key key,
  }) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Order> status = [];
  List<Check> check = [];
  List<Sent> sent = [];
  Getorderimage orimg;
  bool load = true;
  // var uId;
  var token;
  var formatter = DateFormat('dd/MM/y');
  var formattime = DateFormat('HH:mm');

  var _Status0 = 'พัสดุที่รอเข้ารับ';
  var _Status1 = 'เข้ารับพัสดุแล้ว';
  var _Status2 = 'นำส่งบริษัทขนส่งแล้ว';

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
    // var psId = prefs.getInt('psid');
    // print('psId = $psId');
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
    // uId = prefs.getInt('id');
    // print('uId = $uId');
    // print('token = $token');
    var url = '${Connectapi().domain}/CheckOrder';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

//check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      CheckReceived members =
          CheckReceived.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        check = members.check;
        // load = false;
      });
    }
  }

  //Check Order List (รายการที่ส่งแล้ว )
  Future<void> _getShowOrderSent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // uId = prefs.getInt('id');
    // print('uId = $uId');
    // print('token = $token');
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
              automaticallyImplyLeading: false,
              leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              iconSize: 30,
              color: Colors.black,
              onPressed: (){
                Navigator.pop(context);
              },
              ),
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
                  fontSize: 14.0,fontFamily: 'IBMPlexSansThai'
                ),
                tabs: [
                  Tab(
                    text: 'พัสดุรอเข้ารับ',  
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
              padding: EdgeInsets.all(5),
              color: Colors.grey[300],
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
                                    // leading: Image.asset(
                                    //   'assets/images/ps01.png',
                                    // ),
                                    title: Text(
                                      'ผู้แจ้งส่ง : ${status[index].uName} ${status[index].uLastname}\nวันที่แจ้งส่ง : ${formatter.format(orDate)}\nเวลาที่แจ้งส่ง : ${status[index].orTime}',
                                    ),
                                    subtitle: Text(
                                      'จำนวนพัสดุที่แจ้งส่ง : ${status[index].orNum} กล่อง',
                                    ),
                                    trailing: Image.asset(
                                      'assets/images/ps01.png',
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(context, '/orderdetail',
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
                                            'u_name': status[index].uName,
                                            'u_lastname': status[index].uLastname,
                                            'u_tel' : status[index].uTel,
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
                                  SizedBox(
                                    height: 5,
                                  )
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
                    child: check.length <= 0
                    ? Container(
                      padding: EdgeInsets.only(right: 120, left: 120,top: 20),
                      child: Opacity(
                        opacity : 0.5,
                        child: Column(
                            children: [
                              Image.asset('assets/images/noorder.png'),
                              Text('ยังไม่มีรายการเข้ารับ',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),)
                            ],
                          )),
                    ) :
                    Container(
                    child: ListView.builder(
                      itemCount: check.length,
                      itemBuilder: (context, index) {
                        DateTime orDate =
                            DateTime.parse('${check[index].orDate}');
                        return Card(
                          child: Column(
                            children: [
                              ListTile(
                                // leading: Image.asset('assets/images/ps01.png'),
                                title: Text(
                                  'ผู้แจ้งส่ง : ${check[index].uName} ${check[index].uLastname}\nวันที่เข้ารับ : ${formatter.format(orDate)}\nเวลาที่เข้ารับ : ${check[index].checkTime}',
                                ),
                                subtitle: Text(
                                  'จำนวนพัสดุที่รับ : ${check[index].checkNum} กล่อง',
                                ),
                                trailing: Image.asset('assets/images/ps01.png'),
                                onTap: () {
                                  Navigator.pushNamed(context, '/orderreceived',
                                      arguments: {
                                        'or_id': check[index].orId,
                                        // 'or_sale': datamember[index].orSale,
                                        'or_date': check[index].orDate,
                                        'or_time': check[index].orTime,
                                        'or_num': check[index].orNum,
                                        'or_status': check[index].orStatus,
                                        'or_address': check[index].orAddress,
                                        'or_office': check[index].orOffice,
                                        'or_detail': check[index].orDetail,
                                        'or_lat': check[index].orLat,
                                        'or_lng': check[index].orLng,
                                        'or_img': orimg,
                                        'check_id': check[index].checkId,
                                        'check_date': check[index].checkDate,
                                        'check_time': check[index].checkTime,
                                        'check_num': check[index].checkNum,
                                        'u_name': check[index].uName,
                                        'u_lastname': check[index].uLastname,
                                        'u_tel' : check[index].uTel,
                                        'ps_name': check[index].psName,
                                        'ps_lastname': check[index].psLastname,
                                      }).then((onGoBack));
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 18),
                                child: Row(
                                  children: [
                                    Text(
                                      'สถานะ : ',
                                      style: TextStyle(color: Colors.grey[600],fontSize: 15),
                                    ),
                                    _status1(context, check[index].orStatus)
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        );
                      },
                      // separatorBuilder: (context, index) => Divider(
                      //   color: Colors.grey,
                      // ),
                    ),
                  )
                  ),
                  // Tab ส่งแล้ว
                  Container(
                    child: sent.length <= 0
                    ? Container(
                      padding: EdgeInsets.only(right: 120, left: 120,top: 20),
                      child: Opacity(
                        opacity : 0.5,
                        child: Column(
                            children: [
                              Image.asset('assets/images/noorder.png'),
                              Text('ยังไม่มีรายการนำส่ง',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),)
                            ],
                          )),
                    ) :
                    Container(
                    child: ListView.builder(
                      itemCount: sent.length,
                      itemBuilder: (context, index) {
                        DateTime orDate =
                            DateTime.parse('${sent[index].sentDate}');
                        return Card(
                          child: Column(
                            children: [
                              ListTile(
                                // leading: Image.asset('assets/images/ps01.png'),
                                title: Text(
                                  'ผู้แจ้งส่ง : ${sent[index].uName} ${sent[index].uLastname}\nวันที่นำส่ง : ${formatter.format(orDate)}\nเวลานำส่ง : ${sent[index].sentTime}',
                                ),
                                subtitle: Text(
                                  'จำนวนพัสดุที่ส่ง : ${sent[index].sentNum} กล่อง',
                                ),
                                trailing: Image.asset('assets/images/ps01.png'),
                                onTap: () {
                                  Navigator.pushNamed(context, '/ordersent',
                                      arguments: {
                                        'or_id': sent[index].orId,
                                        'check_id': sent[index].checkId,
                                        'sent_id':sent[index].sentId,
                                        'sent_date': sent[index].sentDate,
                                        'sent_time': sent[index].sentTime,
                                        'sent_num': sent[index].sentNum,
                                        'or_date': sent[index].orDate,
                                        'or_time': sent[index].orTime,
                                        'or_num': sent[index].orNum,
                                        'or_status': sent[index].orStatus,
                                        'or_address': sent[index].orAddress,
                                        'or_office': sent[index].orOffice,
                                        'or_detail': sent[index].orDetail,
                                        'or_lat': sent[index].orLat,
                                        'or_lng': sent[index].orLng,
                                        'u_name': sent[index].uName,
                                        'u_lastname': sent[index].uLastname,
                                        'u_tel' : sent[index].uTel,
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
                              SizedBox(
                                height: 5,
                              )
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        );
                      },
                      // separatorBuilder: (context, index) => Divider(
                      //   color: Colors.grey,
                      // ),
                    ),
                  )),
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
}