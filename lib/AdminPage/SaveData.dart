import 'package:admin_project/Widgets/Show_progress.dart';
import 'package:admin_project/model/Connectapi.dart';
import 'package:admin_project/model/FormField.dart';
import 'package:admin_project/model/OrderImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

class Savedata extends StatefulWidget {
  // Savedata({Key key}) : super(key: key);

  @override
  _SavedataState createState() => _SavedataState();
}

class _SavedataState extends State<Savedata> {
  final _formkey = GlobalKey<FormState>();
  final _sentsale = TextEditingController();
  ScrollController _controller = ScrollController();

  var _orid;
  var _sentid;
  var _sentnum;
  var _sentdate;
  var _senttime;
  var _oraddress;
  var _orstatus;
  var _uname;
  var _ulastname;
  var _psname;
  var _pslastname;
  var change = '3';
  var _Status2 = 'รอบันทึกข้อมูล';

  List<RecipeFormField> _fields = [
    RecipeFormField(
        index: -1,
        savetrack: TextEditingController(),
        savename: TextEditingController(),
        savesale: TextEditingController())
  ];

  // Getorderimage _orImg;
  bool load = true;
  var formatter = DateFormat('dd/MM/y');
  var formattime = DateFormat('HH:mm');

  Map<String, dynamic> _rec_order;
  var token;
  // var uId;

  Future gettoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // print('token = $token');
  }

  Future getInfo() async {
    // รับค่า
    _rec_order = ModalRoute.of(context).settings.arguments;
    _orid = _rec_order['or_id'];
    _sentid = _rec_order['sent_id'];
    _sentnum = _rec_order['sent_num'];
    _sentdate = _rec_order['sent_date'];
    _senttime = _rec_order['sent_time'];
    _oraddress = _rec_order['or_address'];
    _orstatus = _rec_order['or_status'];
    _uname = _rec_order['u_name'];
    _ulastname = _rec_order['u_lastname'];
    _psname = _rec_order['ps_name'];
    _pslastname = _rec_order['ps_lastname'];
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
    if (response.statusCode == 200) {
      print('Update Success');
      // Navigator.pop(context, true);
    } else {
      print('Update Fail');
    }
  }

  // update status
  Future<void> _savetotal(Map<String, dynamic> values) async {
    var url = '${Connectapi().domain}/savetotal/$_sentid';
    var response = await http.put(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: convert.jsonEncode(values));
    if (response.statusCode == 200) {
      print('Save Success');
      // Navigator.pop(context, true);
    } else {
      print('Save Fail');
    }
  }

  // save data
  void _Savetrack(Map<String, dynamic> values) async {
    String url = '${Connectapi().domain}/Savetrack';
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: convert.jsonEncode(values));

    if (response.statusCode == 200) {
      print('savetrack Success');
      // _showSnack();
      // Navigator.pop(context, true);
    } else {
      print('savetrack not Success');
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    getInfo();
    gettoken();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'บันทึกข้อมูลการส่ง',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
              icon: Icon(
                Icons.check_circle_rounded,
                size: 40,
                color: Colors.black,
              ),
              onPressed: () {
                listDialog();
              }),
          SizedBox(
            width: 10,
          )
        ],
      ),
      backgroundColor: Colors.grey[300],
      body: DraggableScrollbar.arrows(
        controller: _controller,
        child: ListView.builder(
            controller: _controller,
            itemCount: 1,
            itemBuilder: (context, index) {
              return buildCenter();
            }),
        backgroundColor: Colors.grey[800],
        labelConstraints: BoxConstraints.tightFor(width: 80, height: 40),
        // labelTextBuilder: (double offset)=> Text('${offset ~/ }'),
        // alwaysVisibleScrollThumb: true,
        heightScrollThumb: 48.0,
      ),

      // ),
      floatingActionButton: FloatingActionButton.extended(
          label: Text(
            'เพิ่มตาราง',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          foregroundColor: Colors.black,
          // icon: const Icon(Icons.thumb_up),
          backgroundColor: Colors.amber,
          onPressed: () {
            setState(() {
              _fields.add(RecipeFormField(
                  index: _fields.length - 1,
                  savetrack: TextEditingController(),
                  savename: TextEditingController(),
                  savesale: TextEditingController()));
            });
            print(_fields.length);
          }

          // foregroundColor: Colors.white,
          ),
    );
  }

  Widget buildCenter() {
    DateTime checkDate = DateTime.parse(_sentdate);
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Form(
            key: _formkey,
            child: Center(
              child: Column(
                children: [
                  Card(
                    child: Container(
                        // alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('ผู้แจ้งส่ง : ',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey[600])),
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
                                        Divider(
                                          color: Colors.grey,
                                          thickness: 1,
                                          endIndent: 10,
                                          indent: 10,
                                          height: 20,
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
                                                          color: Colors
                                                              .grey[600])),
                                                  Text(
                                                      '${formatter.format(checkDate)}',
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color:
                                                              Colors.black87))
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
                                                          color: Colors
                                                              .grey[600])),
                                                  Text('${formattime.format(checkDate)}',
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color:
                                                              Colors.black87))
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
                                                          color: Colors
                                                              .grey[600])),
                                                  Text('${_sentnum} กล่อง',
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color:
                                                              Colors.black87))
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
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('สถานะ : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[600])),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            _status(context, _orstatus)
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              elevation: 10,
                            ),
                            // SizedBox(
                            //   height: 5,
                            // ),
                            checksale()
                          ],
                        )),
                    // elevation: 10,
                  ),

                  // image(),
                  // Container(
                  //   height:
                  //       MediaQuery.of(context).size.height * 0.25,
                  //   width:
                  //       MediaQuery.of(context).size.height * 0.25,
                  //   child: buildGridView(),
                  Container(
                    child: Column(
                      children: <Widget>[
                        for (final field in _fields)
                          RecipeTextField(
                            field: field,
                            onRemove: (int position) {
                              setState(() {
                                _fields.removeAt(position);
                                print(_fields.length);
                              });
                            },
                          ),
                      ],
                    ),
                  ),

                  // Card(
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Column(
                  //       children: [
                  //         // total(),
                  //         SizedBox(
                  //           height: 30,
                  //         ),
                  //         btnSubmit(),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _status(BuildContext context, orderStatus) {
    Widget child;
    if (orderStatus != '2') {
      child =
          Text(_Status2, style: TextStyle(fontSize: 16, color: Colors.blue));
    } else {}
    return new Container(child: child);
  }

  Future listDialog() async {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.check_circle, size: 30, color: Colors.green),
                  Expanded(
                    child: Text('บันทึกข้อมูลทั้งหมด'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'ไม่ใช่',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  onPressed: () => Navigator.pop(context, '/personlist'),
                ),
                TextButton(
                  child: Text(
                    'ใช่',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  onPressed: () {
                    if (_formkey.currentState.validate()) {
                      changeStatus();
                      Save();
                      int count = 0;
                      Navigator.of(context).popUntil((_) => count++ >= 2);
                    }
                  },
                ),
              ],
            ));
  }

  Widget checksale() {
    return TextFormField(
      controller: _sentsale,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 20.0, 10.0, 20.0),
        hintText: 'ราคารวมค่าจัดส่ง',
        hintStyle: TextStyle(fontSize: 17),
        icon: Icon(Icons.paid_outlined, size: 30),

        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(10.0),
        // ),
      ),
      validator: (values) {
        if (values.isEmpty) return 'กรุณากรอกราคารวม';
      },
    );
  }

  Future changeStatus() {
    Map<String, dynamic> maps = Map();
    maps['or_status'] = change;
    maps['sent_sale'] = _sentsale.text;
    print(maps);
    _updatestatus(maps);
    _savetotal(maps);
  }

  Future Save() {
    List<RecipeFormField> list = _fields;
    for (var i = 0; i < list.length; i++) {
      Map<String, dynamic> valuse = Map();
      valuse['track_name'] = list[i].savename.text;
      valuse['track_num'] = list[i].savetrack.text;
      valuse['track_sale'] = list[i].savesale.text;
      valuse['or_id'] = _orid;
      print(valuse);
      _Savetrack(valuse);
    }
  }
}

