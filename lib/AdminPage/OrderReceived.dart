import 'package:admin_project/Widgets/Show_progress.dart';
import 'package:admin_project/model/CheckImages.dart';
import 'package:admin_project/model/Connectapi.dart';
import 'package:admin_project/model/OrderImage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class OrderReceived extends StatefulWidget {
  const OrderReceived({Key key}) : super(key: key);

  @override
  _OrderReceivedState createState() => _OrderReceivedState();
}

class _OrderReceivedState extends State<OrderReceived> {
  final _formkey = GlobalKey<FormState>();

  var _Status = 'เข้ารับพัสดุแล้ว';

  var _orid;
  var _ordate;
  var _ortime;
  var _ornum;
  var _orstatus;
  var _oraddress;
  var _oroffice;
  var _ordetail;
  var _uname;
  var _ulastname;
  var _utel;
  var _psname;
  var _pslastname;
  var _checknum;
  var _checkdate;
  var _checktime;

  var formatter = DateFormat('dd/MM/y');
  var formattime = DateFormat('HH:mm');
  GetCheckimage _CheckImg;
  bool load = true;
  GoogleMapController mapController;

  Map<String, dynamic> _rec_order;
  var token;
  var _checkId;

  Future<void> getInfo() async {
    // รับค่า
    _rec_order = ModalRoute.of(context).settings.arguments;
    _orid = _rec_order['or_id'];
    _ordate = _rec_order['or_date'];
    _ortime = _rec_order['or_time'];
    _ornum = _rec_order['or_num'];
    _orstatus = _rec_order['or_status'];
    _oraddress = _rec_order['or_address'];
    _oroffice = _rec_order['or_office'];
    _ordetail = _rec_order['or_detail'];
    _uname = _rec_order['u_name'];
    _ulastname = _rec_order['u_lastname'];
    _utel = _rec_order['u_tel'];
    _psname = _rec_order['ps_name'];
    _pslastname = _rec_order['ps_lastname'];
    _checkId = _rec_order['check_id'];
    _checknum = _rec_order['check_num'];
    _checkdate = _rec_order['check_date'];
    _checktime = _rec_order['check_time'];
  }

  // update status
  Future<void> _updatestatus(Map<String, dynamic> values) async {
    var url = '${Connectapi().domain}/updatestatus/$_orid';
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
      Navigator.pop(context, true);
    } else {
      print('Update Fail');
    }
  }

  Future<void> _getCheckImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // var uId = prefs.getInt('id');
    // print('uId = $uId');
    print('token = $token');
    var url = '${Connectapi().domain}/getCheckimage/$_checkId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    //check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      CheckImages images =
          CheckImages.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        _CheckImg = images.getCheckimage;
        load = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCheckImage();
  }

  @override
  Widget build(BuildContext context) {
    getInfo();
    return Scaffold(
      appBar: AppBar(
        title: Text('แสดงรายละเอียด', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.grey[300],
      body: load ? ShowProgress() : buildCenter(),
    );
  }

  Center buildCenter() {
    DateTime orDate = DateTime.parse(_ordate);
    DateTime checkDate = DateTime.parse(_checkdate);
    return Center(
      child: Container(
        padding: EdgeInsets.all(5),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
              child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  width: 400,
                  height: 200,
                  child: _OrImage(_CheckImg.orImg),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  // alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Column(
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
                              Text('${_uname} ${_ulastname}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black87,
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('เบอร์โทร : ',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey[600])),
                              SizedBox(
                                width: 10,
                              ),
                              Text('${_utel}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black87,
                                  ))
                            ],
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                            endIndent: 10,
                            indent: 10,
                            height: 20,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text('วันที่แจ้งส่ง',
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
                                    Text('เวลาที่แจ้งส่ง',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[600])),
                                    Text('${_ortime}',
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
                          Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text('ที่อยู่ที่แจ้งเข้ารับ',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey[600])),
                              Text('${_oraddress}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black87,
                                  ))
                            ],
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                            endIndent: 10,
                            indent: 10,
                            height: 20,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text('จำนวนที่แจ้งส่ง',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[600])),
                                    Text('${_ornum} กล่อง',
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
                                    Text('บริษัทขนส่งที่เลือก',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[600])),
                                    Text('${_oroffice}',
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('รายละเอียดเพิ่มเติม : ',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey[600])),
                              SizedBox(
                                width: 10,
                              ),
                              Text('${_ordetail}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black87,
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('สถานะ : ',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[600])),
                              SizedBox(
                                width: 10,
                              ),
                              _status(context, _orstatus)
                            ],
                          ),
                          // Divider(
                          //   color: Colors.grey,
                          //   thickness: 1,
                          //   endIndent: 10,
                          //   indent: 10,
                          //   height: 20,
                          // ),
                        ],
                      )
                    ],
                  ),
                ),
                elevation: 10,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                    // alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                            width: 400,
                            height: 200,
                            child: _checkImage(_CheckImg.checkImg)),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('พนักงานที่เข้ารับ : ',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey[600])),
                            SizedBox(
                              width: 10,
                            ),
                            Text('${_psname} ${_pslastname}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black87,
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text('วันที่เข้ารับ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600])),
                                  Text('${formatter.format(checkDate)}',
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.black87))
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
                                  Text('เวลาเข้ารับ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600])),
                                  Text('${_checktime}',
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.black87))
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
                                  Text('จำนวนที่รับ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600])),
                                  Text('${_checknum}',
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.black87))
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
              ),
            ],
          )),
        ),
      ),
    );
  }

  // Widget btnSubmit() {
  //   return SizedBox(
  //     width: double.infinity,
  //     height: 45,
  //     child: RaisedButton(
  //       child: Text('ยืนยันการส่งพัสดุ', style: TextStyle(fontSize: 20)),
  //       color: Colors.amber,
  //       onPressed: () {
  //         Map<String, dynamic> valuse = Map();
  //         valuse['or_status'] = change;
  //         print(valuse);
  //         _updatestatus(valuse);
  //       },
  //     ),
  //   );
  // }

  Widget _checkImage(imageNameCheck) {
    Widget child;
    print('imageNameCheck : $imageNameCheck');
    if (imageNameCheck != null
        // || imageName == ''
        ) {
      child = Image.network('${Connectapi().checkImagesDomain}$imageNameCheck');
    } else {
      child = Image.asset('assets/images/noimg.png');
    }
    return new Container(child: child);
  }

  Widget _OrImage(imageName) {
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

  Widget _status(BuildContext context, orderStatus) {
    Widget child;
    if (orderStatus != '1') {
      child =
          Text(_Status, style: TextStyle(fontSize: 16, color: Colors.blue));
    } else {}
    return new Container(child: child);
  }
} //class
