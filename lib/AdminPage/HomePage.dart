import 'package:admin_project/AdminPage/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Future _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        (Route<dynamic> route) => false);
    _showSnack();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แอปพลิเคชันบริการรับฝากส่งพัสดุ', 
        style: TextStyle(color: Theme.of(context).primaryColorDark,)),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: () {
              return showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          size: 30,
                          color: Colors.red,
                        ),
                        Expanded(
                          child: Text('ต้องการออกจากระบบ'),
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
                          _logOut();
                        },
                      ),
                    ],
                  ));
            },
            tooltip: 'ออกจากระบบ',
          ),
        ],
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.7,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20,),
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('assets/images/Logo.png'),
                  ),
                  // SizedBox(height: 20),
                  // Text('แอปพลิเคชันบริการรับฝากส่งพัสดุ',
                  //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  // ),
                ],
              ),
          ),
          FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.7,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              child: panelBody(),
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView panelBody() {
    double hPadding = 35;
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 5),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  // << Grid Dashboard
                  child: GridView.count(
                    // scrollDirection: Axis.vertical,
                    // shrinkWrap: true,
                    childAspectRatio: 1.0,
                    padding: EdgeInsets.all(10),
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    primary: true,
                    children: [
                      GridMenu(
                        press: () {
                          Navigator.pushNamed(context, '/orderlist');
                        },
                        img: 'assets/images/ps01.png',
                        // icon: Icons.ac_unit_outlined,
                        title: "รายการแจ้งส่งพัสดุ",
                        // subtitle: "subtitle",
                      ),
                      GridMenu(
                        press: () {
                          Navigator.pushNamed(context, '/showdata');
                        },
                        img: 'assets/images/save.png',
                        // icon: Icons.ac_unit_outlined,
                        title: "บันทึกข้อมูลการส่ง",
                        // subtitle: "subtitle",
                      ),
                      GridMenu(
                        press: () {
                          Navigator.pushNamed(context, '/payment');
                        },
                        img: 'assets/images/dollar.png',
                        // icon: Icons.ac_unit_outlined,
                        title: "ข้อมูลการชำระเงิน",
                        // subtitle: "subtitle",
                      ),
                      GridMenu(
                        press: () {
                          Navigator.pushNamed(context, '/history');
                        },
                        img: 'assets/images/his.png',
                        // icon: Icons.ac_unit_outlined,
                        title: "ประวัติการส่ง",
                        // subtitle: "subtitle",
                      ),
                      GridMenu(
                        press: () {
                          Navigator.pushNamed(context, '/personlist');
                        },
                        img: 'assets/images/person.png',
                        // icon: Icons.ac_unit_outlined,
                        title: "ข้อมูลพนักงานรับส่ง",
                        // subtitle: "subtitle",
                      ),
                      GridMenu(
                        press: () {
                          Navigator.pushNamed(context, '/userlist');
                        },
                        img: 'assets/images/user.png',
                        // icon: Icons.ac_unit_outlined,
                        title: "ข้อมูลลูกค้า",
                        // subtitle: "subtitle",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
                child: Text('ออกจากระบบสำเร็จ'),
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
} //class

//  Grid Menu Dashboard
class GridMenu extends StatelessWidget {
  const GridMenu({
    Key key,
    @required this.press,
    @required this.img,
    // @required this.icon,
    @required this.title,
    // @required this.subtitle,
  }) : super(key: key);

  final VoidCallback press;
  final String img;
  // final icon;
  final String title;
  // final String subtitle;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: press,
      child: Card(
        elevation: 5,
        color: Theme.of(context).primaryColorLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              img,
              width: 80,
            ),
            // Icon(icon),
            SizedBox(height: 3),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
