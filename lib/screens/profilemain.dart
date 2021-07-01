import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dolovery_app/screens/addaddress.dart';
import 'package:dolovery_app/screens/allorders.dart';
import 'package:dolovery_app/screens/editaddress.dart';
import 'package:dolovery_app/screens/editprofile.dart';
import 'package:dolovery_app/screens/orderpage.dart';
import 'package:dolovery_app/screens/profile.dart';
import 'package:dolovery_app/static_screens/privacy.dart';
import 'package:dolovery_app/static_screens/terms.dart';
import 'package:dolovery_app/widgets/recentorder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileMainScreen extends StatefulWidget {
  final Function() notifyParent;

  ProfileMainScreen({Key key, @required this.notifyParent}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

getCurrentDate() {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yMMMMd');
  final String formatted = formatter.format(now);

  return formatted;
}

var this_user;
bool notsetup = true;

class ProfileScreenState extends State<ProfileMainScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name;
  String uid;
  String uemail;
  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Center(
                child: Image.asset("/images/loading.gif"),
              )
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
      Navigator.pop(context);
      showSignIn();
    });
  }

  // void runsetupVerification() {
  //   setupVerification().then((value) => null);
  // }

  void signOut() {
    FirebaseAuth.instance.signOut().then((onValue) {});
  }

  Future<void> _googleSignUp() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

      double welcomeheight;
      final newUser = await Firestore.instance.collection("users").document(user.uid).get();
      if (newUser.exists) {
        notsetup = false;
        welcomeheight = Adaptive.h(50);
      } else {
        notsetup = true;
        welcomeheight = Adaptive.h(55);
      }
      Navigator.of(context).pop();

      _welcomePopUp(context, user.displayName, notsetup, welcomeheight);
      setState(() {
        _readtosignin = true;
      });
      if (!newUser.exists) {}

      return user;
    } catch (e) {
      if (e.message ==
          "An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.") {}
    }
  }

  Future<void> signUpWithFacebook() async {
    try {
      var facebookLogin = new FacebookLogin();
      var result = await facebookLogin.logIn(['email']);

      if (result.status == FacebookLoginStatus.loggedIn) {
        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        );
        final FirebaseUser user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;

        double welcomeheight;
        final newUser = await Firestore.instance.collection("users").document(user.uid).get();
        if (newUser.exists) {
          notsetup = false;
          welcomeheight = 350;
        } else {
          notsetup = true;
          welcomeheight = 400;
        }
        Navigator.of(context).pop();

        _welcomePopUp(context, user.displayName, notsetup, welcomeheight);
        setState(() {
          _readtosignin = true;
        });
        return user;
      }
    } catch (e) {
      if (e.message ==
          "An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.") {
        showError("An account already exists with the same email address, try using Google to sign in.");
      }
      setState(() {
        showerrortextbool = true;
      });
    }
  }

  bool showerrortextbool = false;
  void _welcomePopUp(context, name, bool notsetup, double welcomeheight) {
    Future<void> future = showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            height: welcomeheight,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.grey,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          showerrortextbool = false;
                        });
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Image.asset(
                    'assets/images/doloverywhiteback.png',
                    width: 120.0,
                  ),
                ),
                Text(
                  "Welcome",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black,
                  ),
                ),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 28.0,
                    fontFamily: 'Axiforma',
                    color: Colors.redAccent[700],
                  ),
                ),
              ],
            ),
          );
        });
    future.then((void value) => setState(() {}));
  }

  resetEverything() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('type');
    prefs.remove('total');
    prefs.remove('items');
    prefs.remove('cart');
    prefs.remove('shops');
    prefs.remove('usercartmap');
    prefs.remove('usercartmap_v2');
    prefs.remove('cached_shops');
    prefs.remove('address');
    prefs.remove('addresses');
  }

  _showLogoutDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text(
                "Are your sure you want to sign out?",
                style: TextStyle(fontSize: Adaptive.sp(15)),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: Adaptive.sp(12)),
                  ),
                  textColor: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    'Confirm',
                    style: TextStyle(fontSize: Adaptive.sp(12)),
                  ),
                  onPressed: () {
                    signOut();
                    setupVerification();
                    resetEverything();
                    widget.notifyParent();
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  bool _readtosignin = true;
  void _signInPopUp(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: Adaptive.h(80),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.grey,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        showSignIn();
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Image.asset(
                    'assets/images/doloverywhiteback.png',
                    width: 30.0.w,
                  ),
                ),
                Visibility(
                  visible: _readtosignin,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      child: Image.asset('assets/images/fblogin.jpg', width: 75.0.w),
                      onTap: () {
                        hideSignIn();
                        signUpWithFacebook();
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: _readtosignin,
                  child: GestureDetector(
                      child: Image.asset('assets/images/glogin.jpg', width: 75.0.w),
                      onTap: () {
                        _readtosignin = false;

                        hideSignIn();
                        _googleSignUp();
                      }),
                ),
                Visibility(
                  visible: !_readtosignin,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 13.0),
                    child: new CircularProgressIndicator(),
                  ),
                ),
                Visibility(
                    visible: showerrortextbool,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 20, right: 20),
                        child: Text(
                          showerrortext,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Axiforma',
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        )))
              ],
            ),
          );
        });
  }

  void hideSignIn() {
    Navigator.pop(context);
    _signInPopUp(context);
    setState(() {
      _readtosignin = false;
      showerrortextbool = false;
    });
  }

  void showSignIn() {
    setState(() {
      _readtosignin = true;
      showerrortextbool = false;
    });
  }

  String showerrortext = "Error";
  void showError(String text) {
    Navigator.pop(context);
    _signInPopUp(context);
    showerrortext = text;
    new Future.delayed(new Duration(seconds: 3), () {
      setState(() {
        showerrortextbool = false;
      });
    });
  }

  Future<void> _signInOut() async {
    if (await FirebaseAuth.instance.currentUser() == null) {
      _signInPopUp(context);
    } else {
      signOut();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  String chosen_address;
  bool user_is_signed_in = false;
  bool user_is_setup = false;

  Future setupVerification() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      uid = user.uid;
      name = user.displayName;
      uemail = user.email;

      this_user = await Firestore.instance.collection("users").document(uid).get();
/* added to the page */
      if (this_user.exists) {
        user_is_setup = true;
        final prefs = await SharedPreferences.getInstance();
        chosen_address = this_user.data["chosen_address"];
        prefs.setString('addresses', json.encode(this_user.data['address']));
        prefs.setString('address', this_user.data["chosen_address"]);
      } else {
        user_is_setup = false;
      }
      user_is_signed_in = true;
    } else {
      user_is_signed_in = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    setState(() {});
    return FutureBuilder(
      future: setupVerification(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: Image.asset("assets/images/loading.gif", width: 30),
            );
          default:
            if ((snapshot.hasError)) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (user_is_signed_in == false) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 28.0),
                        child: Image.asset("assets/images/profile_illustration.png", width: 100.0.w),
                      ),
                      Text(
                        "Let's Get Started",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0.sp,
                          fontFamily: 'Axiforma',
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          width: 80.0.w,
                          child: Text(
                            "Create an account and get everything you need delivered to your doorstep!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 10.0.sp,
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
                          onPressed: () {
                            setState(() {
                              _readtosignin = true;
                            });

                            _signInPopUp(context);
                          },
                          color: Colors.redAccent[700],
                          textColor: Colors.white,
                          minWidth: 80.0.w,
                          height: 0,
                          padding: EdgeInsets.only(left: 33, top: 10, right: 33, bottom: 10),
                          child: Text(
                            "Get Started",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.0.sp,
                              fontFamily: 'Axiforma',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (!user_is_setup && user_is_signed_in) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 28.0),
                        child: Image.asset("assets/images/profile_illustration.png", width: 100.0.w),
                      ),
                      Text(
                        "Let's Get Started",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0.sp,
                          fontFamily: 'Axiforma',
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          width: 80.0.w,
                          child: Text(
                            "Create an account and get everything you need delivered to your doorstep!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 10.0.sp,
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
                          onPressed: () {
                            setState(() {
                              _readtosignin = true;
                            });

                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => ProfileScreen()))
                                .then((_) {
                              setState(() {});
                            });
                          },
                          color: Colors.redAccent[700],
                          textColor: Colors.white,
                          minWidth: 80.0.w,
                          height: 0,
                          padding: EdgeInsets.only(left: 33, top: 10, right: 33, bottom: 10),
                          child: Text(
                            "Setup your profile",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.0.sp,
                              fontFamily: 'Axiforma',
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 15, 22, 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showLogoutDialog();
                              },
                              child: Text(
                                "Log Out",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0.sp,
                                  fontFamily: 'Axiforma',
                                  color: Colors.black38,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) => Privacy()));
                              },
                              child: Text(
                                "Privacy Policy",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0.sp,
                                  fontFamily: 'Axiforma',
                                  color: Colors.black38,
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => Terms()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    "Terms & Conditions",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.0.sp,
                                      fontFamily: 'Axiforma',
                                      color: Colors.black38,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                              padding: const EdgeInsets.only(top: 60.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        this_user.data['fullname'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 25.0.sp,
                                          height: 1.1,
                                          fontFamily: 'Axiforma',
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              this_user.data['email'],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 11.0.sp,
                                fontFamily: 'Axiforma',
                                color: Colors.black45,
                              ),
                            ),
                            Text(
                              this_user.data['number'],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 11.0.sp,
                                letterSpacing: 1.1,
                                fontFamily: 'Axiforma',
                                color: Colors.black45,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) => EditProfileScreen()))
                                    .then((_) {
                                  setState(() {});
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Text(
                                  "EDIT PROFILE",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 11.0.sp,
                                    fontFamily: 'Axiforma',
                                    color: Colors.black38,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection('orders')
                              .where('user', isEqualTo: uid)
                              .orderBy('date', descending: true)
                              .limit(4)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Visibility(
                                        visible: snapshot.data.documents.length > 0,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 30.0, top: 30, bottom: 15),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Recent Orders",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: Adaptive.sp(10),
                                                fontFamily: 'Axiforma',
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: List<Widget>.generate(snapshot.data.documents.length,
                                                (int index) {
                                              return Visibility(
                                                visible: index != 3,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => OrderPage(
                                                            snapshot.data.documents[index].documentID)));
                                                  },
                                                  child: RecentOrder(
                                                      orderDate: snapshot.data.documents[index]['date'],
                                                      orderCount:
                                                          snapshot.data.documents[index]['count'].toInt(),
                                                      orderImage: snapshot.data.documents[index]['image'],
                                                      orderPrice:
                                                          snapshot.data.documents[index]['total'].toString()),
                                                ),
                                              );
                                            })),
                                      ),
                                      Visibility(
                                        visible: snapshot.data.documents.length > 0,
                                        child: MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              side: BorderSide(color: Colors.grey[200])),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder: (context) => Orders(uid: uid)));
                                          },
                                          color: Colors.grey[200],
                                          elevation: 0,
                                          textColor: Colors.white,
                                          minWidth: 0,
                                          height: 0,
                                          padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                                          child: Text(
                                            "View All Orders",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: Adaptive.sp(10),
                                              fontFamily: 'Axiforma',
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ));
                            } else if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }
                            return Center(child: Container());
                          },
                        ),
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0, top: 10, bottom: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "My Addresses",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.0.sp,
                                    fontFamily: 'Axiforma',
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                            if (this_user != null)
                              for (var index = 0; index < this_user.data["address"].length; index++)
                                Padding(
                                  padding: const EdgeInsets.only(right: 30.0, bottom: 10, left: 30, top: 12),
                                  child: GestureDetector(
                                    onTap: () {
                                      bool isDefault =
                                          chosen_address == this_user.data["address"][index]["id"];
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => EditAddress(
                                                  this_user.data["address"], index, isDefault, uid)))
                                          .then((_) {
                                        setState(() {});
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.1),
                                              spreadRadius: 2.2,
                                              blurRadius: 2.5,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(15))),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Icon(
                                              Icons.place,
                                              color: chosen_address == this_user.data["address"][index]["id"]
                                                  ? Colors.black
                                                  : Colors.grey[400],
                                              size: 36,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.5),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          top: 10.0, left: 0, bottom: 5),
                                                      child: Expanded(
                                                        child: Text(
                                                          this_user.data["address"][index]["name"],
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: Adaptive.sp(13),
                                                            fontFamily: 'Axiforma',
                                                            color: chosen_address ==
                                                                    this_user.data["address"][index]["id"]
                                                                ? Colors.black
                                                                : Colors.grey[500],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 0.0, bottom: 8),
                                                      child: Expanded(
                                                        child: Text(
                                                          this_user.data["address"][index]["street_address"],
                                                          overflow: TextOverflow.ellipsis,
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                            height: 1.1,
                                                            fontWeight: FontWeight.normal,
                                                            fontSize: Adaptive.sp(13),
                                                            fontFamily: 'Axiforma',
                                                            color: Colors.grey[500],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                          ],
                        ),
                        SizedBox(height: 20),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.grey[200])),
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => AddAddress(this_user.data["address"])))
                                .then((_) {
                              setState(() {});
                            });
                          },
                          color: Colors.grey[200],
                          elevation: 0,
                          textColor: Colors.white,
                          minWidth: 0,
                          height: 0,
                          padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                          child: Text(
                            "Add New Address",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.0.sp,
                              fontFamily: 'Axiforma',
                              color: Colors.black,
                            ),
                          ),
                        ),
                        // Spacer(),
                        SizedBox(
                          height: 40,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(25, 15, 22, 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showLogoutDialog();
                                  },
                                  child: Text(
                                    "Log Out",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.0.sp,
                                      fontFamily: 'Axiforma',
                                      color: Colors.black38,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) => Privacy()));
                                  },
                                  child: Text(
                                    "Privacy Policy",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.0.sp,
                                      fontFamily: 'Axiforma',
                                      color: Colors.black38,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(builder: (context) => Terms()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15.0),
                                      child: Text(
                                        "Terms & Conditions",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11.0.sp,
                                          fontFamily: 'Axiforma',
                                          color: Colors.black38,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
        }
      },
    );
  }
}