class RecipeTextField extends StatefulWidget {
  final RecipeFormField field;

  final Function(int) onRemove;

  const RecipeTextField({
    this.field,
    this.onRemove,
  });

  @override
  _RecipeTextField createState() => _RecipeTextField();
}

class _RecipeTextField extends State<RecipeTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Text(
                      '${widget.field.index + 2}',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              // elevation: 0,
              title: Text('ข้อมูลการส่ง'),
              backgroundColor: Colors.amber,
              centerTitle: true, //title ตรงกลาง
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    widget.onRemove(widget.field.index + 1);
                  },
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              child: TextFormField(
                controller: widget.field.savename,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(5.0, 20.0, 10.0, 20.0),
                  hintText: 'ชื่อผู้รับ',
                  hintStyle: TextStyle(fontSize: 17),
                  icon: Icon(Icons.person_outline, size: 30),
                  // border: OutlineInputBorder(
                  //     borderRadius: BorderRadius.circular(10.0),
                  // ),
                ),
                validator: (values) {
                  if (values.isEmpty) return 'กรุณากรอกชื่อผู้ใช้';
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: TextFormField(
                controller: widget.field.savetrack,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(5.0, 20.0, 10.0, 20.0),
                  hintText: 'เลขพัสดุ',
                  hintStyle: TextStyle(fontSize: 17),
                  icon: Icon(Icons.confirmation_number_outlined, size: 30),
                  // border: OutlineInputBorder(
                  //     borderRadius: BorderRadius.circular(10.0),
                  // ),
                ),
                validator: (values) {
                  if (values.isEmpty) return 'กรุณากรอกชื่อผู้ใช้';
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
              child: TextFormField(
                controller: widget.field.savesale,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(5.0, 20.0, 10.0, 20.0),
                  hintText: 'ราคา',
                  hintStyle: TextStyle(fontSize: 17),
                  icon: Icon(Icons.paid_outlined, size: 30),
                  // border: OutlineInputBorder(
                  //     borderRadius: BorderRadius.circular(10.0),
                  // ),
                ),
                validator: (values) {
                  if (values.isEmpty) return 'กรุณากรอกชื่อผู้ใช้';
                },
              ),
            ),
            // Divider(
            //   color: Colors.grey,
            //   thickness: 1,
            // ),
          ],
        ),
      ),
    );
  }
}
