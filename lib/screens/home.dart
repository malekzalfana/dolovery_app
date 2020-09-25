import 'package:dolovery_app/screens/addadress.dart';
import 'package:dolovery_app/screens/search.dart';
import 'package:dolovery_app/widgets/product.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/100lebanese.dart';
import '../screens/supplements.dart';
import '../screens/pets.dart';
import '../screens/shoppage.dart';
import '../screens/search.dart';
import '../screens/profile.dart';
import 'package:dolovery_app/widgets/shopImage.dart';
import 'package:dolovery_app/widgets/popupproduct.dart';
// import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  final Function() notifyParent;
  final Function() notifyParent2;
  // ProfileMainScreen(thisUser);
  HomeScreen(
      {Key key, @required this.notifyParent, @required this.notifyParent2})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

String c_position;

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Position position;

  @override
  void initState() {
    super.initState();
    @override
    void initState() {
      // print('Xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
      getLocation();
      super.initState();
    }
  }

  // getLocation2() async {
  //   bool isLocationServiceEnabled2 = await isLocationServiceEnabled();

  //   // print("permissions are enabled?");
  //   // print(isLocationServiceEnabled2);
  //   LocationPermission permission = await checkPermission();
  //   // print("location are enabled?");
  //   // print(permission);

  //   Position position =
  //       await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   // print(position);

  //   final coordinates = new Coordinates(position.altitude, position.latitude);
  //   var addresses =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);

  //   var first = addresses.first;
  //   print("${first.featureName} : ${first.addressLine}");
  //   c_position = first.featureName.toString();
  //   print('----------------------------------------');
  //   print("client position is: " + c_position);
  //   // position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  // }
  var currentLocation;
  bool gotLocation = true;
  bool acquiredlocation = false;

  openLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        debugPrint('Location Denied once');
      }
    }
  }

  getLocation() async {
    //call this async method from whereever you need

    LocationData myLocation;
    String error;
    Location location = new Location();
    if (c_position.length > 0) {
      print("locaiton exists");
      return true;
    }

    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
        gotLocation = false;
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
        gotLocation = false;
      }
      myLocation = null;
    }
    currentLocation = myLocation;
    final coordinates =
        new Coordinates(myLocation.latitude, myLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    c_position = first.featureName;
    print(
        ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    if (acquiredlocation == false) {
      setState(() {
        acquiredlocation = true;
        print('added the correct location_________');
      });
    }

    return c_position;
  }

/************************************************************************************************** */
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
              new Text("Loading"),
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
      Navigator.pop(context); //pop dialog
      // _login();
    });
  }

  bool newuser = true;
  Future setupVerification() async {
    print("USER BEING WATCHED");
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;
    final name = user.displayName;
    final uemail = user.email;
    // print("USERNAME")
    var usercollection =
        await Firestore.instance.collection("users").document(uid).get();

    if (usercollection.exists) {
      newuser = false;
    }
    // return newuser = false;
  }

  void runsetupVerification() {
    setupVerification().then((value) => null);
  }

  void signOut() {
    FirebaseAuth.instance.signOut().then((onValue) {
      print("JUST LOGGED OUT");
    });
  }

  Future<void> _googleSignUp() async {
    try {
      print("started signing in");
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      // _onLoading();
      // var docRef = db.collection("cities").doc("SF");
      print("signed in " + user.uid);

      // used before user.uid
      bool notsetup;
      double welcomeheight;
      final newUser =
          await Firestore.instance.collection("users").document(user.uid).get();
      if (newUser.exists) {
        print('USER EXISTSSSSSSSSSSSSSSSSSSSSSSS');
        notsetup = false;
        welcomeheight = 350;
      } else {
        print('NOTTTTTTTTTT EXISTSSSSSSSSSSSSSSSSSSSSSSS');
        notsetup = true;
        welcomeheight = 400;
      }
      Navigator.of(context).pop();

      _welcomePopUp(context, user.displayName, notsetup, welcomeheight);
      setState(() {
        _readtosignin = true;
      });
      if (!newUser.exists) {
        print("user exists");
      }
      // } else {
      //   Firestore.instance.collection("users").add({
      //     "name": "john",
      //     "age": 50,
      //     "email": "example@example.com",
      //     "address": {"street": "street 24", "city": "new york"}
      //   }).then((value) {
      //     print(value.documentID);
      //   });
      // }

      // if (Firestore.instance.collection("users").document(user.uid).get() != null) {

      // Scaffold.of(context).showSnackBar(snackBar);
      // }

      return user;
    } catch (e) {
      print(">>>>>>>>>>>>>");
      if (e.message ==
          "An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.") {
        print("cateched");
      }
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
        final FirebaseUser user =
            (await FirebaseAuth.instance.signInWithCredential(credential)).user;
        print('signed in ' + user.displayName);
        bool notsetup;
        double welcomeheight;
        final newUser = await Firestore.instance
            .collection("users")
            .document(user.uid)
            .get();
        if (newUser.exists) {
          print('USER EXISTSSSSSSSSSSSSSSSSSSSSSSS');
          notsetup = false;
          welcomeheight = 350;
        } else {
          print('NOTTTTTTTTTT EXISTSSSSSSSSSSSSSSSSSSSSSSS');
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
        showError(
            "An account already exists with the same email address, try using Google to sign in.");
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
                    // height: 120.0,
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
                  visible: notsetup,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: Colors.red)),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfileScreen()));
                      },
                      color: Colors.redAccent[700],
                      textColor: Colors.white,
                      minWidth: 0,
                      height: 0,
                      // padding: EdgeInsets.zero,
                      padding: EdgeInsets.only(
                          left: 20, top: 10, right: 20, bottom: 10),
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
                    // height: 120.0,
                    width: 120.0,
                  ),
                ),
                Visibility(
                  visible: _readtosignin,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      child:
                          Image.asset('assets/images/fblogin.jpg', width: 300),
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
                      child:
                          Image.asset('assets/images/glogin.jpg', width: 300),
                      onTap: () {
                        _readtosignin = false;
                        // print("ssssssss");
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
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 20, right: 20),
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
    print("HIDEEEEEEEEEEEEEEEEEEEE");
    Navigator.pop(context);
    _signInPopUp(context);
    setState(() {
      _readtosignin = false;
      showerrortextbool = false;
    });
  }

  refreshcart() {
    // print("sssss");
    widget.notifyParent2();
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
      // _login();
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
  @override
  Widget build(BuildContext context) {
    /*24 is for notification bar on Android*/
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0.0,
        //   leading: BackButton(color: Colors.black),
        //   centerTitle: true,
        //   title: Text(
        //     "Enter Details",
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //       fontWeight: FontWeight.w800,
        //       fontSize: 16.0,
        //       fontFamily: 'Axiforma',
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 30.0, bottom: 10.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Icon(
                    Icons.near_me,
                    color: Colors.redAccent[700],
                    size: 20.0,
                  ),
                ),
                Text(
                  "Delivering to",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    fontFamily: 'Axiforma',
                    color: Colors.redAccent[700],
                  ),
                ),
                Visibility(
                  visible: c_position == null ? true : false,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      onPressed: () {
                        getLocation();
                      },
                      color: Colors.redAccent[700],
                      textColor: Colors.white,
                      minWidth: 0,
                      height: 0,
                      // padding: EdgeInsets.zero,
                      padding:
                          EdgeInsets.only(left: 6, top: 0, right: 6, bottom: 1),
                      child: FutureBuilder(
                        future: getLocation(),
                        builder: (context, snapshot) {
                          return Text(
                            'Enable Location',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              fontFamily: 'Axiforma',
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: c_position == null ? false : true,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      onPressed: () {
                        // _signInPopUp(context);
                      },
                      color: Colors.redAccent[700],
                      textColor: Colors.white,
                      minWidth: 0,
                      height: 0,
                      // padding: EdgeInsets.zero,
                      padding:
                          EdgeInsets.only(left: 6, top: 0, right: 6, bottom: 1),
                      child: FutureBuilder(
                        future: getLocation(),
                        builder: (context, snapshot) {
                          return Text(
                            c_position.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              fontFamily: 'Axiforma',
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 10.0, top: 0.0, bottom: 10.0),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _signInOut();
                  },
                  child: Text(
                    "What are you looking for?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
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
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Search()))
                  .then((_) {
                refreshcart();
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 10),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 0),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  // color: Color(0xFFF5F5F7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: <Widget>[
                    Image.asset("assets/icons/searchicon.png", height: 16),
                    SizedBox(width: 16),
                    Container(
                      child: Text(
                        "Search for anything",
                        style: TextStyle(
                          fontSize: 17,
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
          GestureDetector(
            onTap: () {
              // Navigator.of(context)
              //     .push(MaterialPageRoute(builder: (context) => SalleScreen() ));
              // setState(
              //   () {
              //     widget._selectedItemIndex = 2;
              //   },
              // );
              print('clicked');
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
                      offset: Offset(0, 4), // changes position of shadow
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
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => TabsDemo()))
                  .then((_) {
                refreshcart();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 135,
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
                      offset: Offset(0, 4), // changes position of shadow
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
                            "100% Lebanese",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20.0,
                              fontFamily: 'Axiforma',
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "20+ Shops ready to deliver",
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
                      'assets/images/lebsec.jpg',
                      width: 120,
                    )
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => SupplementsScreen()))
                  .then((_) {
                refreshcart();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 135,
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
                      offset: Offset(0, 4), // changes position of shadow
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
                            "Supplements",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20.0,
                              fontFamily: 'Axiforma',
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "20+ Shops ready to deliver",
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
                      'assets/images/supsec.png',
                      width: 120,
                    )
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => PetsScreen()))
                  .then((_) {
                refreshcart();
              });
              ;
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 135,
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
                      offset: Offset(0, 4), // changes position of shadow
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
                            "Pet Shops",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20.0,
                              fontFamily: 'Axiforma',
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "20+ Shops ready to deliver",
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
                      'assets/images/petsec.png',
                      width: 120,
                    )
                  ],
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
                    fontSize: 26.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileScreen()));
                    },
                    child: GestureDetector(
                      onTap: () {
                        FirebaseAuth.instance.signOut().then((onValue) {
                          print("JUST LOGGED OUT");
                        });
                      },
                      child: Image.asset("assets/images/fullfilldolovery.png",
                          height: 23),
                    ))
              ],
            ),
          ),
          Padding(
              padding:
                  const EdgeInsets.only(left: 5.0, right: 5, top: 0, bottom: 0),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('products')
                    .where('type', isEqualTo: 'lebanese')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (itemWidth / itemHeight),
                      controller: new ScrollController(keepScrollOffset: false),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: List.generate(8, (index) {
                        return GestureDetector(
                          onTap: () {
                            openProductPopUp(
                                context, snapshot.data, index, refreshcart);
                          },
                          child: ProductImage(
                            productName: snapshot.data.documents[0]['name'],
                            productImage: snapshot.data.documents[0]['image'],
                            productPrice: snapshot
                                .data.documents[0]['shop_price']
                                .toString(),
                            shopName: snapshot.data.documents[0]['shop'],
                            productUnit:
                                snapshot.data.documents[0]['unit'] != null
                                    ? snapshot.data.documents[0]['unit']
                                    : '',
                            productCurrency:
                                snapshot.data.documents[0]['currency'] != null
                                    ? snapshot.data.documents[0]['currency']
                                    : "lebanese",
                          ),
                        );
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8)),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => TabsDemo()))
                    .then((_) {
                  refreshcart();
                });
              },
              elevation: 0,
              color: Colors.grey[100],
              // textColor: Colors.black45,
              minWidth: MediaQuery.of(context).size.width - 20,
              height: 0,
              // padding: EdgeInsets.zero,
              padding: EdgeInsets.only(left: 6, top: 10, right: 6, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "View All Lebanese Products".toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14.0,
                      fontFamily: 'Axiforma',
                      color: Colors.black38,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black38,
                    size: 20.0,
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
                    fontSize: 26.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => AddAddress()));
                    },
                    child: Image.asset("assets/images/fullfilldolovery.png",
                        height: 23))
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, top: 0, bottom: 20),
              child: StreamBuilder(
                stream: Firestore.instance.collection('bundles').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Hexcolor(snapshot.data.documents[0]['bcolor']),
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
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 15, left: 15),
                                  child: Text(
                                    snapshot.data.documents[0]['title'],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18.0,
                                      fontFamily: 'Axiforma',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      snapshot.data.documents[0]['price'] +
                                          "L.L.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17.0,
                                        fontFamily: 'Axiforma',
                                        color: Hexcolor(snapshot
                                            .data.documents[0]['buttoncolor']),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, left: 15),
                                  child: Text(
                                    snapshot.data.documents[0]['details'],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13.0,
                                      fontFamily: 'Axiforma',
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      snapshot.data.documents[0]['image']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: null /* add child content here */,
                            ),
                          )
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Supplements",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      () {};
                    },
                    child: Image.asset("assets/images/fullfilldolovery.png",
                        height: 23))
              ],
            ),
          ),
          Padding(
              padding:
                  const EdgeInsets.only(left: 5.0, right: 5, top: 0, bottom: 0),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('products')
                    .where('type', isEqualTo: 'Supplements')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (itemWidth / itemHeight),
                      controller: new ScrollController(keepScrollOffset: false),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: List.generate(8, (index) {
                        return GestureDetector(
                          onTap: () {
                            openProductPopUp(
                                context, snapshot.data, index, refreshcart);
                          },
                          child: ProductImage(
                            productName: snapshot.data.documents[index]['name'],
                            productImage: snapshot.data.documents[index]
                                ['image'],
                            productPrice: snapshot
                                .data.documents[index]['shop_price']
                                .toString(),
                            shopName: snapshot.data.documents[index]['shop'],
                            productUnit:
                                snapshot.data.documents[index]['unit'] != null
                                    ? snapshot.data.documents[index]['unit']
                                    : '',
                            productCurrency: snapshot.data.documents[index]
                                        ['currency'] !=
                                    null
                                ? snapshot.data.documents[index]['currency']
                                : "lebanese",
                          ),
                        );
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8)),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => SupplementsScreen()))
                    .then((_) {
                  refreshcart();
                });
              },
              elevation: 0,
              color: Colors.grey[100],
              // textColor: Colors.black45,
              minWidth: MediaQuery.of(context).size.width - 20,
              height: 0,
              // padding: EdgeInsets.zero,
              padding: EdgeInsets.only(left: 6, top: 10, right: 6, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "View All Suppliments Products".toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14.0,
                      fontFamily: 'Axiforma',
                      color: Colors.black38,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black38,
                    size: 20.0,
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
                  "Pet Shops",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      // reset();
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => ProfileScreen()));
                    },
                    child: Image.asset("assets/images/fullfilldolovery.png",
                        height: 23))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('shops')
                  .where('type', isEqualTo: 'pets')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot);
                  return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: List<Widget>.generate(10, (int index) {
                        // print(categories[index]);
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ShopPage(snapshot.data.documents[1])));
                          },
                          child: ShopImage(
                              shopName: snapshot.data.documents[0]['name'],
                              shopIndex: index,
                              shopImage: snapshot.data.documents[0]['image'],
                              shopTime: snapshot.data.documents[0]['time']
                                  .toString()),
                        );
                      })));
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    ));
  }
}
