import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dolovery_app/widgets/signinpopup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dolovery_app/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Cart extends StatefulWidget {
  final dynamic user; //if you have multiple values add here
  // final String day;
  // final List descriptions;
  // final List prices;
  Cart(this.user, {Key key})
      : super(key: key); //add also..example this.abc,this...

  @override
  State<StatefulWidget> createState() => _CartState();
}

class _CartState extends State<Cart> {
  int _n = 1;
  bool minimum = true;
  bool maximum = false;
  // int serving = 0;
  List<String> finalcart = [];

  void add() {
    // print ( _n );
    setState(() {
      if (_n < 10) _n++;
      if (_n == 30) {
        maximum = true;
      } else {
        minimum = false;
        maximum = false;
      }
      print(_n);
    });
  }

  void minus() {
    print(_n);
    setState(() {
      if (_n != 1) _n--;
      if (_n == 1)
        minimum = true;
      else {
        minimum = false;
        maximum = false;
      }
    });
  }

  double items;
  double total;
  String type;
  List<String> cart;
  Map<String, int> cartmap = {};
  Map<String, String> carttype = {
    'supplements': 'Supplements',
    'lebanese': '100% Lebbanese',
    'pets': 'Pet Shops',
    'salle': 'Meal Basket'
  };
  String imagetype = 'assets/images/supsec.png';

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('type');
    prefs.remove('total');
    prefs.remove('items');
    prefs.remove('cart');
    Navigator.of(context).pop();
    print(prefs.getKeys());
    return true;
  }

  Future<void> refreshcartnumbers(
      String itemid, int quantity, int price, bool add, bool remove) async {
    final prefs = await SharedPreferences.getInstance();
    // List<String> cart = prefs.getStringList('cart');

    // setState(() {

    if (remove) {
      for (var i; i <= quantity; i++) {
        print('removed completely');
        prefs.setDouble('items', prefs.getDouble('items') - quantity);
        prefs.setDouble('total', prefs.getDouble('total') - (quantity * price));
        cart.remove(itemid);
      }
    } else {
      if (add) {
        // print(prefs.getDouble('cart'));
        prefs.setDouble('items', prefs.getDouble('items') + 1);
        prefs.setDouble('total', prefs.getDouble('total') + (1 * price));

        print('added');
        cart.add(itemid);
      } else {
        print('removed');
        prefs.setDouble('items', prefs.getDouble('items') - 1);
        prefs.setDouble('total', prefs.getDouble('total') - (1 * price));
        cart.remove(itemid);
        if (cart.length == 0) {
          reset();

          return print('XXXXXXXXXXXXX');
        }
      }
    }
    prefs.setStringList('cart', cart);
    print(prefs.getStringList('cart'));
    // loadcart();
    // print(cart);
    // });

    loadcart();
  }

  Future<void> loadcart() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      type = prefs.getString('type');
      total = prefs.getDouble('total');
      items = prefs.getDouble('items');
      cart = prefs.getStringList('cart');
      if (type == 'supplements') {
        imagetype = 'assets/images/supsec.png';
      } else if (type == 'pets') {
        imagetype = 'assets/images/petsec.png';
      } else if (type == 'lebanese') {
        imagetype = 'assets/images/lebsec.jpg';
      } else {
        imagetype = 'assets/images/salle.png';
      }
      cartmap = {};
      finalcart = [];
      if (items > 0) {
        for (var i = 0; i < items.toInt(); i++) {
          // print("${ls[i].name} is electric? ${ls[i].isElectric}");
          // print('stared to seeeeeee');

          if (!cartmap.containsKey(cart[i])) {
            cartmap[cart[i]] = 1;
            finalcart.add(cart[i]);
            print(finalcart);
            print('adedddddd');
          } else {
            // print('its insdedeeeeeee');
            // print(cart[i]);
            cartmap[cart[i]] = cartmap[cart[i]].toInt() + 1;
            // cartmap[cart[i]] = cartmap[i] + 1;
          }
        }
      }

      // cart
    });

    return print("zzzzzzzz" + cartmap.toString());
    // print('saved $total');
    // print('saved $type');
  }

  @override
  void initState() {
    loadcart();
    setupVerification();
    super.initState();
  }

  var this_user;
  String name;
  String uid;
  String uemail;
  bool notsetup = true;
  bool usersignedin = true;

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
    setState(() {});
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
    setState(() {});
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
      final notsetup =
          await Firestore.instance.collection("users").document(user.uid).get();
      if (!notsetup.exists) {
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

  Future setupVerification() async {
    // print("USER BEING WATCHED");
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      uid = user.uid;
      name = user.displayName;
      uemail = user.email;
      // print("USERNAME")
      this_user =
          await Firestore.instance.collection("users").document(uid).get();

      // print(this_user.data['number']);
      // print(widget.thisUser);

      if (this_user.exists) {
        notsetup = false;
        print("user is not setup");
      }
    } else {
      usersignedin = false;
      print("usre is not signed in");
    }

    // return this_user;
  }

  @override
  Widget build(BuildContext context) {
    // final double itemHeight = (size.height) / 2;
    // final double itemWidth = size.width / 2;
    // new Date(widget.data.documents[0]['salle_date'].seconds * 1000 + widget.data.documents[0]['salle_date'].nanoseconds/1000000)
    // var date = DateTime.fromMicrosecondsSinceEpoch(
    // widget.data.documents[0]['salle_date']);

    // var timestamp =
    //     (widget.data.documents[0]['salle_date'] as Timestamp).toDate();
    num _defaultValue = 0;
    double width = MediaQuery.of(context).size.width;
    // print(cart);
    List<Widget> list = new List<Widget>();
    // setupVerification();
    // setState(() {});
    // loadcart();
    // String formatted_date = DateFormat.yMMMMd().format(timestamp);
    return new Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            // automaticallyImplyLeading: false,
            //BackButton(color: Colors.black),
            centerTitle: true,
            title: Text(
              'Cart',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16.0,
                fontFamily: 'Axiforma',
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22.0, top: 30, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Type",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                  fontFamily: 'Axiforma',
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Container(
              //   // color: Colors.green,
              //   margin: new EdgeInsets.only(left: 12.0, right: 10),
              //   child: Container(
              //       height: 90,
              //       width: 90,
              //       decoration: BoxDecoration(
              //         image: DecorationImage(
              //           image: AssetImage(imagetype),
              //           fit: BoxFit.fitWidth,
              //         ),
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.grey.withOpacity(0.07),
              //             spreadRadius: 5,
              //             blurRadius: 7,
              //             offset: Offset(0, 8), // changes position of shadow
              //           ),
              //         ],
              //         color: Colors.white,
              //         borderRadius: BorderRadius.only(
              //             topLeft: Radius.circular(10),
              //             topRight: Radius.circular(10),
              //             bottomLeft: Radius.circular(10),
              //             bottomRight: Radius.circular(10)),
              //       ),
              //       child: null),
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          // type == null ? "nothing" : type,
                          carttype[type],
                          // 'ssssss',
                          // textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            height: 1.1,
                            fontFamily: 'Axiforma',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 8.0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: <Widget>[
                    //       Icon(
                    //         Icons.timer,
                    //         color: Colors.grey[500],
                    //         size: 24.0,
                    //         semanticLabel: 'time for shop to deliver',
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 8.0),
                    //         child: Text(
                    //           'widget',
                    //           // overflow: TextOverflow.ellipsis,
                    //           textAlign: TextAlign.left,
                    //           style: TextStyle(
                    //             height: 1.1,
                    //             fontWeight: FontWeight.normal,
                    //             fontSize: 15,
                    //             fontFamily: 'Axiforma',
                    //             color: Colors.grey[500],
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22.0, top: 20, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Your Items",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                  fontFamily: 'Axiforma',
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Column(
            children: [
              for (var i = 0; i < finalcart.length; i++)
                StreamBuilder(
                    stream: Firestore.instance
                        .collection('products')
                        .document(finalcart[i])
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Text("...");
                      }
                      var minimum2 = false;
                      var cartitem = snapshot.data;
                      if (cartmap[cart[i]] == 0) {
                        minimum2 = true;
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              // color: Colors.green,
                              margin:
                                  new EdgeInsets.only(left: 12.0, right: 10),
                              child: Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    // image: DecorationImage(
                                    //   image: NetworkImage(cartitem["image"]),
                                    //   fit: BoxFit.fit,
                                    // ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.07),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 8), // changes position of shadow
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Image.network(cartitem['image'],
                                        height: 60, width: 60),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        cartitem['name'],
                                        // textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          height: 1.1,
                                          fontFamily: 'Axiforma',
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      // mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 0.0),
                                          child: Text(
                                            // Firestore.instance
                                            //     .collection("products")
                                            //     .document(item)
                                            //     .get()
                                            //     .toString(),
                                            (cartitem['shop_price'] *
                                                        cartmap[finalcart[i]])
                                                    .toString() +
                                                'L.L.',
                                            // overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              height: 1.1,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 13.5,
                                              fontFamily: 'Axiforma',
                                              color: Colors.redAccent[700],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            cartitem['unit'],
                                            // overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              height: 1.1,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 13,
                                              fontFamily: 'Axiforma',
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 25,
                                        child: RawMaterialButton(
                                          onPressed: () {
                                            // refreshcartnumbers(
                                            //     cart[i], cartmap[cart[i]] - 1);
                                            // setState(() {});
                                            // loadcart();
                                            refreshcartnumbers(
                                                finalcart[i],
                                                cartmap[finalcart[i]],
                                                cartitem['shop_price'],
                                                false,
                                                false);
                                            // loadcart();
                                          },
                                          elevation: !minimum2 ? 2 : 0,
                                          fillColor: !minimum2
                                              ? Colors.redAccent[700]
                                              : Colors.grey[200],
                                          child: Icon(
                                            Icons.remove,
                                            size: 13,
                                            color: !minimum2
                                                ? Colors.white
                                                : Colors.grey[800],
                                          ),
                                          // padding: EdgeInsets.all(0.0),
                                          shape: CircleBorder(),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 15, 0),
                                        child: new Text(
                                            cartmap[finalcart[i]].toString(),
                                            style:
                                                new TextStyle(fontSize: 14.5)),
                                      ),
                                      SizedBox(
                                        width: 25,
                                        child: RawMaterialButton(
                                          onPressed: () {
                                            refreshcartnumbers(
                                                finalcart[i],
                                                cartmap[finalcart[i]],
                                                cartitem['shop_price'],
                                                true,
                                                false);
                                          },
                                          elevation: !maximum ? 2 : 0,
                                          fillColor: !maximum
                                              ? Colors.redAccent[700]
                                              : Colors.grey[200],
                                          child: Icon(
                                            Icons.add,
                                            size: 13,
                                            color: !maximum
                                                ? Colors.white
                                                : Colors.grey[800],
                                          ),
                                          padding: EdgeInsets.all(0.0),
                                          shape: CircleBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 20, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Total",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                  fontFamily: 'Axiforma',
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 00, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                total.toInt().toString() + 'L.L.',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 25.0,
                    fontFamily: 'Axiforma',
                    color: Colors.redAccent[700]),
              ),
            ),
          ),
          FutureBuilder(
              future: setupVerification(), // async work
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text('Loading....');
                  default:
                    if ((snapshot.hasError)) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Column(
                        children: [
                          Visibility(
                            visible: notsetup ? false : true,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30.0, top: 10, bottom: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Delivering to",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0,
                                        fontFamily: 'Axiforma',
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 30.0,
                                      bottom: 10,
                                      left: 30,
                                      top: 12),
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
                                            Radius.circular(20))),
                                    // color: Colors.grey,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        // Padding(
                                        //   padding: const EdgeInsets.only(left: 15.0),
                                        //   child: Image.asset(
                                        //     'assets/icons/address_enabled.png',
                                        //     height: 30.0,
                                        //     width: 30.0,
                                        //   ),
                                        // ),
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
                                                                left: 6,
                                                                bottom: 5),
                                                        child: Text(
                                                          'Home',
                                                          // textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'Axiforma',
                                                            color: Colors.black,
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
                                                                  left: 8.0,
                                                                  bottom: 8),
                                                          child: Text(
                                                            'This is a demo address so you know',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30.0, top: 10, bottom: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Payment",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0,
                                        fontFamily: 'Axiforma',
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                                Opacity(
                                  opacity: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 30.0,
                                        bottom: 20,
                                        left: 30,
                                        top: 12),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              spreadRadius: 2.2,
                                              blurRadius: 2.5,
                                              offset: Offset(0,
                                                  4), // changes position of shadow
                                            ),
                                          ],
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      // color: Colors.grey,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: Icon(Icons.payment,
                                                  size: 30,
                                                  color: Colors.black)),
                                          Container(
                                              // color: Colors.green,
                                              margin: new EdgeInsets.only(
                                                  left: 10.0,
                                                  right: 0,
                                                  bottom: 0),
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
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10.0,
                                                                  left: 6,
                                                                  bottom: 5),
                                                          child: Text(
                                                            'Cash On Delivery',
                                                            // textAlign: TextAlign.left,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'Axiforma',
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
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
                                                                  left: 8.0,
                                                                  bottom: 8),
                                                          child: Text(
                                                            'Pay when the delivery arrives',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
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
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: usersignedin ? false : true,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 0,
                                onPressed: () {
                                  print("xlicked");
                                  _signInPopUp(context);
                                },
                                color: Colors.redAccent[700],
                                disabledColor: Colors.grey[200],
                                textColor: Colors.white,
                                minWidth: MediaQuery.of(context).size.width,
                                height: 0,
                                // padding: EdgeInsets.zero,
                                padding: EdgeInsets.only(
                                    left: 23, top: 10, right: 23, bottom: 10),
                                child: Text(
                                  "Sign in to continue",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                    fontFamily: 'Axiforma',
                                    // color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: usersignedin ? true : false,
                            child: Visibility(
                              visible: notsetup ? true : false,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(25, 15, 25, 0),
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  elevation: 0,
                                  onPressed: () {
                                    // print("xlicked");
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileScreen()))
                                        .then((_) {
                                      // refreshcart();
                                      setupVerification();
                                      setState(() {});
                                    });
                                  },
                                  color: Colors.redAccent[700],
                                  disabledColor: Colors.grey[200],
                                  textColor: Colors.white,
                                  minWidth: MediaQuery.of(context).size.width,
                                  height: 0,
                                  // padding: EdgeInsets.zero,
                                  padding: EdgeInsets.only(
                                      left: 23, top: 10, right: 23, bottom: 10),
                                  child: Text(
                                    "Setup your profile to continue",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      fontFamily: 'Axiforma',
                                      // color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25, 10, 25, 12),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 0,
                              onPressed: notsetup ? null : () {},
                              color: Colors.redAccent[700],
                              disabledColor: Colors.grey[200],
                              textColor: Colors.white,
                              minWidth: MediaQuery.of(context).size.width,
                              height: 0,
                              // padding: EdgeInsets.zero,
                              padding: EdgeInsets.only(
                                  left: 23, top: 12, right: 23, bottom: 10),
                              child: Text(
                                "Confirm Order",
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
                      );
                    }
                }
              }),
          Text(usersignedin ? "user is signed in" : "user not signed in"),
          Text(notsetup ? "user is not setup" : "user is setup"),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
            child: Center(
              child: SizedBox(
                width: width - 44,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: Icon(
                        Icons.info,
                        size: 18,
                        color: Colors.grey[500],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "All meal baskets come with a detailed cooking instructions!",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12.0,
                          fontFamily: 'Axiforma',
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
