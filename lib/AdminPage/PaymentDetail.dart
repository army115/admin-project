import 'package:admin_project/Widgets/Show_progress.dart';
import 'package:admin_project/model/Connectapi.dart';
import 'package:admin_project/model/OrderImage.dart';
import 'package:admin_project/model/Savedata.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PaymentDetail extends StatefulWidget {
  PaymentDetail({Key key}) : super(key: key);

  @override
  _PaymentDetailState createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
  var _sTATUS0 = 'ยังไม่ชำระเงิน';
  var _orId;
  var _sentDate;
  var _sentTime;
  var _sentSale;
  var _sentNum;
  var _sentid;
  var _Usname;
  var _Uslastname;
  var _Psname;
  var _Pslastname;
  var _orAddress;
  var _orStatus;

  var service;
  var total;

  var formatter = DateFormat('dd/MM/y');
  var formattime = DateFormat('HH:mm');

  Getorderimage _orImg;
  bool load = true;

  Map<String, dynamic> _rec_order;
  var token;

  List<Save> track = [];

  Future getInfo() async {
    // รับค่า
    _rec_order = ModalRoute.of(context).settings.arguments;
    _orId = _rec_order['or_id'];
    _sentid = _rec_order['sent_id'];
    _sentDate = _rec_order['sent_date'];
    _sentTime = _rec_order['sent_time'];
    _sentSale = _rec_order['sent_sale'];
    _sentNum = _rec_order['sent_num'];
    _orAddress = _rec_order['or_address'];
    _Usname = _rec_order['u_user'];
    _Uslastname = _rec_order['u_lastname'];
    _Psname = _rec_order['ps_name'];
    _Pslastname = _rec_order['ps_lastname'];
    _orStatus = _rec_order['or_status'];

    service = _sentNum * 1.50;
    total = _sentSale + service;
    print(service);
    print(total);
  }

  Future<void> _getpayImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // var uId = prefs.getInt('id');
    // print('uId = $uId');
    // print('token = $token');
    var url = '${Connectapi().domain}/getorderimage/$_orId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    //check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      OrderImage images =
          OrderImage.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        _orImg = images.getorderimage;
        load = false;
      });
    }
  }

  Future<void> _getShowTrack() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // uId = prefs.getInt('id');
    // print('uId = $uId');
    // print('token = $token');
    var url = '${Connectapi().domain}/ShowSavetrack/$_sentid';
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
        load = false;
      });
    }
  }

  // Future Total() {
  //   List<Save> list = track;
  //   for (var i = 0; i < list.length; i++) {
  //    list = list + track [i].trackSale;
  //     print ('total: $i');
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getpayImage();
    _getShowTrack();
    // _getSumpriceAsem();
  }

  @override
  Widget build(BuildContext context) {
    getInfo();
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
    DateTime orDate = DateTime.parse(_sentDate);
    return Center(
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                width: 400,
                height: 200,
                child: _checkImage(_orImg.orImg),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              // color: Colors.grey[200],
              child: Container(
                // alignment: Alignment.topLeft,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Column(
                      children: [
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
                                Text('ผู้แจ้งส่ง : ',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey[600])),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('${_Usname} ${_Uslastname}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black87,
                                    ))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('พนักงานที่ส่ง : ',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey[600])),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('${_Psname} ${_Pslastname}',
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
                                      Text('วันที่นำส่ง',
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
                                      Text('เวลาที่นำส่ง',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[600])),
                                      Text('${_sentTime}',
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
                                      Text('จำนวนที่ส่ง',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[600])),
                                      Text('${_sentNum} กล่อง',
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
                        // elevation: 10,
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('ค่าบริการรับฝากส่งพัสดุ : ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600])),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('${service} บาท',
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('ราคารวมค่าจัดส่งพัสดุ : ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600])),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('${_sentSale} บาท',
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('ราคารวมสุทธิ : ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600])),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('${total} บาท',
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
                        )
                      ],
                    )
                  ],
                ),
              ),
              elevation: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget list() {
    return Container(
      child: ListView.builder(
        itemCount: track.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                ListTile(
                  // leading: Image.asset('assets/images/ps01.png'),
                  title: Text(
                    'ค่าส่งพัสดุ : ${track[index].trackSale}',
                  ),
                ),
              ],
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          );
        },
      ),
    );
  }

  Widget _checkImage(imageName) {
    Widget child;
    print('Imagename : $imageName');
    if (imageName != null
        // || imageName == ''
        ) {
      child = Image.network('${Connectapi().orImageDomain}$imageName');
    } else {
      child = Image.asset('assets/images/noimg.png');
    }
    return new Container(child: child);
  }

  Widget _status(BuildContext context, orStatus) {
    Widget child;
    if (orStatus != '3') {
      child = Text(_sTATUS0, style: TextStyle(fontSize: 16, color: Colors.red));
    } else {}
    return new Container(child: child);
  }
}
