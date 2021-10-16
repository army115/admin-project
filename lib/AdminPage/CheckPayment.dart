import 'package:admin_project/Widgets/Show_progress.dart';
import 'package:admin_project/model/Connectapi.dart';
import 'package:admin_project/model/OrderImage.dart';
import 'package:admin_project/model/PaymentImages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class CheckPayment extends StatefulWidget {
  CheckPayment({Key key}) : super(key: key);

  @override
  _CheckPaymentState createState() => _CheckPaymentState();
}

class _CheckPaymentState extends State<CheckPayment> {
  var _sTATUS0 = 'ชำระเงินแล้ว';
  var _orId;
  var _payId;
  var _payDate;
  var _payTime;
  var _payBank;
  var _paySale;
  var _uName;
  var _uLastname;
  var _orAddress;
  var _orStatus;
  var change = '5';
  var paynon = '3';

  var formatter = DateFormat('dd/MM/y');
  var formattime = DateFormat('HH:mm');

  Getpayimage _payImg;
  bool load = true;

  Map<String, dynamic> _rec_order;
  var token;

  Future gettoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // print('token = $token');
  }

  Future<void> _getpayImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // var uId = prefs.getInt('id');
    // print('uId = $uId');
    // print('token = $token');
    var url = '${Connectapi().domain}/getorderimagePm/$_orId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    //check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      Paymentimage images =
          Paymentimage.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        _payImg = images.getpayimage;
        load = false;
      });
    }
  }

  //Delete
  Future<void> _paynon(Map<String, dynamic> values) async {
    var url = '${Connectapi().domain}/paynon/$_payId';
    var response = await http.delete(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: convert.jsonEncode(values));
    print(values);
    if (response.statusCode == 200) {
      print('Delete Success');
    } else {
      print('Delete Fail');
    }
  }

  // update status
  Future<void> _updatestatus(Map<String, dynamic> values) async {
    var url = '${Connectapi().domain}/updatestatus/$_orId';
    var response = await http.put(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: convert.jsonEncode(values));
    print(values);
    if (response.statusCode == 200) {
      print('Update Success');
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);
      // _showSnack();
    } else {
      print('Update Fail');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getpayImage();
  }

  Future getInfo() async {
    // รับค่า
    _rec_order =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    _orId = _rec_order['or_id'];
    _payId = _rec_order['pay_id'];
    _payDate = _rec_order['pay_date'];
    _payTime = _rec_order['pay_time'];
    _paySale = _rec_order['pay_sale'];
    _payBank = _rec_order['pay_bank'];
    _orAddress = _rec_order['or_address'];
    _uName = _rec_order['u_name'];
    _uLastname = _rec_order['u_lastname'];
    _orStatus = _rec_order['or_status'];
    print(_payId);
  }

  @override
  Widget build(BuildContext context) {
    getInfo();
    gettoken();
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียด', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.grey[300],
      body: load ? ShowProgress() : buildCenter(),
    );
  }

  Center buildCenter() {
    DateTime orDate = DateTime.parse(_payDate);
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Card(
              // color: Colors.grey[200],
              child: Container(
                // alignment: Alignment.topLeft,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          // width: 400,
                          height: 480,
                          child: _payImage(_payImg.payImg),
                        ),
                        Container(
                            // alignment: Alignment.topLeft,
                            child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('ผู้ชำระเงิน : ',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey[600])),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('${_uName} ${_uLastname}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black87,
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text('วันที่ชำระเงิน',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[600])),
                                      Text('${formatter.format(orDate)}',
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black87))
                                    ],
                                  ),
                                  VerticalDivider(
                                    color: Colors.grey,
                                    endIndent: 5,
                                    indent: 5,
                                    thickness: 1,
                                  ),
                                  Column(
                                    children: [
                                      Text('เวลาที่ชำระเงิน',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[600])),
                                      Text('${_payTime}',
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black87))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 1,
                              endIndent: 10,
                              indent: 10,
                              height: 20,
                            ),
                          ],
                        )),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('ยอดที่ชำระ : ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600])),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('${_paySale} บาท',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black87,
                                      ))
                                ],
                              ),
                              // SizedBox(heiht: 10,),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('ธนาคารที่ชำระ : ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600])),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('${_payBank}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black87,
                                      ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('สถานะ : ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600])),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  _status(context, _orStatus)
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [btnpaynon(), btncheckpay()],
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
      ),
    );
  }

  Widget _payImage(imageName) {
    Widget child;
    print('Imagename : $imageName');
    if (imageName != null
        // || imageName == ''
        ) {
      child = Image.network('${Connectapi().payImagesDomain}$imageName');
    } else {
      child = Image.asset('assets/images/noimg.png');
    }
    return new Container(child: child);
  }

  Widget _status(BuildContext context, orStatus) {
    Widget child;
    if (orStatus != '4') {
      child =
          Text(_sTATUS0, style: TextStyle(fontSize: 16, color: Colors.green));
    } else {}
    return new Container(child: child);
  }

  Widget btnpaynon() {
    return SizedBox(
      width: 170,
      height: 40,
      child: RaisedButton(
        child: Text('ชำระเงินไม่ถูกต้อง',
            style: TextStyle(fontSize: 16, color: Colors.white)),
        color: Colors.redAccent,
        onPressed: () {
          return showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Row(
                      children: [
                        Icon(
                          Icons.cancel_rounded,
                          size: 30,
                          color: Colors.red,
                        ),
                        Expanded(
                          child: Text('ยืนยันการตรวจสอบ'),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          'ไม่ใช่',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: Text(
                          'ใช่',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        onPressed: () {
                          Map<String, dynamic> valuse = Map();
                          valuse['or_status'] = paynon;
                          valuse['or_id'] = _payId;
                          _paynon(valuse);
                          _updatestatus(valuse);
                          print(valuse);
                          // int count = 0;
                          // Navigator.of(context).popUntil((_) => count++ >= 2);
                        },
                      ),
                    ],
                  ));
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget btncheckpay() {
    return SizedBox(
      width: 170,
      height: 40,
      child: RaisedButton(
        child: Text('ชำระเงินถูกต้อง',
            style: TextStyle(fontSize: 16, color: Colors.white)),
        color: Colors.greenAccent[700],
        onPressed: () {
          return showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 30,
                          color: Colors.green,
                        ),
                        Expanded(
                          child: Text('ยืนยันการตรวจสอบ'),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          'ไม่ใช่',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: Text(
                          'ใช่',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        onPressed: () {
                          Map<String, dynamic> valuse = Map();
                          valuse['or_status'] = change;
                          print(valuse);
                          _updatestatus(valuse);
                        },
                      ),
                    ],
                  ));
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
