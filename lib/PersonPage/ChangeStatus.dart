import 'package:admin_project/Widgets/Show_progress.dart';
import 'package:admin_project/model/Connectapi.dart';
import 'package:admin_project/model/OrderImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ChangeStatus extends StatefulWidget {
  const ChangeStatus({Key key}) : super(key: key);

  @override
  _ChangeStatusState createState() => _ChangeStatusState();
}

class _ChangeStatusState extends State<ChangeStatus> {
  final _formkey = GlobalKey<FormState>();
  final _checknum = TextEditingController();

  var _Status = 'พัสดุที่ต้องไปรับ';
  var change = '1';

  var _orid;
  var _ordate;
  var _ortime;
  var _ornum;
  var _orstatus;
  var _oraddress;
  var _oroffice;
  var _ordetail;
  var _utel;
  var _uname;
  var _ulastname;

  var formatter = DateFormat('dd/MM/y');
  var formattime = DateFormat('HH:mm');
  Getorderimage _orImg;

  CameraPosition position;
  Position userLocation;
  Set<Marker> _markers = {};
  double _orlat, _orlng;
  bool load = true;
  GoogleMapController mapController;

  Map<String, dynamic> _rec_order;
  var token;
  var psId;

  Future gettoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    psId = prefs.getInt('psid');
    print('psId = $psId');
    print('token = $token');
  }

// check order
  void _checkorder(Map<String, dynamic> values) async {
    String url = '${Connectapi().domain}/checkOrder/$psId';
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: convert.jsonEncode(values));

    if (response.statusCode == 200) {
      print('CheckOrder Success');
      _showSnack();
      // Navigator.pop(context, true);
    } else {
      print('CheckOrder not Success');
      print(response.body);
    }
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
    _orlat = _rec_order['or_lat'];
    _orlng = _rec_order['or_lng'];
    _uname = _rec_order['u_name'];
    _utel = _rec_order['u_tel'];
    _ulastname = _rec_order['u_lastname'];
    print(_orid);
    // print(psId);
  }

  Future<void> _getOrImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // var uId   = prefs.getInt('id');
    // print('uId = $uId');
    print('token = $token');
    var url = '${Connectapi().domain}/getorderimage/$_orid';
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

  Future<void> findLatLan() async {
    Position position = await findPosition();
    setState(() {
      _orlat = position.latitude;
      _orlng = position.longitude;
      // load = false;
    });
    print('lat = $_orlat, lng = $_orlng, load = $load');
  }

  Future<Position> findPosition() async {
    try {
      userLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      userLocation = null;
    }
    return userLocation;
  }

  void _onMapCreated(GoogleMapController controller) {
    // controller.setMapStyle(Utils.mapStyle);
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(_orlat, _orlng),
          infoWindow: InfoWindow(title: '$_orlat, $_orlng'),
        ),
      );
    });
  }

//Upload Images อัพโหลดรูปภาพ =====================
  //ตัวแปรเกี่ยวกับ อัพโหลดรูปภาพ
  // File _image;
  // File _camera;
  // String imgstatus = '';
  // String error = 'Error';
  var filename;
  //multi_image_picker
  Future<String> _multiUploadimage(ast) async {
    var _urlUpload = '${Connectapi().domain}/uploadscheckor/$_orid';
    // ตัวแปรเกี่ยวกับ อัพโหลดรูปภาพ

// create multipart request
    http.MultipartRequest request =
        http.MultipartRequest("PUT", Uri.parse(_urlUpload));
    ByteData byteData = await ast.getByteData();
    List<int> imageData = byteData.buffer.asUint8List();

    http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
      'picture', //key of the api
      imageData,
      filename: 'some-file-name.jpg',
      contentType: MediaType("image",
          "jpg"), //this is not nessessory variable. if this getting error, erase the line.
    );
// add file to multipart
    request.files.add(multipartFile);
