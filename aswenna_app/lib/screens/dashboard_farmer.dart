import 'package:aswenna_app/screens/product_information_farmer_all.dart';
import 'package:aswenna_app/screens/product_information_farmer_fruit.dart';
import 'package:aswenna_app/screens/product_information_farmer_grains.dart';
import 'package:aswenna_app/screens/product_information_farmer_vehetable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dashboard_customer.dart';
import 'login_screen.dart';

class DashboardFarmer extends StatefulWidget {
  @override
  _DashboardFarmerState createState() => _DashboardFarmerState();
}

class _DashboardFarmerState extends State<DashboardFarmer> {
  //---------------------------------------------------
  int _selectedIndex = 0;
  List _widgetOptions = [
    FarmerProductsAll(),
    FarmerProductsVegetable(),
    FarmerProductsFruit(),
    FarmerProductsGrain(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

//-------------------- sign out  ----------------------------
  Future<LoginScreen> _signOut() async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(),
        ),
        (Route<dynamic> route) => false);
  }
  //-------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: buildAppBar(),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
          ),
          child: Drawer(
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.all(12.0),
                  alignment: AlignmentDirectional.topEnd,
                  child: Image.asset('assets/images/logo.png'),
                ),
                Divider(),
                //---------------- item ------------------

                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Color(0xFF069370),
                  ),
                  title: Text(
                    'Profile',
                    style: TextStyle(
                      color: Color(0xFF069370),
                      fontFamily: 'OpenSans',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                //---------------- item ------------------

                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Color(0xFF069370),
                  ),
                  title: Text(
                    'Home',
                    style: TextStyle(
                      color: Color(0xFF069370),
                      fontFamily: 'OpenSans',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                //---------------- item ------------------

                ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Color(0xFF069370),
                  ),
                  title: Text(
                    'Settings',
                    style: TextStyle(
                      color: Color(0xFF069370),
                      fontFamily: 'OpenSans',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                //---------------- item ------------------

                ListTile(
                  leading: Icon(
                    Icons.help_outline,
                    color: Color(0xFF069370),
                  ),
                  title: Text(
                    'Help',
                    style: TextStyle(
                      color: Color(0xFF069370),
                      fontFamily: 'OpenSans',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                //---------------- item ------------------

                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Color(0xFF069370),
                  ),
                  title: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Color(0xFF069370),
                      fontFamily: 'OpenSans',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    _signOut();
                  },
                ),
                Divider(),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BottomNavigationBar(
                showUnselectedLabels: true,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    backgroundColor: Color(0xFF069370),
                    icon: Icon(
                      Icons.adjust_outlined,
                    ),
                    label: 'All',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.adjust_outlined),
                    label: 'Vegetables',
                    backgroundColor: Color(0xFF069370),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.adjust_outlined),
                    label: 'Fruits',
                    backgroundColor: Color(0xFF069370),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.adjust_outlined),
                    label: 'Grains',
                    backgroundColor: Color(0xFF069370),
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Color(0xFFfed47e),
                onTap: _onItemTapped,
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: _widgetOptions.elementAt(_selectedIndex),
              )
            ],
          ),
        ),
      ),
    );
  }
}
