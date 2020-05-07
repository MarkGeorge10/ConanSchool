import 'package:conanschool/AuthenticationPackage/ProfilePage.dart';
import 'package:conanschool/CategoryPackage/CategoryPage.dart';
import 'package:flutter/material.dart';

import '../SearchPage.dart';
import 'HomePage.dart';

// ignore: must_be_immutable
class MasterPage extends StatefulWidget {
  String id;
  int pagenumber;
  MasterPage({this.id, this.pagenumber});
  @override
  _MasterPageState createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  PageController _pageController;

  AnimationController animationController;

  Future<String> getPref() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String name, email, logo;
//    name = Preference.getName();
//    email = Preference.getEmail();
//    logo = Preference.getLogo();
//
//    if (name == null) {
//      name = "";
//    } else if (email == null) {
//      email = "";
//    } else if (logo == null) {
//      logo = "";
//    }
//
//    return name + " " + email;
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this.widget.pagenumber = page;
    });
  }

  // ignore: non_constant_identifier_names, missing_return

  @override
  Widget build(BuildContext context) {
    if (widget.pagenumber == null) {
      widget.pagenumber = 0;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        brightness: Brightness.dark,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Conan School",
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          //MasterPage(),
          HomePage(),
          CategoryPage(),
          SearchPage(),
          ProfilePage(),
        ],
      ),
      drawer: buildDrawer(),

      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 7),
            IconButton(
              icon: Icon(
                Icons.home,
                size: 24.0,
              ),
              color: widget.pagenumber == 0 ? Colors.blue[700] : Colors.grey,
              onPressed: () => _pageController.jumpToPage(0),
            ),
            SizedBox(width: 7),
            IconButton(
              icon: Icon(
                Icons.category,
                size: 24.0,
              ),
              color: widget.pagenumber == 1 ? Colors.blue[700] : Colors.grey,
              onPressed: () => _pageController.jumpToPage(1),
            ),
            SizedBox(
              height: 25.0,
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                size: 24.0,
              ),
              color: widget.pagenumber == 2 ? Colors.blue[700] : Colors.grey,
              onPressed: () => _pageController.jumpToPage(2),
            ),
            SizedBox(
              height: 25.0,
            ),
            IconButton(
              icon: Icon(
                Icons.person,
                size: 24.0,
              ),
              color: widget.pagenumber == 3 ? Colors.blue[700] : Colors.grey,
              onPressed: () => _pageController.jumpToPage(3),
            ),
            SizedBox(
              width: 7,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawer() {
    return Container(
      child: Drawer(
        child: new ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                "Header ",
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: Text("Ayman Samuel shafik",
                  style: TextStyle(color: Colors.white)),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundColor: Colors.grey,
                ),
              ),
              decoration: new BoxDecoration(color: Colors.blue[800]),
            ),

            //body of the drawer
            InkWell(
              onTap: () {
                //Navigator.pushNamed(context, '/Categories');
                Navigator.pop(context);
                _pageController.jumpToPage(0);
              },
              child: ListTile(
                title: Text("Home Page"),
                leading: Icon(Icons.home, color: Colors.blue[700]),
              ),
            ),

            InkWell(
              onTap: () {
                //Navigator.pushNamed(context, '/Categories');
                Navigator.pop(context);
                _pageController.jumpToPage(3);
              },
              child: ListTile(
                title: Text("Profile Page"),
                leading: Icon(Icons.person, color: Colors.blue[700]),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.pop(context);
                _pageController.jumpToPage(1);
              },
              child: ListTile(
                title: Text("Categories"),
                leading: Icon(Icons.category, color: Colors.blue[700]),
              ),
            ),

            InkWell(
              onTap: () async {
//                SharedPreferences prefs =
//                await SharedPreferences.getInstance();
//                prefs.clear();
//                await auth.signOut();
//                Navigator.pushAndRemoveUntil(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => LoginPage()),
//                    ModalRoute.withName('/MasterPage'));
              },
              child: ListTile(
                title: Text("LogOut"),
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.blue[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
