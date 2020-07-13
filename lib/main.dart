import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dolovery',
      theme: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Homepage'),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Screen')),
      body: Center(
        child: Text(
          'This is a new screen',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}

List<String> lebproductcount = ['A', 'B', 'C'];

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   title: Text(
        //     widget.title,
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
                Container(
                  margin: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                  child: MaterialButton(
                    onPressed: () {
                      _signInOut();
                    },
                    color: Colors.redAccent[700],
                    textColor: Colors.white,
                    minWidth: 0,
                    height: 0,
                    // padding: EdgeInsets.zero,
                    padding:
                        EdgeInsets.only(left: 6, top: 0, right: 6, bottom: 1),
                    child: Text(
                      "Badaro",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        fontFamily: 'Axiforma',
                        color: Colors.white,
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
                Text(
                  "What are you looking for?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
          Padding(
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
                        color: Color(0xFFA0A5BD),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
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
                    color: Colors.grey.withOpacity(0.07),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 8), // changes position of shadow
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
                    'assets/images/lebsec.png',
                    width: 120,
                  )
                ],
              ),
            ),
          ),
          Padding(
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
                    color: Colors.grey.withOpacity(0.07),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 8), // changes position of shadow
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
          Padding(
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
                    color: Colors.grey.withOpacity(0.07),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 8), // changes position of shadow
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
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "100% Lebanese",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileScreen()));
                    },
                    child: Image.asset("assets/images/fullfilldolovery.png",
                        height: 23))
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, top: 0, bottom: 0),
              child: StreamBuilder(
                stream: Firestore.instance.collection('products').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (itemWidth / itemHeight),
                      controller: new ScrollController(keepScrollOffset: false),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: List.generate(4, (index) {
                        return new Container(
                          color: Colors.green,
                          margin: new EdgeInsets.all(1.0),
                          child: new Center(
                            child: new Text(
                              snapshot.data.documents[0]['name'],
                              style: new TextStyle(
                                fontSize: 50.0,
                                color: Colors.white,
                              ),
                            ),
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
            padding:
                const EdgeInsets.only(left: 10.0, right: 10, top: 0, bottom: 0),
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('products')
                  //.where("shop_price", "<", 20000)
                  .orderBy("shop_price")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Text('Loading data.. Please Wait..');
                return GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (itemWidth / itemHeight),
                  controller: new ScrollController(keepScrollOffset: false),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: lebproductcount.map((String value) {
                    return new Container(
                      color: Colors.green,
                      margin: new EdgeInsets.all(1.0),
                      child: new Center(
                        child: new Text(
                          snapshot.data.documents[0]['name'],
                          style: new TextStyle(
                            fontSize: 50.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    ));
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
      print("signed in " + user.displayName);

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
