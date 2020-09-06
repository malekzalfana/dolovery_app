import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';
import 'package:intl/intl.dart';
import 'package:dolovery_app/widgets/recentorder.dart';

class ProfileMainScreen extends StatefulWidget {
  dynamic thisUser;
  // ProfileMainScreen(thisUser);
  ProfileMainScreen({Key key, @required this.thisUser}) : super(key: key);

  // @override
  // ProfileScreenState createState() => new ProfileScreenState();

  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

// String finalDate = '';

getCurrentDate() {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yMMMMd');
  final String formatted = formatter.format(now);

  return formatted; // s
}

var this_user;

class ProfileScreenState extends State<ProfileMainScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name;
  String uid;
  String uemail;
  bool newuser = true;

  Future setupVerification() async {
    print("USER BEING WATCHED");
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      uid = user.uid;
      name = user.displayName;
      uemail = user.email;
      // print("USERNAME")
      this_user =
          await Firestore.instance.collection("users").document(uid).get();

      print(this_user.data['number']);
      print('ss');
      print(widget.thisUser);
      print('ss');

      if (this_user.exists) {
        newuser = false;
      }
    }

    // return this_user;
  }

  @override
  Widget build(BuildContext context) {
    setupVerification();
    setState(() {});
    if (newuser == true) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 28.0),
              child: Image.asset("assets/images/profile_illustration.png",
                  width: 330),
            ),
            Text(
              "Let's Get Started",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23.0,
                fontFamily: 'Axiforma',
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                width: 320,
                // height:200,
                child: Text(
                  "Create and account and get everything you need delivered to your doorstep!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14.0,
                    fontFamily: 'Axiforma',
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(38, 32, 38, 12),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 0,
                onPressed: () {},
                color: Colors.redAccent[700],
                // disabledColor: Colors.grey[200],
                textColor: Colors.white,
                minWidth: MediaQuery.of(context).size.width,
                height: 0,
                // padding: EdgeInsets.zero,
                padding:
                    EdgeInsets.only(left: 33, top: 10, right: 33, bottom: 10),
                child: Text(
                  "Get Started",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    fontFamily: 'Axiforma',
                    // color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Text(
                            widget.thisUser.data['fullname'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 38.0,
                              height: 1.1,
                              fontFamily: 'Axiforma',
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.thisUser.data['email'],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      fontFamily: 'Axiforma',
                      color: Colors.black45,
                    ),
                  ),
                  Text(
                    widget.thisUser.data['number'],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      letterSpacing: 1.1,
                      fontFamily: 'Axiforma',
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, top: 30, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Recent Orders",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                          fontFamily: 'Axiforma',
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder(
                    stream: Firestore.instance.collection('shops').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print(snapshot);
                        return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List<Widget>.generate(3, (int index) {
                                  // print(categories[index]);
                                  return RecentOrder(
                                      orderDate: "12 May, 2020",
                                      orderCount: '3',
                                      orderImage:
                                          'https://cdn.cnn.com/cnnnext/dam/assets/180316113418-travel-with-a-dog-3-full-169.jpeg',
                                      orderPrice: 7500.toString());
                                })));
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, top: 30, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "My Addresses",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                          fontFamily: 'Axiforma',
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  for (var address in widget.thisUser.data["address"])
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 30.0, bottom: 10, left: 30, top: 12),
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2.2,
                                blurRadius: 2.5,
                                offset:
                                    Offset(0, 4), // changes position of shadow
                              ),
                            ],
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        // color: Colors.grey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Image.asset(
                                widget.thisUser.data["address"] ==
                                        address["name"]
                                    ? 'assets/icons/address_enabled.png'
                                    : 'assets/icons/address_disabled.png',
                                height: 30.0,
                                width: 30.0,
                              ),
                            ),
                            Container(
                                // color: Colors.green,
                                margin:
                                    new EdgeInsets.only(left: 10.0, right: 0),
                                child: Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0,
                                                  left: 6,
                                                  bottom: 5),
                                              child: Text(
                                                address["name"],
                                                // textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  fontFamily: 'Axiforma',
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, bottom: 8),
                                                child: Text(
                                                  address["street_address"],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    height: 1.1,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 14.5,
                                                    fontFamily: 'Axiforma',
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 30, bottom: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.grey[200])),
                        onPressed: () {},
                        color: Colors.grey[200],
                        elevation: 0,
                        textColor: Colors.white,
                        minWidth: 0,
                        height: 0,
                        // padding: EdgeInsets.zero,
                        padding: EdgeInsets.only(
                            left: 20, top: 10, right: 20, bottom: 10),
                        child: Text(
                          "Log Out",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0,
                            fontFamily: 'Axiforma',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
