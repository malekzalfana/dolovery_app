import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:dolovery_app/screens/search.dart';
import 'package:dolovery_app/screens/shoplisting.dart';
import 'package:dolovery_app/widgets/bundle.dart';
import 'package:dolovery_app/widgets/product.dart';
import 'package:dolovery_app/widgets/product_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/search.dart';
import 'setup.dart';

class HomeScreen extends StatefulWidget {
  final Function() notifyParent;
  final Function() notifyParent2;

  HomeScreen({Key key, @required this.notifyParent, @required this.notifyParent2}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

Future<void> reset([bool pop]) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('type');
  prefs.remove('total');
  prefs.remove('items');
  prefs.remove('cart');
  prefs.remove('shops');
  // prefs.remove('usercartmap');
  prefs.remove('usercartmap_v2');
  prefs.remove('cached_shops');
  prefs.remove('caching_date');
  //
  prefs.remove('type');
  prefs.remove('total');
  prefs.remove('items');
  prefs.remove('cart');
  prefs.remove('shops');
  // prefs.remove('usercartmap');
  prefs.remove('usercartmap_v2');
  prefs.remove('cached_shops');
  prefs.remove('address');
  prefs.remove('addresses');

  prefs.remove('address');

  return true;
}

// class MessageHandler extends StatefulWidget {
//   @override
//   _MessageHandlerState createState() => _MessageHandlerState();
// }

// class _MessageHandlerState extends State<MessageHandler> {
//   final Firestore _db = Firestore.instance;
//   final FirebaseMessaging _fcm = FirebaseMessaging();

//   // TODO...

// }

String c_position;
String c2_position;
StreamSubscription iosSubscription;

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // _fcm.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //         content: ListTile(
    //           title: Text(message['notification']['title']),
    //           subtitle: Text(message['notification']['body']),
    //         ),
    //         actions: <Widget>[
    //           FlatButton(
    //             child: Text('Ok'),
    //             onPressed: () => Navigator.of(context).pop(),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     // TODO optional
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     // TODO optional
    //   },
    // );

    // super.initState();
    // _fcm.getToken().then((token) {
    //   print(token);
    // });
    // if (Platform.isIOS) {
    //   iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
    //     // save the token  OR subscribe to a topic here
    //   });

    //   _fcm.requestNotificationPermissions(IosNotificationSettings());
    // }

