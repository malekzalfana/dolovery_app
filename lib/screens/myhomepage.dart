import 'dart:async';
import 'dart:io';

import 'package:dolovery_app/screens/cart.dart';
import 'package:dolovery_app/screens/profilemain.dart';
import 'package:dolovery_app/screens/setup.dart';
import 'package:dolovery_app/screens/profile.dart';
import 'package:dolovery_app/screens/salle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

var thisUser;
String name;
String uid;
String uemail;
bool newuser = true;

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
    super.initState();
    Timer.run(() {
      try {
        InternetAddress.lookup('google.com').then((result) {
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');

            _getPrefs();
          } else {}
        }).catchError((error) {});
      } on SocketException catch (_) {
        print('not connected');
      }
    });
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('type');
    prefs.remove('total');
    prefs.remove('items');
    prefs.remove('cart');
    prefs.remove('shops');
    prefs.remove('usercartmap');

    print(prefs.getKeys());
    return true;
  }

  List pages;

  profilestatus() {
    var profilescreen;

    if (newuser == false) {
      profilescreen = ProfileMainScreen();
      print('user NOT set up');
    } else {
      profilescreen = SetupScreen();
      print('user already set up');
    }

    pages = [
      HomeScreen(notifyParent: gotosalle, notifyParent2: refreshcart),
      SalleScreen(notifyParent: gotohome, notifyParent2: refreshcart),
      ProfileMainScreen(notifyParent: gotohome),
    ];
  }

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  void signOut() {
    FirebaseAuth.instance.signOut().then((onValue) {
      print("JUST LOGGED OUT");
    });
  }

  double items;
  double total;
  String type;

  SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    profilestatus();

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

                if (_getPrefs() != null) {
                  return SafeArea(
                    child: SizedBox(
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
                                padding:
                                    const EdgeInsets.fromLTRB(13, 4, 10, 0),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
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
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                Text("there is an error");
              } else {}
              return Center(
                  child: Image.asset("assets/images/loading.gif", height: 30));
            }),
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
