import 'package:dolovery_app/screens/addadress.dart';
import 'package:dolovery_app/screens/editadress.dart';
import 'package:dolovery_app/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:dolovery_app/widgets/recentorder.dart';
import 'package:dolovery_app/widgets/signinpopup.dart' as signin;

class ProfileMainScreen extends StatefulWidget {
  // dynamic thisUser;
  // ProfileMainScreen(thisUser);
  ProfileMainScreen({Key key}) : super(key: key);

  // @override
  // ProfileScreenState createState() => new ProfileScreenState();

  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

// SignInFunctions._welcomePopUp(context, name)
// _welcomePopUp(context, name);

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
      Navigator.pop(context); //pop dialog
      showSignIn();
      // _login();
    });
  }

  // bool newuser = true;
  // Future setupVerification() async {
  //   print("USER BEING WATCHED");
  //   final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //   final uid = user.uid;
  //   final name = user.displayName;
  //   final uemail = user.email;
  //   // print("USERNAME")
  //   var usercollection =
  //       await Firestore.instance.collection("users").document(uid).get();

  //   if (usercollection.exists) {
  //     newuser = false;
  //   }
  //   // return newuser = false;
  // }

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
    Future<void> future = showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        // isDismissible: false,
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
    future.then((void value) => setState(() {}));
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
                        showSignIn();
                        // setState(() {
                        //   _readtosignin = false;
                        //   print(_readtosignin);
                        // });
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

  void showSignIn() {
    print("SHOWWWWWWWWWW");
    // Navigator.pop(context);
    // _signInPopUp(context);
    setState(() {
      _readtosignin = true;
      showerrortextbool = false;
    });
  }

  // refreshcart() {
  //   // print("sssss");
  //   widget.notifyParent2();
  // }

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

  @override
  void initState() {
    super.initState();
    // loadcart();
    // setupVerification();
  }

  String chosen_address;

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
      chosen_address = this_user.data["chosen_address"];
      // print(this_user.data['number']);
      print('ss');
      // print(widget.thisUser);
      print('ss');

      if (this_user.exists) {
        newuser = false;
      }
    }

    // return this_user;
  }

  @override
  Widget build(BuildContext context) {
    // setupVerification();
    double width = MediaQuery.of(context).size.width;
    // print(UniqueKey().hashCode.toString());
    // print('_____________________________');
    setState(() {});
    return FutureBuilder(
      future: setupVerification(), // async work
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: Image.asset("assets/images/loading.gif"),
            );
          default:
            if ((snapshot.hasError)) {
              return Text('Error: ${snapshot.error}');
            } else {
              // return Text('dddd');
              if (newuser == true) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 28.0),
                        child: Image.asset(
                            "assets/images/profile_illustration.png",
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
                            "Create an account and get everything you need delivered to your doorstep!",
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
                          onPressed: () {
                            // signin.testfunction(ProfileScreenState());
                            setState(() {
                              _readtosignin = true;
                            });

                            _signInPopUp(context);
                            // signin.SignInFunctions.welcomePopUp(context, name);
                          },
                          color: Colors.redAccent[700],
                          // disabledColor: Colors.grey[200],
                          textColor: Colors.white,
                          minWidth: MediaQuery.of(context).size.width,
                          height: 0,
                          // padding: EdgeInsets.zero,
                          padding: EdgeInsets.only(
                              left: 33, top: 10, right: 33, bottom: 10),
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
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigator.of(context)
                                        //     .push(MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             AddAddress(this_user
                                        //                 .data["address"])))
                                        //     .then((_) {
                                        //   setState(() {});
                                        // });
                                      },
                                      child: Text(
                                        this_user.data['fullname'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 38.0,
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
                            Text(
                              this_user.data['email'],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                                fontFamily: 'Axiforma',
                                color: Colors.black45,
                              ),
                            ),
                            Text(
                              this_user.data['number'],
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
                              padding: const EdgeInsets.only(
                                  left: 30.0, top: 30, bottom: 10),
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
                              stream: Firestore.instance
                                  .collection('shops')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  print(snapshot);
                                  return SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: List<Widget>.generate(3,
                                              (int index) {
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
                                return Center(
                                    child: CircularProgressIndicator());
                              },
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 30.0, top: 30, bottom: 10),
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
                            // for (var index in this_user.data["address"].length)
                            for (var index = 0;
                                index < this_user.data["address"].length;
                                index++)
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 30.0, bottom: 10, left: 30, top: 12),
                                child: GestureDetector(
                                  onTap: () {
                                    print(this_user.data["address"]);
                                    bool isDefault = chosen_address ==
                                        this_user.data["address"][index]["id"];
                                    print(isDefault);
                                    print("______________________");
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => EditAddress(
                                                this_user.data["address"],
                                                index,
                                                isDefault,
                                                uid)))
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
                                            offset: Offset(0,
                                                4), // changes position of shadow
                                          ),
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    // color: Colors.grey,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        IconButton(
                                            icon: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Icon(
                                                Icons.place,
                                                color: chosen_address ==
                                                        this_user
                                                                .data["address"]
                                                            [index]["id"]
                                                    ? Colors.black
                                                    : Colors.grey[400],
                                                size: 36,
                                              ),
                                            ),
                                            onPressed: () {
                                              // Navigator.of(context).pop();
                                              // setState(() {
                                              //   showerrortextbool = false;
                                              // });
                                            }),
                                        Container(
                                            // color: Colors.green,
                                            margin: new EdgeInsets.only(
                                                left: 10.0, right: 0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.5),
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
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10.0,
                                                                left: 0,
                                                                bottom: 5),
                                                        child: Text(
                                                          this_user.data[
                                                                  "address"]
                                                              [index]["name"],
                                                          // textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'Axiforma',
                                                            color: chosen_address ==
                                                                    this_user.data["address"]
                                                                            [
                                                                            index]
                                                                        ["id"]
                                                                ? Colors.black
                                                                : Colors
                                                                    .grey[500],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 0.0,
                                                                  bottom: 8),
                                                          child: SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                145,
                                                            child: Text(
                                                              this_user.data[
                                                                          "address"]
                                                                      [index][
                                                                  "street_address"],
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                height: 1.1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 14.5,
                                                                fontFamily:
                                                                    'Axiforma',
                                                                color: Colors
                                                                    .grey[500],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            print(this_user.data["address"]);
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) =>
                                        AddAddress(this_user.data["address"])))
                                .then((_) {
                              setState(() {});
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, left: 30, bottom: 15),
                            child: Row(children: [
                              Icon(
                                Icons.add,
                                color: Colors.black38,
                                size: 18.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Add new address".toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13.0,
                                    fontFamily: 'Axiforma',
                                    color: Colors.black38,
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, left: 30, bottom: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side:
                                          BorderSide(color: Colors.grey[200])),
                                  onPressed: () {
                                    signOut();
                                    setupVerification();
                                    setState(() {});
                                  },
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
      },
    );
  }
}
