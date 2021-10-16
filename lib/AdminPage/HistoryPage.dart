import 'package:admin_project/model/Connectapi.dart';
import 'package:admin_project/model/History.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HistoryPage extends StatefulWidget {
  HistoryPage({Key key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<His> history = [];
  var token;
  var formatter = DateFormat('dd/MM/y');
  var formattime = DateFormat('HH:mm');

  //Payment (รายการที่ต้องชำระเงิน )
  Future<void> _ShowHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // uId = prefs.getInt('id');
    // print('uId = $uId');
    print('token = $token');
    var url = '${Connectapi().domain}/Showhistory';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

//check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      History members = History.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        history = members.his;
        // load = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //call _getAPI
    _ShowHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('ประวัติรายการแจ้งส่ง'),
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        color: Colors.grey[300],
        child: history.length <= 0
            ? Container(
                padding: EdgeInsets.only(right: 120, left: 120, top: 20),
                child: Opacity(
                    opacity: 0.5,
                    child: Column(
                      children: [
                        Image.asset('assets/images/order.png'),
                        Text(
                          'ยังไม่มีประวัติการส่ง',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        )
                      ],
                    )),
              )
            : Container(
                child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    DateTime orDate =
                        DateTime.parse('${history[index].payDate}');
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
                                'ชื่อผู้ส่ง : ${history[index].uName} ${history[index].uLastname}\nวันที่ : ${formatter.format(orDate)}\nเวลา : ${history[index].orTime}',
                              ),
                              subtitle: Text(
                                'จำนวนพัสดุ : ${history[index].orNum}\nราคารวม : ${history[index].paySale}',
                              ),
                              trailing: Image.asset(
                                'assets/images/his.png',
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, '/historydetail',
                                    arguments: {
                                      'u_name': history[index].uName,
                                      'u_lastname': history[index].uLastname,
                                      'or_id': history[index].orId,
                                      'or_detail': history[index].orDetail,
                                      'or_address': history[index].orAddress,
                                      'or_office': history[index].orOffice,
                                      'or_status': history[index].orStatus,
                                      'or_date': history[index].orDate,
                                      'or_time': history[index].orTime,
                                      'or_num': history[index].orNum,
                                      'pay_date': history[index].payDate,
                                      'pay_time': history[index].payTime,
                                      'pay_num': history[index].payNum,
                                      'pay_sale': history[index].paySale,
                                      'pay_bank': history[index].payBank,
                                    });
                              },
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 95),
                            //   child: Row(
                            //     children: [
                            //       Text(
                            //         'สถานะ : ',
                            //         style: TextStyle(color: Colors.grey[600]),
                            //       ),
                            //       _status0(context, status?[index].orStatus)
                            //     ],
                            //   ),
                            // ),
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
    );
  }
}