// send
    var response = await request.send();
    return response.reasonPhrase;
  }

  //multi_image_picker
  List<Asset> images = <Asset>[];
  Asset asset;
  String _error = 'No Error Dectected';

  // @override
  // void initState() {

  // }

  //สร้าง GridView
  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 1,
      children: List.generate(images.length, (index) {
        return AssetThumb(
          asset: images[index],
          width: 500,
          height: 500,
        );
      }),
    );
  }

  //LoadAssets
  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#FFCC00",
          actionBarTitle: "อัพโหลดรูปภาพ",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      images = resultList;
      print('path : ${images.length}');
      _error = error;
    });
  }

  //Loop รูปภาพ
  Future<void> _sendPathImage() async {
    print('path : ${images.length}');
    for (int i = 0; i < images.length; i++) {
      asset = images[i];
      print('image : $i');
      var res = _multiUploadimage(asset);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getOrImage();
    findLatLan();
  }

  @override
  Widget build(BuildContext context) {
    getInfo();
    gettoken();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('แสดงรายการส่ง', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.amber,
          bottom: TabBar(
            unselectedLabelColor: Colors.black,
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            labelStyle: TextStyle(
              fontSize: 16.0,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14.0,
            ),
            tabs: [
              Tab(
                text: 'รายละเอียด',
              ),
              Tab(
                text: 'ตรวจรับพัสดุ',
              ),
            ],
          ),
        ),
        backgroundColor: Colors.grey[300],
        body: load ? ShowProgress() : buildCenter(),
      ),
    );
  }

  Center buildCenter() {
    DateTime orDate = DateTime.parse(_ordate);
    return Center(
      child: Container(
        padding: EdgeInsets.all(5),
        child: Form(
          key: _formkey,
          child: TabBarView(
            children: [
              SingleChildScrollView(
                  // alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          width: 400,
                          height: 200,
                          child: _OrImage(_orImg.orImg),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('เบอร์โทร : ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[600])),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
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
                                              fontSize: 15,
                                              color: Colors.grey[600])),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Text('จำนวนที่แจ้งส่ง',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey[600])),
                                            Text('${_ornum}',
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
                                              fontSize: 15,
                                              color: Colors.grey[600])),
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
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  // Divider(
                                  //   color: Colors.grey,
                                  //   thickness: 1,
                                  //   endIndent: 10,
                                  //   indent: 10,
                                  //   height: 20,
                                  // ),
                                  ShowMap(),
                                ],
                              )
                            ],
                          ),
                        ),
                        elevation: 10,
                      ),
                      // Card(
                      //   child: Row(
                      //     children: [
                      //       ShowMap(),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       btncancel(),
                      //     ],
                      //   ),
                      // ),,
                    ],
                  )),
              // elevation: 10,
              Card(
                child: Container(
                    // alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        checknum(),
                        SizedBox(
                          height: 10,
                        ),
                        image(),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.height * 0.25,
                          child: buildGridView(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        btnSubmit()
                      ],
                    )),
                // elevation: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget checknum() {
    return TextFormField(
      controller: _checknum,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 20.0, 10.0, 20.0),
        hintText: 'จำนวนพัสดุที่รับ',
        hintStyle: TextStyle(fontSize: 17),
        icon: Icon(Icons.add_circle_outline_sharp, size: 30),

        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(10.0),
        // ),
      ),
      // validator: (values) {
      //   if (values.isEmpty) return 'กรุณากรอกชื่อผู้ใช้';
      // },
    );
  }

  Widget ShowMap() {
    return SizedBox(
      width: 250,
      child: OutlineButton(
        child: Text('นำทาง',
            style: TextStyle(
              fontSize: 14,
            )),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Card(
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(2),
                    color: Colors.black45,
                    height: double.infinity,
                    child: GoogleMap(
                        markers: _markers,
                        onMapCreated: _onMapCreated,
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(_orlat, _orlng),
                          zoom: 17,
                        )),
                  ),
                  SafeArea(
                    child: Padding(
                      // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      padding: const EdgeInsets.only(left: 16, top: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            // borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Card(
                                  color: Colors.white70,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        50), // if you need this
                                    side: BorderSide(
                                      color: Colors.grey[400].withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      // color: Colors.amber
                                      color: Colors.white70,
                                    ),
                                    child: Icon(
                                      CupertinoIcons.arrow_left,
                                      size: 30,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                // Text(
                                //   'ย้อนกลับ',
                                //   style: TextStyle(
                                //       fontSize: 18,
                                //       fontWeight: FontWeight.w500),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }));
        },
      ),
    );
  }

  Widget image() {
    return SizedBox(
      height: 40,
      width: 290,
      child: OutlineButton(
        child: Text('เพิ่มรูปภาพ',
            style: TextStyle(
              fontSize: 18,
            )),
        // Icon(Icons.add_photo_alternate, size: 25),
        onPressed: () {
          loadAssets();
        },
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(10.0),
        // ),
      ),
      // validator: (values) {
      //   if (values.isEmpty) return 'กรุณากรอกชื่อผู้ใช้';
      // },
    );
  }

  Widget btnSubmit() {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: RaisedButton(
        child: Text('ยืนยันการรับพัสดุ', style: TextStyle(fontSize: 20)),
        color: Colors.amber,
        onPressed: () {
          if (_formkey.currentState.validate()) {
            Map<String, dynamic> valuse = Map();
            valuse['check_num'] = _checknum.text;
            valuse['or_id'] = _orid;
            print(_checknum.text);

            _sendPathImage();
            changeStatus();
            _checkorder(valuse);

            // Navigator.pushNamed(context, '');
          }
        },
      ),
    );
  }

  void _showSnack() => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          // action: SnackBarAction(
          //   label: 'Action',
          //   onPressed: () {
          //     // Code to execute.
          //   },
          // ),
          content: Row(
            children: [
              Icon(
                Icons.check,
                color: Colors.white,
                size: 30.0,
              ),
              Expanded(
                child: Text('ยืนยันรับพัสดุสำเร็จ'),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 1700),
          width: 350, // Width of the SnackBar.
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0, // Inner padding for SnackBar content.
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      );

  Future changeStatus() {
    Map<String, dynamic> valuse = Map();
    valuse['or_status'] = change;
    print(valuse);
    _updatestatus(valuse);
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
    if (orderStatus != '0') {
      child = Text(_Status, style: TextStyle(fontSize: 16, color: Colors.red,fontWeight: FontWeight.bold));
    } else {}
    return new Container(child: child);
  }
} //class