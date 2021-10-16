import 'package:admin_project/model/Connectapi.dart';
import 'package:admin_project/model/Nonpay.dart';
import 'package:admin_project/model/OrderImage.dart';
import 'package:admin_project/model/Payment.dart';
import 'package:admin_project/model/Savedata.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({Key key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<Non> non = [];
  List<Pay> payment = [];
  Getorderimage orimg;
  // bool load = true;
  var _sTATUS1 = 'ยังไม่ชำระเงิน';
  var _sTATUS2 = 'ชำระเงินแล้ว';

  var token;
  var formatter = DateFormat('dd/MM/y');
  var formattime = DateFormat('HH:mm');

  //Non pay (รายการที่ยังไม่ชำระเงิน )
  Future<void> _ShowSavedata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // var psId = prefs.getInt('psid');
    // print('psId = $psId');
    print('token = $token');
    var url = '${Connectapi().domain}/ShowNonpay';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

//check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      Nonpay members = Nonpay.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        non = members.non;
        // load = false;
      });
    }
  }

    //CheckPayment (รายการชำระเงินแล้ว )
  Future<void> _ShowPayment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // uId = prefs.getInt('id');
    // print('uId = $uId');
    print('token = $token');
    var url = '${Connectapi().domain}/Payment';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

//check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      Payment members =
          Payment.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        payment = members.pay;
        // load = false;
      });
    }
  }

  Future onGoBack(dynamic value) {
    setState(() {
      _ShowSavedata();
      _ShowPayment();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //call _getAPI
    _ShowSavedata();
    _ShowPayment();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.amber,
              title: Text(
                'ชำระเงิน',
                style: TextStyle(color: Colors.black),
              ),
              bottom: TabBar(
                unselectedLabelColor: Colors.black,
                labelColor: Colors.black,
                indicatorColor: Colors.black,
                labelStyle: TextStyle(
                  fontSize: 18.0,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.0,
                ),
                tabs: [
                  Tab(
                    text: 'ยังไม่ชำระเงิน',
                  ),
                  Tab(
                    text: 'ชำระเงินแล้ว',
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.grey[300],
            body: Container(
              color: Colors.grey[300],
              padding: EdgeInsets.all(5),
              child: TabBarView(
                children: [
                  // Tab ยังไม่ชำระเงิน
                  Container(
                    child: non.length <= 0
                    ? Container(
                      padding: EdgeInsets.only(right: 110, left: 110,top: 20),
                      child: Opacity(
                        opacity : 0.5,
                        child: Column(
                            children: [
                              Image.asset('assets/images/nopay.png'),
                              Text('ยังไม่มีรายการชำระเงิน',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),)
                            ],
                          )),
                    ) :
                     Container(
                       child: ListView.builder(
                        itemCount: non.length,
                        itemBuilder: (context, index) {
                          DateTime orDate =
                              DateTime.parse('${non[index].sentDate}');
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    // leading: Image.asset(
                                    //   'assets/images/ps01.png',
                                    // ),
                                    title: Text(
                                      'ผู้แจ้งส่ง : ${non[index].uName} ${non[index].uLastname}\nวันที่ส่งพัสดุ : ${formatter.format(orDate)}\nเวลาที่ส่งพัสดุ : ${non[index].sentTime}'
                                    ),
                                    subtitle: Text(
                                      'จำนวนพัสดุที่ส่ง : ${non[index].sentNum} กล่อง',
                                    ),
                                    trailing: Image.asset(
                                      'assets/images/dollar.png',
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(context, '/paymentdetail',
                                          arguments: {
                                            'or_id': non[index].orId,
                                            'sent_date': non[index].sentDate,
                                            'sent_time': non[index].sentTime,
                                            'sent_num': non[index].sentNum,
                                            'sent_sale': non[index].sentSale,
                                            'sent_id': non[index].sentId,
                                            'u_user': non[index].uName,
                                            'u_lastname': non[index].uLastname,
                                            'ps_name': non[index].psName,
                                            'ps_lastname': non[index].psLastname,
                                            'or_address': non[index].orAddress,
                                            'or_status': non[index].orStatus,
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
                                        _status1(context, non[index].orStatus)
                                      ],
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 5,
                                  // )
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
                  // Tab ชำระเงิน
                  Container(
                    child: payment.length <= 0
                    ? Container(
                      padding: EdgeInsets.only(right: 110, left: 110,top: 20),
                      child: Opacity(
                        opacity : 0.5,
                        child: Column(
                            children: [
                              Image.asset('assets/images/nopay.png'),
                              Text('ยังไม่มีรายการชำระเงิน',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),)
                            ],
                          )),
                    ) :
                     Container(
                       child: ListView.builder(
                        itemCount: payment.length,
                        itemBuilder: (context, index) {
                          DateTime paydate =
                              DateTime.parse('${payment[index].payDate}');
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    // leading: Image.asset(
                                    //   'assets/images/ps01.png',
                                    // ),
                                    title: Text(
                                      'ผู้ชำระเงิน : ${payment[index].uName} ${payment[index].uLastname}\nวันที่ชำระ : ${formatter.format(paydate)}\nเวลาที่ชำระ : ${payment[index].payTime}'
                                    ),
                                    subtitle: Text(
                                      'ยอดที่ชำระ : ${payment[index].paySale} บาท',
                                    ),
                                    trailing: Image.asset(
                                      'assets/images/dollar.png',
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(context, '/checkpayment',
                                          arguments: {
                                            'or_id': payment[index].orId,
                                            'pay_id': payment[index].payId,
                                            'pay_date': payment[index].payDate,
                                            'pay_time': payment[index].payTime,
                                            'pay_bank': payment[index].payBank,
                                            'pay_sale': payment[index].paySale,
                                            'u_name': payment[index].uName,
                                            'u_lastname': payment[index].uLastname,
                                            'or_address': payment[index].orAddress,
                                            'or_status': payment[index].orStatus,
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
                                        _status2(context, payment[index].orStatus)
                                      ],
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 5,
                                  // )
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

      Widget _status1(BuildContext context, orderStatus) {
    Widget child;
    if (orderStatus != '3') {
      child =
          Text(_sTATUS1, style: TextStyle(fontSize: 14, color: Colors.red));
    } else {}
    return new Container(child: child);
  }

  Widget _status2(BuildContext context, orderStatus) {
    Widget child;
    if (orderStatus != '4') {
      child =
          Text(_sTATUS2, style: TextStyle(fontSize: 14, color: Colors.green));
    } else {}
    return new Container(child: child);
  }
}