    super.initState();
  }

  // final Firestore _db = Firestore.instance;
  // final FirebaseMessaging _fcm = FirebaseMessaging();

  var currentLocation;
  bool gotLocation = true;
  bool acquiredlocation = false;

  openLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {}
    }
  }

  bool newuser = true;
  var all_addresses;
  var chosen_address;
  Future setupAddress() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('addresses') != null) {
      all_addresses = json.decode(prefs.getString('addresses'));
    }
    chosen_address = prefs.getString('address');
  }

  Future setupVerification() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();

    final uid = user.uid;

    var usercollection = await Firestore.instance.collection("users").document(uid).get();

    if (usercollection.exists) {
      newuser = false;
    }
    return newuser;
  }

  void runsetupVerification() {
    setupVerification().then((value) => null);
  }

  void signOut() {
    FirebaseAuth.instance.signOut().then((onValue) {});
  }

  bool notsetup;
  double welcomeheight;

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
        bool notsetup;
        double welcomeheight;
        final newUser = await Firestore.instance.collection("users").document(user.uid).get();
        if (newUser.exists) {
          final prefs = await SharedPreferences.getInstance();
          chosen_address = newUser.data["chosen_address"];
          prefs.setString('addresses', json.encode(newUser.data['address']));
          prefs.setString('address', newUser.data["chosen_address"]);
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
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext bc) {
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
                Visibility(
                  visible: false, //notsetup,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0), side: BorderSide(color: Colors.red)),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SetupScreen()));
                      },
                      color: Colors.redAccent[700],
                      textColor: Colors.white,
                      minWidth: 0,
                      height: 0,
                      padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                      child: Text(
                        "Setup your profile",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                          fontFamily: 'Axiforma',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
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
            height: 450,
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
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Image.asset(
                    'assets/images/doloverywhiteback.png',
                    width: 120.0,
                  ),
                ),
                Visibility(
                  visible: _readtosignin,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      child: Image.asset('assets/images/fblogin.jpg', width: 300),
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
                      child: Image.asset('assets/images/glogin.jpg', width: 300),
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

  refreshcart() {
    widget.notifyParent2();
    print('NOTIFIED THE PARENT FOR REFRESH HOMEPAGE');
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

/************************************************************************************************** */
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return new Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                FutureBuilder(
                    future: setupAddress(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Container(height: 20);
                        default:
                          if (snapshot.hasError)
                            return Text('Error: ${snapshot.error}');
                          else if (chosen_address != null) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 15.0, top: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5.0),
                                      child: Icon(
                                        Icons.near_me,
                                        color: Colors.redAccent[700],
                                        size: Adaptive.h(3),
                                      ),
                                    ),
                                    Text(
                                      "Delivering to your",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0.sp,
                                        fontFamily: 'Axiforma',
                                        color: Colors.redAccent[700],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: Adaptive.h(2)),
                                      height: 8.0.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Column(
                                        children: [
                                          for (var address = 0; address < all_addresses.length; address++)
                                            if (all_addresses[address]['id'] == chosen_address)
                                              Expanded(
                                                child: Text(
                                                  all_addresses[address]['name'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0.sp,
                                                    fontFamily: 'Axiforma',
                                                    color: Colors.redAccent[700],
                                                  ),
                                                ),
                                              ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else
                            return Container();
                      }
                    }),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 10.0, top: 10.0, bottom: 0.0),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "What are you looking for?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0.sp,
                            fontFamily: 'Axiforma',
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Search())).then((_) {
                      refreshcart();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0, right: 10),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 0),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      height: Adaptive.h(8),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: <Widget>[
                          Image.asset("assets/icons/searchicon.png", height: Adaptive.h(3)),
                          SizedBox(width: 16),
                          Container(
                            child: Text(
                              "Search for anything",
                              style: TextStyle(
                                fontSize: 12.0.sp,
                                fontFamily: "Axiforma",
                                color: Colors.black26,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: false,
                  child: DelayedDisplay(
                    delay: Duration(milliseconds: 100),
                    fadingDuration: const Duration(milliseconds: 100),
                    slidingBeginOffset: const Offset(0.0, 0.15),
                    child: GestureDetector(
                      onTap: () {
                        widget.notifyParent();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 135,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2.2,
                                blurRadius: 2.5,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 40.0, left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Meal Basket",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20.0,
                                        fontFamily: 'Axiforma',
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "Everyday a new recipe!",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0,
                                        fontFamily: 'Axiforma',
                                        color: Colors.redAccent[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                'assets/images/salle.png',
                                width: 120,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 200),
                  fadingDuration: const Duration(milliseconds: 100),
                  slidingBeginOffset: const Offset(0.0, 0.15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => ShopListing(type: 'lebanese', arrow: true)))
                          .then((_) {
                        refreshcart();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 15.5.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2.2,
                              blurRadius: 2.5,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 4.5.h, left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      reset();
                                      print('reset the cart');
                                    },
                                    child: Text(
                                      "100% Lebanese",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14.0.sp,
                                        fontFamily: 'Axiforma',
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "20+ Shops ready to deliver",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0.sp,
                                      fontFamily: 'Axiforma',
                                      color: Colors.redAccent[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              'assets/images/lebsec.jpg',
                              width: 30.0.w,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 100),
                  fadingDuration: const Duration(milliseconds: 280),
                  slidingBeginOffset: const Offset(0.0, 0.15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => ShopListing(type: 'cosmetics', arrow: true)))
                          .then((_) {
                        refreshcart();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 15.5.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2.2,
                              blurRadius: 2.5,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 4.5.h, left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Cosmetics",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14.0.sp,
                                      fontFamily: 'Axiforma',
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "20+ Shops ready to deliver",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0.sp,
                                      fontFamily: 'Axiforma',
                                      color: Colors.redAccent[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset('assets/images/supsec.png', width: 30.0.w)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "100% Lebanese",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.5.sp,
                          fontFamily: 'Axiforma',
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => SetupScreen()));
                          },
                          child: GestureDetector(
                            onTap: () {},
                            child: Image.asset("assets/images/fullfilldolovery.png", height: 5.0.h),
                          ))
                    ],
                  ),
                ),
                Visibility(
                  visible: true,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5, top: 0, bottom: 0),
                      child: StreamBuilder(
                          stream: Firestore.instance
                              .collection('products')
                              .where('type', isEqualTo: 'lebanese')
                              .snapshots(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Container(height: 20);
                              default:
                                if (snapshot.data.documents.length < 2) {
                                  return Opacity(
                                    opacity: 0.3,
                                    child: SizedBox(
                                        height: 22.0.h,
                                        child: Center(
                                            child: Text(
                                          'No items found.',
                                          style: TextStyle(fontSize: Adaptive.sp(12)),
                                        ))),
                                  );
                                }
                                if (snapshot.hasData) {
                                  return GridView.count(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.75,
                                    controller: new ScrollController(keepScrollOffset: false),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    children: List.generate(2, (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          openProductPopUp(context, snapshot.data.documents[index], index,
                                              null, refreshcart);
                                        },
                                        child: ProductImage(
                                          oldPrice: snapshot.data.documents[index]['old_price'] == null
                                              ? "0"
                                              : snapshot.data.documents[index]['old_price'].toString(),
                                          productName: snapshot.data.documents[index]['name'],
                                          productImage: snapshot.data.documents[index]['image'],
                                          productPrice:
                                              snapshot.data.documents[index]['shop_price'].toString(),
                                          shopName: snapshot.data.documents[index]['shop'],
                                          productUnit: snapshot.data.documents[index]['unit'] != null
                                              ? snapshot.data.documents[index]['unit']
                                              : '',
                                          productCurrency: snapshot.data.documents[index]['currency'],
                                        ),
                                      );
                                    }).toList(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text(snapshot.error.toString());
                                }
                                return Center(child: CircularProgressIndicator());
                            }
                          })),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8)),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => ShopListing(type: 'lebanese', arrow: true)))
                          .then((_) {
                        refreshcart();
                      });
                    },
                    elevation: 0,
                    color: Colors.grey[100],
                    minWidth: MediaQuery.of(context).size.width - 20,
                    height: 0,
                    padding: EdgeInsets.only(left: 6, top: 10, right: 6, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "View All Lebanese Shops".toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 10.0.sp,
                            fontFamily: 'Axiforma',
                            color: Colors.black38,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black38,
                          size: Adaptive.h(5),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Monthly Bundle",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.5.sp,
                          fontFamily: 'Axiforma',
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {},
                          child: Image.asset("assets/images/fullfilldolovery.png", height: 5.0.h))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: StreamBuilder(
                      stream: Firestore.instance
                          .collection('products')
                          .where('type', isEqualTo: 'bundle')
                          .snapshots(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Container(height: 20);
                          default:
                            if (snapshot.data.documents.length < 2) {
                              return Opacity(
                                opacity: 0.3,
                                child: SizedBox(
                                    height: 22.0.h,
                                    child: Center(
                                        child: Text(
                                      'No items found.',
                                      style: TextStyle(fontSize: Adaptive.sp(12)),
                                    ))),
                              );
                            }
                            if (snapshot.hasData) {
                              return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children:
                                          List<Widget>.generate(snapshot.data.documents.length, (int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        openProductPopUp(context, snapshot.data.documents[index], index, null,
                                            refreshcart);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 12),
                                        child: Bundle(
                                          bundleName: snapshot.data.documents[index]['name'],
                                          bundleDescription: snapshot.data.documents[index]['description'],
                                          bundleIndex: 0,
                                          bundlePrice:
                                              int.parse(snapshot.data.documents[index]['shop_price']),
                                          bundleImage: snapshot.data.documents[index]['image'],
                                        ),
                                      ),
                                    );
                                  })));
                            } else if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }
                            return Center(child: CircularProgressIndicator());
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Cosmetics",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.5.sp,
                          fontFamily: 'Axiforma',
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            () {};
                          },
                          child: Image.asset("assets/images/fullfilldolovery.png", height: 5.0.h))
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5, top: 0, bottom: 0),
                    child: StreamBuilder(
                        stream: Firestore.instance
                            .collection('products')
                            .where('type', isEqualTo: 'cosmetics')
                            .snapshots(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Container(height: 20);
                            default:
                              if (snapshot.data.documents.length < 2) {
                                return Opacity(
                                  opacity: 0.3,
                                  child: SizedBox(
                                      height: 22.0.h,
                                      child: Center(
                                          child: Text(
                                        'No items found.',
                                        style: TextStyle(fontSize: Adaptive.sp(12)),
                                      ))),
                                );
                              }
                              if (snapshot.hasData) {
                                return GridView.count(
                                  // padding: EdgeInsets.only(left: Adaptive.w(12)),
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  controller: new ScrollController(keepScrollOffset: false),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  children: List.generate(8, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        openProductPopUp(context, snapshot.data.documents[index], index, null,
                                            refreshcart);
                                      },
                                      child: ProductImage(
                                        productName: snapshot.data.documents[index]['name'],
                                        productImage: snapshot.data.documents[index]['image'],
                                        productPrice: snapshot.data.documents[index]['shop_price'].toString(),
                                        shopName: snapshot.data.documents[index]['shop'],
                                        productUnit: snapshot.data.documents[index]['unit'] != null
                                            ? snapshot.data.documents[index]['unit']
                                            : '',
                                        productCurrency: snapshot.data.documents[index]['currency'] != null
                                            ? snapshot.data.documents[index]['currency']
                                            : "lebanese",
                                        oldPrice: snapshot.data.documents[index]['old_price'] == null
                                            ? "0"
                                            : snapshot.data.documents[index]['old_price'].toString(),
                                      ),
                                    );
                                  }).toList(),
                                );
                              } else if (snapshot.hasError) {
                                return Text(snapshot.error.toString());
                              }
                              return Center(child: CircularProgressIndicator());
                          }
                        })),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8)),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => ShopListing(
                                    arrow: true,
                                    type: 'cosmetics',
                                  )))
                          .then((_) {
                        refreshcart();
                      });
                    },
                    elevation: 0,
                    color: Colors.grey[100],
                    minWidth: MediaQuery.of(context).size.width - 20,
                    height: 0,
                    padding: EdgeInsets.only(left: 6, top: 10, right: 6, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "View All Cosmetics Shops".toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 10.0.sp,
                            fontFamily: 'Axiforma',
                            color: Colors.black38,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black38,
                          size: Adaptive.h(5),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
