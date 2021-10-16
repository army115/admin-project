import 'package:admin_project/AdminPage/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePerson extends StatefulWidget {
  const HomePerson({Key key}) : super(key: key);

  @override
  _HomePersonState createState() => _HomePersonState();
}

class _HomePersonState extends State<HomePerson> {
  @override
  Future _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        (Route<dynamic> route) => false);
    _showSnack();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('แอปพลิเคชันบริการรับฝากส่งพัสดุ', style: TextStyle(color: Colors.black)),
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
      ),
      backgroundColor: Colors.grey[300],
      body: Container(
        child: Stack(fit: StackFit.expand, children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Card(
                    color: Theme.of(context).primaryColor,
                    margin: EdgeInsets.only(bottom: 90),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30)),
                    ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 90,
                            backgroundImage: AssetImage('assets/images/Logo.png'),
                          ),
                        ],
                      ),
                    
                    elevation: 10,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30, left: 10, right: 10),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                padding: EdgeInsets.only(top: 210),
                width: 500,
                height: 600,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      // << Grid Dashboard
                      child: GridView.count(
                        // scrollDirection: Axis.vertical,
                        // shrinkWrap: true,
                        childAspectRatio: 1.0,
                        padding: EdgeInsets.all(20),
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        primary: true,
                        children: [
                          GridMenu(
                            press: () {
                              Navigator.pushNamed(context, '/checkorder');
                            },
                            img: 'assets/images/ps01.png',
                            // icon: Icons.ac_unit_outlined,
                            title: "รายการพัสดุที่ต้องรับ",
                            // subtitle: "subtitle",
                          ),
                          GridMenu(
                            press: () {
                              Navigator.pushNamed(context, '/profileperson');
                            },
                            img: 'assets/images/person.png',
                            // icon: Icons.ac_unit_outlined,
                            title: "โปรไฟล์",
                            // subtitle: "subtitle",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget btnprofile() {
    return SizedBox(
      width: 250,
      height: 40,
      child: RaisedButton(
        child: Text('โปรไฟล์'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, '/profileperson');
        },
      ),
    );
  }

  Widget btnorder() {
    return SizedBox(
      width: 250,
      height: 40,
      child: RaisedButton(
        child: Text('รายการพัสดุที่ต้องรับ'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, '/checkorder');
        },
      ),
    );
  }

  Widget btnstatus() {
    return SizedBox(
      width: 250,
      height: 40,
      child: RaisedButton(
        child: Text('ข้อมูลสถานะพัสดุ'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        onPressed: () {},
      ),
    );
  }

  Widget btnlogout() {
    return SizedBox(
      width: 250,
      height: 40,
      child: RaisedButton(
        child: Text('ออกจากระบบ'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        onPressed: () {
          _logOut();
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
