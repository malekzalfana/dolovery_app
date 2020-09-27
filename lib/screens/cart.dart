import 'dart:convert';

import 'package:dolovery_app/screens/editadress.dart';
import 'package:dolovery_app/screens/salleitem.dart';
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

import 'orderpage.dart';

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
      // print(_n);
    });
  }

  void minus() {
    // print(_n);
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
  List<String> shops;
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
    prefs.remove('shops');
    prefs.remove('usercartmap');
    prefs.remove('cached_shops');
    prefs.remove('address');
    Navigator.of(context).pop();
    // print(prefs.getKeys());
    return true;
  }

  // Future<void> refreshcartnumbers(
  //     String itemid, int quantity, int price, bool add, bool remove) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   // List<String> cart = prefs.getStringList('cart');

  //   // setState(() {

  //   if (remove) {
  //     for (var i; i <= quantity; i++) {
  //       print('removed completely');
  //       prefs.setDouble('items', prefs.getDouble('items') - quantity);
  //       prefs.setDouble(
  //           'total',
  //           prefs.getDouble('total') -
  //               (quantity * int.parse(price.toString())));
  //       cart.remove(itemid);
  //     }
  //   } else {
  //     if (add) {
  //       // print(prefs.getDouble('cart'));
  //       prefs.setDouble('items', prefs.getDouble('items') + 1);
  //       prefs.setDouble('total',
  //           prefs.getDouble('total') + (1 * int.parse(price.toString())));

  //       print('added');
  //       cart.add(itemid);
  //       print(itemid);
  //     } else {
  //       print('removed');
  //       prefs.setDouble('items', prefs.getDouble('items') - 1);
  //       prefs.setDouble('total',
  //           prefs.getDouble('total') - (1 * int.parse(price.toString())));
  //       cart.remove(itemid);
  //       if (cart.length == 0) {
  //         reset();

  //         return print('XXXXXXXXXXXXX');
  //       }
  //     }
  //   }
  //   prefs.setStringList('cart', cart);
  //   print(prefs.getStringList('cart'));

  //   // print(cart);
  //   // });

  //   // getcartmap();
  // }
  dynamic usercartmap;

  _save(itemid, rate, shop_name, type, shop_price, currency) async {
    add();
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart');
    // String shop_name = data.documents[index]['shop'];
    // START
    usercartmap = prefs.getString("usercartmap");
    // prefs.remove('usercartmap');
    if (usercartmap == null) {
      usercartmap = {};
      // print('made an empty map');
    } else {
      usercartmap = json.decode(usercartmap);
      // print('found the map');
      // print(json.encode(usercartmap));
    }
    if (usercartmap.containsKey(shop_name)) {
      if (usercartmap[shop_name].containsKey(itemid)) {
        usercartmap[shop_name][itemid] =
            int.parse(usercartmap[shop_name][itemid].toString()) + 1;
      } else {
        usercartmap[shop_name][itemid] = 1;
      }
    } else {
      usercartmap[shop_name] = {};
      usercartmap[shop_name][itemid] = 1;
    }
    prefs.setString('usercartmap', json.encode(usercartmap));
    // print(prefs.getString('usercartmap'));
    // String type = data.documents[index][
    //     'type']; //prefs.getString('type') == null? 'nothing': prefs.getString('type');
    prefs.setString('type', type);
    if (prefs.getDouble('total') == null) {
      prefs.setDouble('total', 0);
    }
    // var shop_price =
    //     int.parse(data.documents[index]['shop_price'].toString()).toDouble();
    if (currency == 'dollar') {
      rate = 1;
    }
    double total = prefs.getDouble('total') == null
        ? 0
        : prefs.getDouble('total') + shop_price;
    prefs.setDouble('total', total);
    if (cart == null) {
      cart = [];
    }
    cart.add(itemid);
    final value = cart;
    final double items = cart.length.toDouble();
    prefs.setDouble('items', items);
    prefs.setStringList('cart', value);
    List<String> shops = prefs.getStringList('shops');
    if (shops == null) {
      shops = [];
    }

    // print(shop_name);
    // print('shopaboive______________');
    if (!shops.contains(shop_name)) {
      shops.add(shop_name);
      prefs.setStringList("shops", shops);
    }

    // print('saved $value');
    // print('saved $total');
    // print('saved $type');
    // print('saved $items');
  }

  _remove(itemid, rate, shop_name, type, shop_price, currency) async {
    minus();
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart');
    // String shop_name = data.documents[index]['shop'];
    // START
    usercartmap = prefs.getString("usercartmap");
    // prefs.remove('usercartmap');
    if (usercartmap == null) {
      usercartmap = {};
      // print('made an empty map');
    } else {
      usercartmap = json.decode(usercartmap);
      // print('found the map');
      // print(json.encode(usercartmap));
    }
    if (usercartmap.containsKey(shop_name)) {
      if (usercartmap[shop_name].containsKey(itemid)) {
        usercartmap[shop_name][itemid] =
            int.parse(usercartmap[shop_name][itemid].toString()) - 1;
        if (usercartmap[shop_name][itemid] == 0) {
          usercartmap[shop_name].remove(itemid);
        }
      }
    }
    prefs.setString('usercartmap', json.encode(usercartmap));
    // print(prefs.getString('usercartmap'));
    // String type = data.documents[index][
    //     'type']; //prefs.getString('type') == null? 'nothing': prefs.getString('type');
    prefs.setString('type', type);
    if (prefs.getDouble('total') == null) {
      prefs.setDouble('total', 0);
    }

    // var shop_price =
    //     int.parse(data.documents[index]['shop_price'].toString()).toDouble();
    if (currency == 'dollar') {
      rate = 1;
    }
    double total = prefs.getDouble('total') == null
        ? 0
        : prefs.getDouble('total') - shop_price;
    prefs.setDouble('total', total);
    if (cart == null) {
      cart = [];
    }
    cart.remove(itemid);
    final value = cart;
    final double items = cart.length.toDouble();
    prefs.setDouble('items', items);
    prefs.setStringList('cart', value);
    List<String> shops = prefs.getStringList('shops');
    if (shops == null) {
      shops = [];
    }

    // print(shop_name);
    // print('shopaboive______________');
    if (!shops.contains(shop_name)) {
      shops.remove(shop_name);
      prefs.setStringList("shops", shops);
    }
    // print('saved $value');
    // print('saved $total');
    // print('saved $type');
    // print('saved $items');
    if (cart.length == 0) {
      reset();

      return print('XXXXXXXXXXXXX');
    }

    // print('saved $value');
    // print('saved $total');
    // print('saved $type');
    // print('saved $items');
  }

  // List supplementsCart = [];
  // List supplementsCart = [];
  // List supplementsCart = [];
  // List supplementsCart = [];
  Map cartshopsproductsmap = {};
  Map cartshopsmap = {};
  getcartmap() async {
    for (var cartshop in shops) {
      // print("started" + cartshop.toString());

      for (var cartitem in finalcart) {
        // print("started item: " + cartitem.toString());
        Firestore.instance
            .collection("products")
            .document(cartitem)
            .get()
            .then((value) {
          // print("shop 1 =" + value.data['shop'].toString());
          // print("shop §1 =" + cartshop.toString());
          if (value.data['shop'] == cartshop.toString()) {
            if (!cartshopsproductsmap.containsKey(cartitem)) {
              cartshopsproductsmap[cartitem] = 1;
              // print("counting********* " +
              cartshopsproductsmap[cartitem].toInt();
              // finalcart.add(cart[i]);
            } else {
              cartshopsproductsmap[cartitem] =
                  cartshopsproductsmap[cartitem].toInt() + 1;
              // print("counting:::::::::: " +
              //     cartshopsproductsmap[cartitem].toInt());
            }
            // cartshopsproductsmap.add(cartitem.toString());
            // print(cartshopsproductsmap);
            cartshopsmap[cartshop.toString()] = cartshopsproductsmap;
          }
        });
      }
      // print("shopmap_____________");
      // print(cartshopsmap);
    }
  }

  bool torestart = true;

  Future<void> loadcart2() async {
    final prefs = await SharedPreferences.getInstance();

    if (torestart)
      setState(() {
        type = prefs.getString('type');
        total = prefs.getDouble('total');
        items = prefs.getDouble('items');
        cart = prefs.getStringList('cart');
        shops = prefs.getStringList('shops');
        if (type == 'supplements') {
          imagetype = 'assets/images/supsec.png';
        } else if (type == 'pets') {
          imagetype = 'assets/images/petsec.png';
        } else if (type == 'lebanese') {
          imagetype = 'assets/images/lebsec.jpg';
        } else {
          imagetype = 'assets/images/salle.png';
        }

        for (var cartshop in shops) {
          // print("started" + cartshop.toString());
          Map cartshopsproductsmap = {};
          for (var cartitem in cart) {
            // print("started item: " + cartitem.toString());
            Firestore.instance
                .collection("products")
                .document(cartitem)
                .get()
                .then((value) {
              // print("shop 1 =" + value.data['shop'].toString());
              // print("shop §1 =" + cartshop.toString());
              if (value.data['shop'] == cartshop.toString()) {
                if (!cartshopsproductsmap.containsKey(cartitem)) {
                  cartshopsproductsmap[cartitem] = 1;
                  // print("added product to map_____________");
                  // print(cartshopsproductsmap[cartitem].toString());
                  finalcart.add(cartshopsproductsmap[cartitem].toString());
                } else {
                  // print("counting:::::::::: ");
                  //     cartshopsproductsmap[cartitem].toInt().toString());
                  cartshopsproductsmap[cartitem] =
                      cartshopsproductsmap[cartitem].toInt() + 1;
                }
                // cartshopsproductsmap.add(cartitem.toString());
                // print(cartshopsproductsmap);
                cartshopsmap[cartshop.toString()] = cartshopsproductsmap;
              }
            });
          }

          // print("shopmap_____________");
          // print(cartshopsmap);
        }
        torestart = false;
        // final finalshops = await cartshopsmap;
        return shops;
      });
  }

  // dynamic usercartmap;
  Future<bool> loadcart() async {
    final prefs = await SharedPreferences.getInstance();
    usercartmap = prefs.getString("usercartmap");
    usercartmap = json.decode(usercartmap);
    print(usercartmap);
    print('this is the cart ');

    if (torestart)
      setState(() {
        type = prefs.getString('type');
        total = prefs.getDouble('total');
        items = prefs.getDouble('items');
        cart = prefs.getStringList('cart');
        shops = prefs.getStringList('shops');
        if (type == 'supplements') {
          imagetype = 'assets/images/supsec.png';
        } else if (type == 'pets') {
          imagetype = 'assets/images/petsec.png';
        } else if (type == 'lebanese') {
          imagetype = 'assets/images/lebsec.jpg';
        } else {
          imagetype = 'assets/images/salle.png';
        }

        torestart = false;
        // final finalshops = await cartshopsmap;
        // return shops;
        return true;
      });
  }

  @override
  void initState() {
    // getcartmap();
    setupVerification();
    // loadcart();
    super.initState();
    loadcart();
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
    setState(() {});
    showModalBottomSheet(
        isDismissible: false,
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
                FutureBuilder(
                  future: setupVerification(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Text('Loading....');
                      default:
                        if (snapshot.hasError)
                          return Text('Error: ${snapshot.error}');
                        else
                          return Visibility(
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
                          );
                    }
                  },
                ),
              ],
            ),
          );
        });
    setState(() {});
  }

  addAddressToCart(cartaddress) async {
    final prefs = await SharedPreferences.getInstance();
    var newcartaddress;

    prefs.setString('address', json.encode(cartaddress));
    // print('thi is the new address');
    // print(prefs.getString('address'));
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
      bool hasprofile = false;
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
      // print("signed in " + user.uid);
      Navigator.of(context).pop();
      _welcomePopUp(context, user.displayName);
      // used before user.uid
      final notsetup =
          await Firestore.instance.collection("users").document(user.uid).get();
      if (!notsetup.exists) {
        // print("user exists");
        hasprofile = true;
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

  bool alreadyChosenAddress = false;

  removeShopFromCart(shop) async {
    final prefs = await SharedPreferences.getInstance();
    usercartmap = prefs.getString("usercartmap");
    // prefs.remove('usercartmap');
    if (usercartmap == null) {
      usercartmap = {};
    } else {
      usercartmap = json.decode(usercartmap);
    }
    usercartmap.remove(shop);
    prefs.setString('usercartmap', json.encode(usercartmap));
  }

  Future setupVerification() async {
    // print("USER BEING WATCHED");
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final prefs = await SharedPreferences.getInstance();

    if (user != null) {
      uid = user.uid;
      name = user.displayName;
      uemail = user.email;
      // print("USERNAME")
      this_user =
          await Firestore.instance.collection("users").document(uid).get();
      if (!alreadyChosenAddress) {
        chosen_address = this_user.data["chosen_address"];
      }
      // print("checking addresssss");
      if (!prefs.containsKey('address')) {
        // print("no addressssss");
        var counter = 0;
        for (var useraddress in this_user.data['address']) {
          // print(this_user.data['address'][counter]);
          if (useraddress['id'] == chosen_address) {
            // print('added');
            prefs.setString(
                'address', this_user.data['address'][counter].toString());
          }
          counter++;
        }
      }

      // print(this_user.data['number']);
      // print(widget.thisUser);

      if (this_user.exists) {
        notsetup = false;
        // print("user is setup");
      }
    } else {
      usersignedin = false;
      // print("usre is not signed in");
    }

    // return this_user;
  }

  selectAddress(String chosenAddress, int addressIndex) {
    // print(chosenAddress);
    // print(addressIndex);
    setState(() {
      chosen_address = chosenAddress;
      alreadyChosenAddress = true;
    });
  }

  bool loadingorder = false;
  String chosen_address;
  @override
  Widget build(BuildContext context) {
    // final double itemHeight = (size.height) /x 2;
    // final double itemWidth = size.width / 2;
    // new Date(widget.data.documents[0]['salle_date'].seconds * 1000 + widget.data.documents[0]['salle_date'].nanoseconds/1000000)
    // var date = DateTime.fromMicrosecondsSinceEpoch(
    // widget.data.documents[0]['salle_date']);

    // var timestamp =
    //     (widget.data.documents[0]['salle_date'] as Timestamp).toDate();
    num _defaultValue = 0;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // print(cart);
    List<Widget> list = new List<Widget>();
    // setupVerification();
    // setState(() {});
    // String formatted_date = DateFormat.yMMMMd().format(timestamp);
    return new Scaffold(
      body: SingleChildScrollView(
          child: FutureBuilder(
        future: loadcart(),
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                  child: Image.asset("assets/images/loading.gif", height: 30));
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else if (loadingorder)
                return SizedBox(
                  height: height,
                  child: Center(
                      child:
                          Image.asset("assets/images/loading.gif", height: 30)),
                );
              else
                return Column(
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
                      actions: [
                        GestureDetector(
                          onTap: () {
                            reset();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Icon(Icons.delete),
                          ),
                        ),
                        // Icon(Icons.add),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 22.0, top: 20, bottom: 10),
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
                        for (var shop in usercartmap.keys)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                FutureBuilder(
                                    future: getRate(shop),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return Text('Loading....');
                                        default:
                                          if (snapshot.hasError)
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          if (usercartmap[shop].keys.length ==
                                              0) {
                                            removeShopFromCart(shop);
                                            return Container();
                                          }
                                          return Column(
                                            children: [
                                              FutureBuilder(
                                                future: getShop(shop),
                                                builder: (context, snapshot) {
                                                  switch (snapshot
                                                      .connectionState) {
                                                    case ConnectionState
                                                        .waiting:
                                                      return Text(
                                                          'Loading....');
                                                    default:
                                                      if (snapshot.hasError)
                                                        return Text(
                                                            'Error: ${snapshot.error}');
                                                      else
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 22.0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              snapshot
                                                                  .data['name'],
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontSize:
                                                                      23.0,
                                                                  fontFamily:
                                                                      'Axiforma',
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        );
                                                  }
                                                },
                                              ),
                                              // StreamBuilder(
                                              //     stream: Firestore.instance
                                              //         .collection('shops')
                                              //         .where('username', isEqualTo: shop)
                                              //         .snapshots(),
                                              //     builder: (context, snapshot) {
                                              //       var shopinfo =
                                              //           snapshot.data.docuemnts[0];

                                              //       return Text(
                                              //         shopinfo['name'],
                                              //         textAlign: TextAlign.left,
                                              //         style: TextStyle(
                                              //             fontWeight: FontWeight.w800,
                                              //             fontSize: 25.0,
                                              //             fontFamily: 'Axiforma',
                                              //             color: Colors.black),
                                              //       );
                                              //     }),
                                              for (var product
                                                  in usercartmap[shop].keys)
                                                StreamBuilder<Object>(
                                                    stream: Firestore.instance
                                                        .collection("products")
                                                        // .where('id', isEqualTo: product)
                                                        .document(
                                                            product.toString())
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      print(
                                                          'we are past streaming');
                                                      print(snapshot.data);
                                                      print(product);
                                                      print(int.parse(
                                                          usercartmap[shop]
                                                                  [product]
                                                              .toString()));
                                                      if (snapshot.hasData) {
                                                        return buildCartItem(
                                                            snapshot.data,
                                                            int.parse(usercartmap[
                                                                        shop]
                                                                    [product]
                                                                .toString()),
                                                            rate);
                                                      } else {
                                                        return CircularProgressIndicator();
                                                      }
                                                    })
                                            ],
                                          );
                                      }
                                    }),
                              ],
                            ),
                          ),
                      ],
                    ),
                    FutureBuilder(
                      future: getTotal(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 30.0, top: 20, bottom: 10),
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
                                padding: const EdgeInsets.only(
                                    left: 30.0, top: 00, bottom: 10),
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
                            ],
                          );
                        }
                        return CircularProgressIndicator(); // or some other widget
                      },
                    ),

                    // fixxxxxx
                    FutureBuilder(
                        future: setupVerification(), // async work
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Visibility(
                                  visible: false, child: Text('Loading....'));
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
                                                left: 30.0,
                                                top: 10,
                                                bottom: 10),
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
                                          if (usersignedin)
                                            for (var index = 0;
                                                index <
                                                    this_user
                                                        .data["address"].length;
                                                index++)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 30.0,
                                                    bottom: 10,
                                                    left: 30,
                                                    top: 12),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // print(this_user.data["address"]);
                                                    // chosen_address ==
                                                    //     this_user.data["address"][index]
                                                    //         ["id"];
                                                    // print(isDefault);
                                                    print(
                                                        "______________________");
                                                    if (this_user
                                                            .data["address"]
                                                            .length >
                                                        1) {
                                                      selectAddress(
                                                          this_user.data[
                                                                  "address"]
                                                              [index]["id"],
                                                          index);
                                                      addAddressToCart(this_user
                                                              .data["address"]
                                                          [index]);
                                                    }
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.1),
                                                            spreadRadius: 2.2,
                                                            blurRadius: 2.5,
                                                            offset: Offset(0,
                                                                4), // changes position of shadow
                                                          ),
                                                        ],
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15))),
                                                    // color: Colors.grey,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        IconButton(
                                                            icon: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                              child: Icon(
                                                                Icons.place,
                                                                color: chosen_address ==
                                                                        this_user.data["address"][index]
                                                                            [
                                                                            "id"]
                                                                    ? Colors
                                                                        .black
                                                                    : Colors.grey[
                                                                        400],
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
                                                            margin:
                                                                new EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right: 0),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.5),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                10.0,
                                                                            left:
                                                                                0,
                                                                            bottom:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          this_user.data["address"][index]
                                                                              [
                                                                              "name"],
                                                                          // textAlign: TextAlign.left,
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                'Axiforma',
                                                                            color: chosen_address == this_user.data["address"][index]["id"]
                                                                                ? Colors.black
                                                                                : Colors.grey[500],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 0),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 0.0,
                                                                              bottom: 8),
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width - 145,
                                                                            child:
                                                                                Text(
                                                                              this_user.data["address"][index]["street_address"],
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textAlign: TextAlign.left,
                                                                              style: TextStyle(
                                                                                height: 1.1,
                                                                                fontWeight: FontWeight.normal,
                                                                                fontSize: 14.5,
                                                                                fontFamily: 'Axiforma',
                                                                                color: Colors.grey[500],
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
                                              ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 30.0,
                                                top: 10,
                                                bottom: 10),
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
                                                        color: Colors.grey
                                                            .withOpacity(0.1),
                                                        spreadRadius: 2.2,
                                                        blurRadius: 2.5,
                                                        offset: Offset(0,
                                                            4), // changes position of shadow
                                                      ),
                                                    ],
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                14))),
                                                // color: Colors.grey,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 15.0),
                                                        child: Icon(
                                                            Icons.payment,
                                                            size: 30,
                                                            color:
                                                                Colors.black)),
                                                    Container(
                                                        // color: Colors.green,
                                                        margin:
                                                            new EdgeInsets.only(
                                                                left: 10.0,
                                                                right: 0,
                                                                bottom: 0),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.5),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10.0,
                                                                        left: 6,
                                                                        bottom:
                                                                            5),
                                                                    child: Text(
                                                                      'Cash On Delivery',
                                                                      // textAlign: TextAlign.left,
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            'Axiforma',
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0,
                                                                        bottom:
                                                                            8),
                                                                    child: Text(
                                                                      'Pay when the delivery arrives',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style:
                                                                          TextStyle(
                                                                        height:
                                                                            1.1,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        fontSize:
                                                                            14.5,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            25, 15, 25, 0),
                                        child: MaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          elevation: 0,
                                          onPressed: () {
                                            print("xlicked");
                                            _signInPopUp(context);
                                          },
                                          color: Colors.redAccent[700],
                                          disabledColor: Colors.grey[200],
                                          textColor: Colors.white,
                                          minWidth:
                                              MediaQuery.of(context).size.width,
                                          height: 0,
                                          // padding: EdgeInsets.zero,
                                          padding: EdgeInsets.only(
                                              left: 23,
                                              top: 10,
                                              right: 23,
                                              bottom: 10),
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
                                        visible: notsetup ? false : false,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              25, 15, 25, 0),
                                          child: MaterialButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
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
                                            minWidth: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 0,
                                            // padding: EdgeInsets.zero,
                                            padding: EdgeInsets.only(
                                                left: 23,
                                                top: 10,
                                                right: 23,
                                                bottom: 10),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          25, 10, 25, 12),
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        elevation: 0,
                                        onPressed: notsetup || loadingorder
                                            ? null
                                            : () {
                                                // setState(() {
                                                //   loadingorder = true;
                                                // });
                                                // List products;
                                                // var cartproduct;
                                                // // define snapshots to use for looping
                                                // for (var i;
                                                //     i <= finalcart.length;
                                                //     i++) {
                                                //   cartproduct = Firestore
                                                //       .instance
                                                //       .collection("products")
                                                //       .document(finalcart[i])
                                                //       .get();
                                                //   Map<String, dynamic> product =
                                                //       {
                                                //     "name": cartproduct
                                                //         .data['name'],
                                                //     "shop_price": cartproduct,
                                                //     "quantity": cartproduct,
                                                //     "unit": cartproduct
                                                //   };
                                                //   products.add(product);
                                                // }
                                                // Firestore.instance
                                                //     .collection('orders')
                                                //     .document("zxxxxxxxxx")
                                                //     .setData({
                                                //   "address": "address",
                                                //   "total": "total",
                                                //   "count": "4",
                                                //   "payment": "cashondelivery",
                                                //   "date": "today",
                                                //   "shop": "shop username",
                                                //   "products": products,
                                                //   "user": uid,
                                                //   "user name": "user name",
                                                //   "item_list": "list of ids"
                                                // }).then((result) {
                                                //   print("order added");
                                                // }).catchError((onError) {
                                                //   print("onError");
                                                // });
                                                // var thecartaddress;
                                                // var

                                                // XXXXXXX
                                                // Firestore.instance
                                                //     .collection('shop_orders')
                                                //     .getDocuments()
                                                //     .then((snapshot) {
                                                //   for (DocumentSnapshot ds
                                                //       in snapshot.documents) {
                                                //     ds.reference.delete();
                                                //   }
                                                //   ;
                                                // });
                                                // Navigator.pop(context);

                                                getCartAddress() async {
                                                  final prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  var thecartaddress = json
                                                      .encode(prefs.getString(
                                                          'address'));
                                                  print(thecartaddress);
                                                  List<String> fullorder = [];
                                                  List<String> fullorder_shops =
                                                      [];
                                                  var completeproducts = {};
                                                  for (var cartshop
                                                      in usercartmap.keys) {
                                                    completeproducts[cartshop] =
                                                        {};
                                                    var datashop =
                                                        await Firestore.instance
                                                            .collection("shops")
                                                            .where('username',
                                                                isEqualTo:
                                                                    cartshop)
                                                            .getDocuments();
                                                    var rate = datashop
                                                        .documents[0]
                                                        .data['rate'];
                                                    if (rate == null) {
                                                      rate = 1;
                                                    }
                                                    for (var product
                                                        in usercartmap[cartshop]
                                                            .keys) {
                                                      print(
                                                          'looping through $product');
                                                      var dataproduct =
                                                          await Firestore
                                                              .instance
                                                              .collection(
                                                                  "products")
                                                              .document(product)
                                                              .get();
                                                      var newrate = rate;
                                                      if (dataproduct.data[
                                                              'currency'] !=
                                                          'dollar') {
                                                        newrate = 1;
                                                      }
                                                      print(dataproduct
                                                          .documentID);
                                                      completeproducts[cartshop]
                                                          [product] = {
                                                        'name': dataproduct
                                                            .data['name'],
                                                        'count': usercartmap[
                                                            cartshop][product],
                                                        'shop_price': dataproduct
                                                                        .data[
                                                                    'type'] !=
                                                                'salle'
                                                            ? int.parse(dataproduct
                                                                    .data[
                                                                        'shop_price']
                                                                    .toString()) *
                                                                newrate
                                                            : dataproduct.data[
                                                                    'serving_prices']
                                                                [usercartmap[
                                                                        cartshop]
                                                                    [product]],
                                                        'shop_discounted':
                                                            dataproduct.data[
                                                                'shop_discounted'],
                                                        'unit': dataproduct
                                                            .data['unit'],
                                                        'image': dataproduct
                                                            .data['image'],
                                                        'type': dataproduct
                                                            .data['type'],
                                                        'arabic_name':
                                                            dataproduct.data[
                                                                'arabic_name']
                                                      };
                                                    }
                                                    print(completeproducts);
                                                    print(completeproducts[
                                                        cartshop]);
                                                    print(
                                                        'starting orderinggggggggggggggggggggggg');
                                                    var order_id = ">>" +
                                                        UniqueKey()
                                                            .hashCode
                                                            .toString();
                                                    Firestore.instance
                                                        .collection(
                                                            'shop_orders')
                                                        .document(order_id)
                                                        .setData({
                                                      "address": thecartaddress,
                                                      "total": total.toInt(),
                                                      "count":
                                                          usercartmap[cartshop]
                                                              .length,
                                                      "payment":
                                                          "cashondelivery",
                                                      "date": DateTime.now(),
                                                      "shop": cartshop,
                                                      "products":
                                                          completeproducts[
                                                              cartshop],
                                                      "user": uid,
                                                    });
                                                    fullorder.add(order_id);
                                                    fullorder_shops
                                                        .add(cartshop);
                                                  }
                                                  // for (var shop
                                                  //     in usercartmap.keys) {
                                                  //   print(
                                                  //       'starting orderinggggggggggggggggggggggg');
                                                  //   var order_id = UniqueKey()
                                                  //       .hashCode
                                                  //       .toString();
                                                  //   Firestore.instance
                                                  //       .collection(
                                                  //           'shop_orders')
                                                  //       .document(order_id)
                                                  //       .setData({
                                                  //     "address": thecartaddress,
                                                  //     "total": total.toInt(),
                                                  //     "count": usercartmap[shop]
                                                  //         .length,
                                                  //     "payment":
                                                  //         "cashondelivery",
                                                  //     "date": DateTime.now(),
                                                  //     "shop": shop,
                                                  //     "products":
                                                  //         usercartmap[shop],
                                                  //     "user": uid,
                                                  //   });
                                                  //   fullorder.add(order_id);
                                                  //   fullorder_shops.add(shop);
                                                  // }
                                                  var fullorder_id = UniqueKey()
                                                      .hashCode
                                                      .toString();
                                                  Firestore.instance
                                                      .collection('orders')
                                                      .document(fullorder_id)
                                                      .setData({
                                                    "address": thecartaddress,
                                                    "total": total.toInt(),
                                                    "count": items,
                                                    "payment": "cashondelivery",
                                                    "date": DateTime.now(),
                                                    "products":
                                                        completeproducts,
                                                    "user": uid,
                                                    "shop_list":
                                                        fullorder_shops,
                                                    "order_list": fullorder
                                                  }).then((doc) {
                                                    print(fullorder_id);
                                                    Navigator.pop(context);

                                                    // loadingorder = true;
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                OrderPage(
                                                                    fullorder_id)));
                                                  }).catchError((error) {
                                                    print(error);
                                                  });
                                                }

                                                getCartAddress();

                                                // final thecartaddress =
                                                //     getCartAddress();
                                              },
                                        color: Colors.redAccent[700],
                                        disabledColor: Colors.grey[200],
                                        textColor: Colors.white,
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        height: 0,
                                        // padding: EdgeInsets.zero,
                                        padding: EdgeInsets.only(
                                            left: 23,
                                            top: 12,
                                            right: 23,
                                            bottom: 10),
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
                    Text(usersignedin
                        ? "user is signed in"
                        : "user not signed in"),
                    Text(notsetup ? "user is not setup" : "user is setup"),
                    Visibility(
                      visible: false,
                      child: Padding(
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
                                // Expanded(
                                //   child: Text(
                                //     "All meal baskets come with a detailed cooking instructions!",
                                //     style: TextStyle(
                                //       fontWeight: FontWeight.normal,
                                //       fontSize: 12.0,
                                //       fontFamily: 'Axiforma',
                                //       color: Colors.grey[500],
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
          }
        },
      )),
    );
  }

  dynamic shopinfo;
  bool started = false;
  dynamic cachedshops;
  int rate = 1;
  getTotal() async {
    final prefs = await SharedPreferences.getInstance();
    total = prefs.getDouble('total');
    if (total < 1) {
      reset();
      Navigator.pop(context);
    }
    return total;
  }

  // dynamic shopdetails;
  getShop(shop) async {
    // print('seraching for: $shop');
    var document = await Firestore.instance
        .collection('shops')
        .where("username", isEqualTo: shop)
        .getDocuments();
    return document.documents[0];
  }

  getRate(shopName) async {
    if (started == true) {
      // print('skipedddddddd');
      return rate;
    }
    print(
        "started prefrererererererere_______________________________________________________________");
    final prefs = await SharedPreferences.getInstance();
    bool skip = false;
    cachedshops = prefs.getString("cached_shops");
    if (cachedshops != null) {
      cachedshops = json.decode(cachedshops);
    } else {
      cachedshops = {};
      skip = true;
    }
    if (!cachedshops.containsKey(shopName)) {
      shopinfo = Firestore.instance
          .collection('shops')
          .where('username', isEqualTo: shopName)
          .getDocuments()
          .then(
        (value) {
          if (value.documents.length > 0) {
            cachedshops[shopName] = value.documents[0].data['rate'];
            prefs.setString('cached_shops', json.encode(cachedshops));
            // print(prefs.getString("cached_shops").toString() +
            //     "this is the cached");
            started = true;
            return rate = value.documents[0].data['rate'];
          } else {
            return null;
          }
        },
      );
    } else {
      // cachedshops[shopName] = value.documents[0].data['rate'];
      // print("xxxxxxxxxxxxxxxxxxxxxxxxxxxx");
      rate = json.decode(prefs.getString("cached_shops"))[shopName];
      // print(prefs.getString("cached_shops"));
      started = true;
      // print("just got: " + rate.toString());
    }
    // debugPrint("rate is:::::" + rate.toString());
    started = true;
    // return rate = 1;
  }

  // Widget buildShopName(shop) {
  //   return FutureBuilder(
  //       future: getRate(shop),
  //       builder: (context, snapshot) {
  //         return Text(
  //           shop,
  //           textAlign: TextAlign.left,
  //           style: TextStyle(
  //               fontWeight: FontWeight.w800,
  //               fontSize: 25.0,
  //               fontFamily: 'Axiforma',
  //               color: Colors.black),
  //         );
  //       });
  // }

  Padding buildCartItem(DocumentSnapshot cartitem, int count, int rate) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (cartitem['currency'] != "dollar") {
      rate = 1;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            // color: Colors.green,
            margin: new EdgeInsets.only(left: 12.0, right: 10),
            child: Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.07),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 8), // changes position of shadow
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
                  child:
                      Image.network(cartitem['image'], height: 60, width: 60),
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
                    SizedBox(
                      width: width - 150,
                      child: Text(
                        cartitem['name'],
                        // textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                          height: 1.16,
                          fontFamily: 'Axiforma',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: cartitem['type'] == 'salle' &&
                      cartitem['arabic_name'] != null,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: SizedBox(
                      width: width - 150,
                      child: Text(
                        cartitem['arabic_name'] != null
                            ? cartitem['arabic_name']
                            : '',
                        // textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          height: 1.1,
                          fontFamily: 'Axiforma',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Row(
                          children: [
                            Visibility(
                              visible:
                                  cartitem['type'] == 'salle' ? false : true,
                              child: Text(
                                (int.parse(cartitem['shop_price'].toString()) *
                                            int.parse(rate.toString()))
                                        .toString() +
                                    "L.L.",
                                // overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,

                                style: TextStyle(
                                  height: 1.1,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13.5,
                                  fontFamily: 'Axiforma',
                                  color: Colors.redAccent[700],
                                ),
                              ),
                            ),
                            Visibility(
                              visible:
                                  cartitem['type'] == 'salle' ? true : false,
                              child: Text(
                                cartitem['serving_prices'] != null
                                    ? cartitem['serving_prices'][count]
                                            .toString() +
                                        "L.L."
                                    : "",
                                // overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  height: 1.1,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13.5,
                                  fontFamily: 'Axiforma',
                                  color: Colors.redAccent[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: cartitem['type'] == 'salle' ? false : true,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            cartitem['unit'].toString(),
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
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: cartitem['type'] == 'salle' ? true : false,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(1, 0, 0, 0),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => SalleItem(
                                    cartitem,
                                    cartitem['day'],
                                    cartitem['serving_prices'],
                                    cartitem['descriptions'])))
                            .then((_) {
                          setState(() {});
                        });
                      },
                      color: Colors.redAccent[700],
                      textColor: Colors.white,
                      minWidth: 0,
                      height: 0,
                      // padding: EdgeInsets.zero,
                      padding:
                          EdgeInsets.only(left: 6, top: 2, right: 6, bottom: 1),
                      child: Text(
                        (count + 1).toString() + ' Servings',
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
                // ),
                //  Visibility(
                //   visible: cartitem['type'] == 'salle' ? false : true,
                //   child: Container(
                //     child: Text()
                //   )),
                Visibility(
                  visible: cartitem['type'] == 'salle' ? false : true,
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 25,
                        child: RawMaterialButton(
                          onPressed: () {
                            _remove(
                                cartitem.documentID,
                                rate,
                                cartitem['shop'],
                                cartitem['type'],
                                (int.parse(cartitem['shop_price'].toString()) *
                                    int.parse(rate.toString())),
                                cartitem['currency']);
                          },
                          elevation: 2,
                          fillColor: Colors.redAccent[700],
                          child: Icon(
                            Icons.remove,
                            size: 13,
                            color: Colors.white,
                          ),
                          // padding: EdgeInsets.all(0.0),
                          shape: CircleBorder(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: new Text(count.toString(),
                            style: new TextStyle(fontSize: 14.5)),
                      ),
                      SizedBox(
                        width: 25,
                        child: RawMaterialButton(
                          onPressed: () {
                            //   refreshcartnumbers(
                            //       cartitem.documentID,
                            //       count,
                            //       int.parse(cartitem['shop_price'].toString()),
                            //       true,
                            //       false);
                            // },
                            _save(
                                cartitem.documentID,
                                rate,
                                cartitem['shop'],
                                cartitem['type'],
                                (int.parse(cartitem['shop_price'].toString()) *
                                    int.parse(rate.toString())),
                                cartitem['currency']);
                          },
                          elevation: !maximum ? 2 : 0,
                          fillColor: !maximum
                              ? Colors.redAccent[700]
                              : Colors.grey[200],
                          child: Icon(
                            Icons.add,
                            size: 13,
                            color: !maximum ? Colors.white : Colors.grey[800],
                          ),
                          padding: EdgeInsets.all(0.0),
                          shape: CircleBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
