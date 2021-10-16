import 'dart:async';
import 'package:admin_project/AdminPage/AddPerson.dart';
import 'package:admin_project/AdminPage/CheckPayment.dart';
import 'package:admin_project/AdminPage/HistoryPage.dart';
import 'package:admin_project/AdminPage/HistoryDetail.dart';
import 'package:admin_project/AdminPage/HomePage.dart';
import 'package:admin_project/AdminPage/LoginPage.dart';
import 'package:admin_project/AdminPage/OrderDetail.dart';
import 'package:admin_project/AdminPage/OrderPage.dart';
import 'package:admin_project/AdminPage/OrderReceived.dart';
import 'package:admin_project/AdminPage/OrderStatusSent.dart';
import 'package:admin_project/AdminPage/PaymentDetail.dart';
import 'package:admin_project/AdminPage/PaymentPage.dart';
import 'package:admin_project/AdminPage/PersonList.dart';
import 'package:admin_project/AdminPage/PersonPage.dart';
import 'package:admin_project/AdminPage/SaveData.dart';
import 'package:admin_project/AdminPage/Showdata.dart';
import 'package:admin_project/AdminPage/Test.dart';
import 'package:admin_project/AdminPage/Track.dart';
import 'package:admin_project/AdminPage/UpdatePerson.dart';
import 'package:admin_project/AdminPage/UserList.dart';
import 'package:admin_project/AdminPage/UserPage.dart';
import 'package:admin_project/PersonPage/ChangeStatus.dart';
import 'package:admin_project/PersonPage/CheckOrder.dart';
import 'package:admin_project/PersonPage/ProfilePerson.dart';
import 'package:admin_project/PersonPage/StatusReceived.dart';
import 'package:admin_project/PersonPage/StatusSent.dart';
import 'package:admin_project/model/OrderList.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mytheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/homepage': (context) => HomePage(),
        '/userlist': (context) => UserPage(),
        '/orderlist': (context) => OrderPage(),
        '/orderdetail': (context) => OrderDetail(),
        '/personlist': (context) => PersonPage(),
        '/userpage': (context) => UserDetail(),
        '/personpage': (context) => PersonDetail(),
        '/addperson': (context) => AddPerson(),
        '/updateperson': (context) => UpdatePerson(),
        '/profileperson': (context) => ProfilePerson(),
        '/checkorder': (context) => CheckOrder(),
        '/changestatus': (context) => ChangeStatus(),
        '/received': (context) => Received(),
        '/sent': (context) => Sent(),
        '/orderreceived': (context) => OrderReceived(),
        '/ordersent': (context) => OrderStatusSent(),
        '/savedata': (context) => Savedata(),
        '/showdata': (context) => Showdata(),
        '/payment': (context) => PaymentPage(),
        '/paymentdetail': (context) => PaymentDetail(),
        '/checkpayment': (context) => CheckPayment(),
        '/history': (context) => HistoryPage(),
        '/historydetail': (context) => HistoryDetail(),
        '/track' : (context) => Track(),
      },
      // home: NextPAge(),
    );
  }

  ThemeData mytheme() {
    return ThemeData(
      primaryColor: HexColor('#F9B208'),
      // primaryColor: HexColor('#f34dc3'),
      primaryColorLight: HexColor('#F9F9F9'),
      primaryColorDark: HexColor('#1B1A17'),
      // primaryColorDark: HexColor('#6930c3'),
      canvasColor: HexColor('#3DB2FF'),
      errorColor: HexColor('#d90429'),
      backgroundColor: HexColor('#EEEEEE'),
      // scaffoldBackgroundColor: HexColor('#b7efc5'),
      scaffoldBackgroundColor: HexColor('#ffffff'),
      cardColor: HexColor('#fffcf9'),
      // cardColor: HexColor('#f5cb5c'),
      accentColor: HexColor('#0d41e1'),
      fontFamily: 'IBMPlexSansThai',

      appBarTheme: AppBarTheme(
        // centerTitle: true,
        // color: HexColor('#1a1e22'),
        color: HexColor('#ffffff'),
        elevation: 0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: HexColor('#000000'),
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            fontFamily: 'IBMPlexSansThai',
            color: HexColor('#000000'),
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = Duration(seconds: 3);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.orange.shade900, Colors.amber],
                begin: Alignment.topCenter,
                end: Alignment.center)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 20,
              ),
              CircleAvatar(
                radius: 120,
                backgroundImage: AssetImage('assets/images/Logo.png'),
                backgroundColor: Colors.white,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Center(
                    child: LinearProgressIndicator(
                  backgroundColor: Colors.amber,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )),
              ),
              // Center(
              //     child: CircularProgressIndicator(
              //   backgroundColor: Colors.amber,
              //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              // )),
              Image.asset('assets/images/city.png'),
            ],
          ),
        ),
      ),
    );
  }
}
