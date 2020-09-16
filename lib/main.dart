import 'dart:core';

import 'package:dolovery_app/screens/cart.dart';
import 'package:dolovery_app/widgets/product.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'screens/100lebanese.dart';
import 'package:flutter/services.dart';
import 'tools/hex.dart';
import 'screens/home.dart';
import 'screens/profile.dart';
import 'screens/salle.dart';
import 'screens/profilemain.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());
var this_user;
String name;
String uid;
String uemail;
bool newuser = true;
// DELETEDDDDDDD
// Future setupVerification() async {
//   print("USER BEING WATCHED");
//   final FirebaseUser user = await FirebaseAuth.instance.currentUser();
//   if (user != null) {
//     uid = user.uid;
//     name = user.displayName;
//     uemail = user.email;
//   }

//   // print("USERNAME")
//   this_user = await Firestore.instance.collection("users").document(uid).get();

//   if (this_user.exists) {
//     newuser = false;
//   }
//   print("newuser is:" + newuser.toString());
//   // return this_user;
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dolovery',
      theme: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
        fontFamily: "Axiforma",
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Homepage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  int _selectedItemIndex = 0;

  gotosalle() {
    setState(() {
      print(_selectedItemIndex);
      _selectedItemIndex = 1;
    });
  }

  gotohome() {
    setState(() {
      print(_selectedItemIndex);
      _selectedItemIndex = 0;
    });
  }

  refreshcart() {
    print('refreshed');
    setState(() {});
  }

  @override
  void initState() {
    _getPrefs();
    print('Xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    super.initState();
    @override
    void initState() {
      print('Xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
      super.initState();
    }
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('type');
    prefs.remove('total');
    prefs.remove('items');
    prefs.remove('cart');
    prefs.remove('shops');
    prefs.remove('usercartmap');
    // Navigator.of(context).pop();
    print(prefs.getKeys());
    return true;
  }

  List pages;
// @override
  profilestatus() {
    var profilescreen;
    // setupVerification();
    if (newuser == false) {
      profilescreen = ProfileMainScreen(
          // thisUser: this_user,
          );
      print('user NOT set up');
    } else {
      profilescreen = ProfileScreen();
      print('user already set up');
    }

    pages = [
      HomeScreen(notifyParent: gotosalle, notifyParent2: refreshcart),
      // null,
      SalleScreen(notifyParent: gotohome),
      // profilescreen
      // null,
      // ProfileScreen(),
      ProfileMainScreen(),
    ];
  }

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  // @override
  void signOut() {
    FirebaseAuth.instance.signOut().then((onValue) {
      print("JUST LOGGED OUT");
    });
  }

  Future<void> _signInOut() async {
    if (await FirebaseAuth.instance.currentUser() == null) {
      _signInPopUp(context);
    } else {
      signOut();
    }
  }

  // _addtocart() async {
  //       final prefs = await SharedPreferences.getInstance();

  //       final key = 'cart';
  //       final value = ['sss','aaa'];
  //       prefs.setInt(key, value);
  //       print('saved $value');
  //     }
  double items;
  double total;
  String type;
  // Future loadcart() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   // setState(() {
  //   type = prefs.getString('type');
  //   total = prefs.getDouble('total');
  //   items = prefs.getDouble('items');
  //   // });
  //   return print(type);
  //   // print('saved $total');
  //   // print('saved $type');
  // }
  SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    // setupVerification();
    profilestatus();
    // _getPrefs();
    // loadcart();
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    print(newuser.toString() + 'this is the new user');
    return Scaffold(
        bottomNavigationBar: FutureBuilder(
            future: _getPrefs(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot);
                int cart_items = prefs.getDouble('items') != null
                    ? prefs.getDouble('items').toInt()
                    : 0;
                int cart_total = prefs.getDouble('total') != null
                    ? prefs.getDouble('total').toInt()
                    : 0;
                cart_total = cart_total == null ? 0 : cart_total;
                cart_total = cart_total == null ? 0 : cart_total;
                print(cart_items.toString() + cart_total.toString());
                //prefs.getDouble('total').toInt();
                if (_getPrefs() != null) {
                  return SizedBox(
                    height: cart_items == 0 ? 50 : 108,
                    child: Container(
                      color: Colors.redAccent[700],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: cart_items > 0 ? true : false,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(13, 4, 10, 0),
                              child: Row(
                                children: [
                                  Text(
                                    cart_items.toString() + " Items",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      fontFamily: 'Axiforma',
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      cart_total.toString() + "L.L.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0,
                                        fontFamily: 'Axiforma',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: MaterialButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      Cart(newuser)))
                                              .then((_) {
                                            refreshcart();
                                          });
                                        },
                                        onLongPress: () {
                                          reset();
                                        },
                                        color: Colors.white.withOpacity(0.25),
                                        textColor: Colors.white,
                                        minWidth: 0,
                                        height: 0,
                                        elevation: 0,
                                        // padding: EdgeInsets.zero,
                                        padding: EdgeInsets.only(
                                            left: 9,
                                            top: 6,
                                            right: 9,
                                            bottom: 4),
                                        child: Text(
                                          "OPEN CART",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                            fontFamily: 'Axiforma',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),

                                      // IconButton(
                                      //     icon: Icon(
                                      //       Icons.shopping_basket,
                                      //       color: Colors.white,
                                      //       size: 30,
                                      //     ),
                                      //     onPressed: () {
                                      //       // Navigator.of(context).pop();
                                      //     }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // ),
                          Container(
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                buildNavItem(context, 'home', true, 0),
                                buildNavItem(context, 'salle', false, 1),
                                buildNavItem(context, 'profile', false, 2)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                Text("there is an error");
              } else {
                // Text("else");
              }
              return Center(child: Text("what"));
              // return CircularProgressIndicator();
            }),

        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   title: Text(
        //     widget.title,
        //   ),
        // ),
        body: pages[_selectedItemIndex]);
  }

  Container buildNavItem(
      BuildContext context, String iconname, bool isActive, int index) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 3,
      child: GestureDetector(
        onTap: () {
          print('page changed');
          setState(() {
            _selectedItemIndex = index;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Image.asset(
            index == _selectedItemIndex
                ? 'assets/icons/' + iconname + '2' + '.png'
                : 'assets/icons/' + iconname + '.png',
            height: 30.0,
            width: 30.0,
          ),
        ),
      ),
    );
  }

  Future<void> _getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    return true;
    // setState(() {
    //   type = prefs.getString('type');
    // total = prefs.getDouble('total');
    // items = prefs.getDouble('items');
    // });
  }

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
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: GestureDetector(
                    child: Image.asset('assets/images/fblogin.jpg', width: 300),
                    onTap: () => signUpWithFacebook(),
                  ),
                ),
                GestureDetector(
                  child: Image.asset('assets/images/glogin.jpg', width: 300),
                  onTap: () => _googleSignUp(),
                )
              ],
            ),
          );
        });
  }

  void _welcomePopUp(context, name) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 400,
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
                Padding(
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
              ],
            ),
          );
        });
  }

  void _popDetails(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 700,
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
                Text(
                  "Add Details",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _googleSignUp() async {
    try {
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
      final snackBar = SnackBar(
        content: Text('Welcome to Dolovery!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      // var docRef = db.collection("cities").doc("SF");
      print("signed in " + user.uid);
      Navigator.of(context).pop();
      _welcomePopUp(context, user.displayName);
      // used before user.uid
      final newUser =
          await Firestore.instance.collection("users").document(user.uid).get();
      if (!newUser.exists) {
        print("user exists");
      } else {
        Firestore.instance.collection("users").add({
          "name": "john",
          "age": 50,
          "email": "example@example.com",
          "address": {"street": "street 24", "city": "new york"}
        }).then((value) {
          print(value.documentID);
        });
      }

      // if (Firestore.instance.collection("users").document(user.uid).get() != null) {

      // Scaffold.of(context).showSnackBar(snackBar);
      // }

      return user;
    } catch (e) {
      print(e.message);
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
        return user;
      }
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> signUpWithMail() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Success sign up'),
            );
          });
    } catch (e) {
      print(e.message);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message),
            );
          });
    }
  }
}
// void refresh(){
//   print ('refreshed');
// }
