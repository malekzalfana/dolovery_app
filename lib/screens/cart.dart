import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dolovery_app/screens/editadress.dart';
import 'package:dolovery_app/screens/salleitem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dolovery_app/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:delayed_display/delayed_display.dart';

import 'orderpage.dart';

class Cart extends StatefulWidget {
  final dynamic user;

  Cart(this.user, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CartState();
}

class _CartState extends State<Cart> {
  int _n = 1;
  bool minimum = true;
  bool maximum = false;

  List<String> finalcart = [];

  void add() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      total = prefs.getDouble('total');
      if (_n < 10) _n++;
      if (_n == 30) {
        maximum = true;
      } else {
        minimum = false;
        maximum = false;
      }
    });
  }

  void minus() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      total = prefs.getDouble('total');
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

  Future<void> reset([bool pop]) async {
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
    if (pop != false) {
      Navigator.of(context).pop();
    }

    return true;
  }

  dynamic usercartmap;

  _save(itemid, rate, shop_name, type, shop_price, currency, item) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart');
    usercartmap_v2 = prefs.getString("usercartmap_v2");

    if (usercartmap_v2 == null) {
      usercartmap_v2 = {};
      print('made an empty map');
    } else {
      usercartmap_v2 = json.decode(usercartmap_v2);
      print('found the map');
      print(json.encode(usercartmap_v2));
    }

    if (usercartmap_v2.containsKey(shop_name)) {
      if (usercartmap_v2[shop_name]['products'].containsKey(itemid)) {
        usercartmap_v2[shop_name]['products'][itemid]['count'] = int.parse(
                usercartmap_v2[shop_name]['products'][itemid]['count']
                    .toString()) +
            1;
        usercartmap_v2[shop_name]['products'][itemid]['rate'] = rate;
        usercartmap_v2[shop_name]['products'][itemid]['data'] = item;
        usercartmap_v2[shop_name]['products'][itemid]['date'] = item['date'];
      } else {
        usercartmap_v2[shop_name]['products'][itemid] = {};
        usercartmap_v2[shop_name]['products'][itemid]['rate'] = rate;
        usercartmap_v2[shop_name]['products'][itemid]['count'] = 1;
        usercartmap_v2[shop_name]['products'][itemid]['data'] = item;
        usercartmap_v2[shop_name]['products'][itemid]['date'] = item['date'];
      }
    } else {
      usercartmap_v2[shop_name] = {};
      usercartmap_v2[shop_name]['products'] = {};
      usercartmap_v2[shop_name]['products'][itemid] = {};
      usercartmap_v2[shop_name]['products'][itemid]['rate'] = rate;
      usercartmap_v2[shop_name]['products'][itemid]['count'] = 1;
      usercartmap_v2[shop_name]['products'][itemid]['data'] = item;
      usercartmap_v2[shop_name]['products'][itemid]['date'] = item['date'];
    }
    prefs.setString('usercartmap_v2', json.encode(usercartmap_v2));

    prefs.setString('type', type);
    if (prefs.getDouble('total') == null) {
      prefs.setDouble('total', 0);
    }

    if (currency == 'dollar') {
      rate = 1;
    }
    double total = prefs.getDouble('total') == null
        ? 0
        : prefs.getDouble('total') + shop_price;
    prefs.setDouble('total', total);
    add();
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

    if (!shops.contains(shop_name)) {
      shops.add(shop_name);
      prefs.setStringList("shops", shops);
    }
  }

  _remove(itemid, rate, shop_name, type, shop_price, currency, item) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart');
    usercartmap_v2 = prefs.getString("usercartmap_v2");

    if (usercartmap_v2 == null) {
      usercartmap_v2 = {};
      print('made an empty map');
    } else {
      usercartmap_v2 = json.decode(usercartmap_v2);
      print('found the map');
      print(json.encode(usercartmap_v2));
    }

    if (usercartmap_v2.containsKey(shop_name)) {
      if (usercartmap_v2[shop_name]['products'].containsKey(itemid)) {
        usercartmap_v2[shop_name]['products'][itemid]['count'] = int.parse(
                usercartmap_v2[shop_name]['products'][itemid]['count']
                    .toString()) -
            1;
        if (usercartmap_v2[shop_name]['products'][itemid]['count'] == 0) {
          usercartmap_v2[shop_name]['products'].remove(itemid);
        }
        if (usercartmap_v2[shop_name]['products'].length == 0) {
          usercartmap_v2.remove(shop_name);
        }
      }
    }

    prefs.setString('usercartmap_v2', json.encode(usercartmap_v2));

    prefs.setString('type', type);
    if (prefs.getDouble('total') == null) {
      prefs.setDouble('total', 0);
    }

    if (currency == 'dollar') {
      rate = 1;
    }
    double total = prefs.getDouble('total') == null
        ? 0
        : prefs.getDouble('total') - shop_price;
    minus();
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

    if (!shops.contains(shop_name)) {
      shops.remove(shop_name);
      prefs.setStringList("shops", shops);
    }

    if (cart.length == 0) {
      reset();

      return print('XXXXXXXXXXXXX');
    }
  }

  Map cartshopsproductsmap = {};
  Map cartshopsmap = {};
  dynamic usercartmap_v2 = {};
  getcartmap() async {
    for (var cartshop in shops) {
      for (var cartitem in finalcart) {
        Firestore.instance
            .collection("products")
            .document(cartitem)
            .get()
            .then((value) {
          if (value.data['shop'] == cartshop.toString()) {
            if (!cartshopsproductsmap.containsKey(cartitem)) {
              cartshopsproductsmap[cartitem] = 1;

              cartshopsproductsmap[cartitem].toInt();
            } else {
              cartshopsproductsmap[cartitem] =
                  cartshopsproductsmap[cartitem].toInt() + 1;
            }

            cartshopsmap[cartshop.toString()] = cartshopsproductsmap;
          }
        });
      }
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
          Map cartshopsproductsmap = {};
          for (var cartitem in cart) {
            Firestore.instance
                .collection("products")
                .document(cartitem)
                .get()
                .then((value) {
              if (value.data['shop'] == cartshop.toString()) {
                if (!cartshopsproductsmap.containsKey(cartitem)) {
                  cartshopsproductsmap[cartitem] = 1;

                  finalcart.add(cartshopsproductsmap[cartitem].toString());
                } else {
                  cartshopsproductsmap[cartitem] =
                      cartshopsproductsmap[cartitem].toInt() + 1;
                }

                cartshopsmap[cartshop.toString()] = cartshopsproductsmap;
              }
            });
          }
        }
        torestart = false;

        return shops;
      });
  }

  var addresses;
  String chosen_address;

  Future<bool> loadcart() async {
    final prefs = await SharedPreferences.getInstance();
    usercartmap = prefs.getString("usercartmap");
    if (!alreadyChosenAddress) {
      chosen_address = prefs.getString('address');
      print('JUST ADDED  AN ADDRESS');
    }
    if (usercartmap == null) {
      usercartmap = json.decode("{}");
    } else {
      usercartmap = json.decode(usercartmap);
    }

    usercartmap_v2 = prefs.getString("usercartmap_v2");
    if (usercartmap_v2 == null) {
      usercartmap_v2 = json.decode("{}");
    } else {
      usercartmap_v2 = json.decode(usercartmap_v2);
    }

    print('the chose isa s address is $chosen_address');

    print(usercartmap_v2);
    print('this is the cart ');
    if (prefs.getString('addresses') != null) {
      addresses = json.decode(prefs.getString('addresses'));
    }

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

        return true;
      });
  }

  @override
  void initState() {
    setupVerification();

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
          if (!notsetup) {
            Navigator.pop(context);
          }
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
            height: 800,
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
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileScreen()))
                                      .then((_) {
                                    setState(() {});
                                  });
                                },
                                color: Colors.redAccent[700],
                                textColor: Colors.white,
                                minWidth: 0,
                                height: 0,
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

  bool ordered = false;

  addAddressToCart(cartaddress) async {
    final prefs = await SharedPreferences.getInstance();
    var newcartaddress;

    prefs.setString('address', json.encode(cartaddress));
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
          onPressed: () {},
        ),
      );

      Navigator.of(context).pop();
      _welcomePopUp(context, user.displayName);

      final notsetup =
          await Firestore.instance.collection("users").document(user.uid).get();
      if (!notsetup.exists) {
        hasprofile = true;
      }

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

  refresh() {
    print('back to icart');
    loadcart();
    setupVerification();
    setState(() {
      var s = 's';
    });
  }

  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Delete all cart items?"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  textColor: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Confirm'),
                  onPressed: () {
                    reset();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  _confirmOrder() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Confirm your order?"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  textColor: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Confirm'),
                  onPressed: () {
                    setState(() {
                      ordered = true;
                    });
                    print('STSRTEDDDDDDD');
                    getCartAddress() async {
                      final prefs = await SharedPreferences.getInstance();

                      var all_addresses =
                          json.decode(prefs.getString('addresses'));
                      print(addresses);
                      print('THIS ARE THE ADDRESSES ');
                      var addresstouse = {};

                      for (var address = 0;
                          address < all_addresses.length;
                          address++) {
                        print(all_addresses[address]['id']);
                        print(chosen_address);
                        if (all_addresses[address]['id'] == chosen_address) {
                          addresstouse = all_addresses[address];
                          print('theyre the same');
                        }
                      }

                      List<String> fullorder = [];
                      List<String> fullorder_shops = [];
                      var completeproducts = {};
                      for (var cartshop in usercartmap_v2.keys) {
                        completeproducts[cartshop] = {};
                        var datashop = await Firestore.instance
                            .collection("shops")
                            .where('username', isEqualTo: cartshop)
                            .getDocuments();
                        var rate = datashop.documents[0].data['rate'];
                        print('the shop is $datashop');
                        if (rate == null) {
                          rate = 1;
                          print('changed rate to ZERO');
                        }
                        print(completeproducts);
                        print(completeproducts[cartshop]);
                        print('starting orderinggggggggggggggggggggggg');
                        var order_id = ">>" + UniqueKey().hashCode.toString();
                        Firestore.instance
                            .collection('shop_orders')
                            .document(order_id)
                            .setData({
                          "address": addresstouse,
                          "total": total.toInt(),
                          "count": usercartmap_v2[cartshop].length,
                          "payment": "cashondelivery",
                          "date": DateTime.now(),
                          "shop": cartshop,
                          "products": usercartmap_v2[cartshop],
                          "user": uid,
                        });
                        fullorder.add(order_id);
                        fullorder_shops.add(cartshop);
                      }

                      var fullorder_id = UniqueKey().hashCode.toString();
                      Firestore.instance
                          .collection('orders')
                          .document(fullorder_id)
                          .setData({
                        "address": addresstouse,
                        "total": total.toInt(),
                        "count": items,
                        "payment": "cashondelivery",
                        "date": DateTime.now(),
                        "products": usercartmap_v2,
                        "user": uid,
                        "shop_list": fullorder_shops,
                        "order_list": fullorder
                      }).then((doc) {
                        print(fullorder_id);
                        reset(false);
                        Navigator.pop(context);

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OrderPage(fullorder_id)));
                      }).catchError((error) {
                        print(error);
                      });
                    }

                    getCartAddress();

                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  _askToRemoveProduct(c1, c2, c3, c4, c5, c6, c7) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title:
                  new Text("Do you want to remove this item from your cart?"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  textColor: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).pop();
                    return 'false';
                  },
                ),
                FlatButton(
                  child: Text('Confirm'),
                  onPressed: () {
                    _remove(c1, c2, c3, c4, c5, c6, c7);

                    Navigator.of(context).pop();
                    return 'true';
                  },
                ),
              ],
            ));
  }

  bool alreadyChosenAddress = false;

  removeShopFromCart(shop) async {
    final prefs = await SharedPreferences.getInstance();
    usercartmap = prefs.getString("usercartmap");

    if (usercartmap == null) {
      usercartmap = {};
    } else {
      usercartmap = json.decode(usercartmap);
    }
    usercartmap.remove(shop);
    prefs.setString('usercartmap', json.encode(usercartmap));
  }

  bool loadedthepage = false;

  Future setupVerification() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final prefs = await SharedPreferences.getInstance();
    this_user =
        await Firestore.instance.collection("users").document(uid).get();

    if (user != null) {
      uid = user.uid;
      name = user.displayName;
      uemail = user.email;

      if (this_user.exists) {
        if (!prefs.containsKey('address')) {
          var counter = 0;
          for (var useraddress in this_user.data['address']) {
            if (useraddress['id'] == chosen_address) {
              prefs.setString(
                  'address', this_user.data['address'][counter].toString());
            }
            counter++;
          }
        }
        notsetup = false;
      }
    } else {
      usersignedin = false;
    }
    if (!loadedthepage) {
      setState(() {});
    }
    loadedthepage = true;
  }

  selectAddress(String chosenAddress, int addressIndex) {
    setState(() {
      chosen_address = chosenAddress;
      alreadyChosenAddress = true;
    });
  }

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool loadingorder = false;

  @override
  Widget build(BuildContext context) {
    num _defaultValue = 0;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    List<Widget> list = new List<Widget>();

    return new Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
          child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: Column(
            children: <Widget>[
              AppBar(
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
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
                      _showMaterialDialog();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Icon(Icons.delete),
                    ),
                  ),
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
              if (usercartmap_v2.keys.length > 0)
                Column(
                  children: [
                    for (var shop in usercartmap_v2.keys)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 22.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      usercartmap_v2[shop]['data']['name'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 23.0,
                                          fontFamily: 'Axiforma',
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    for (var product in usercartmap_v2[shop]
                                            ['products']
                                        .keys)
                                      buildCartItem_v2(
                                          usercartmap_v2[shop]['products']
                                              [product],
                                          usercartmap_v2[shop]['products']
                                              [product]['count'],
                                          product)
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, top: 20, bottom: 10),
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
                    padding:
                        const EdgeInsets.only(left: 30.0, top: 00, bottom: 10),
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
              ),
              if (addresses != null)
                Column(
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
                    for (var index = 0; index < addresses.length; index++)
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 30.0, bottom: 10, left: 30, top: 12),
                        child: GestureDetector(
                          onTap: () {
                            if (addresses.length > 1) {
                              selectAddress(addresses[index]["id"], index);
                              addAddressToCart(addresses[index]);
                            }
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                IconButton(
                                    icon: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Icon(
                                        Icons.place,
                                        color: chosen_address.toString() ==
                                                addresses[index]["id"]
                                            ? Colors.black
                                            : Colors.grey[400],
                                        size: 36,
                                      ),
                                    ),
                                    onPressed: () {}),
                                Container(
                                    margin: new EdgeInsets.only(
                                        left: 10.0, right: 0),
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
                                                    left: 0,
                                                    bottom: 5),
                                                child: Text(
                                                  addresses[index]["name"],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    fontFamily: 'Axiforma',
                                                    color: chosen_address ==
                                                            addresses[index]
                                                                ["id"]
                                                        ? Colors.black
                                                        : Colors.grey[500],
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0.0, bottom: 8),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            145,
                                                    child: Text(
                                                      addresses[index]
                                                          ["street_address"],
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
                            right: 30.0, bottom: 20, left: 30, top: 12),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Icon(Icons.payment,
                                      size: 30, color: Colors.black)),
                              Container(
                                  margin: new EdgeInsets.only(
                                      left: 10.0, right: 0, bottom: 0),
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
                                                'Cash On Delivery',
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
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, bottom: 8),
                                              child: Text(
                                                'Pay when the delivery arrives',
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
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              FutureBuilder(
                  future: setupVerification(),
                  builder: (context, snapshot) {
                    print(notsetup);
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Center(
                            child: Image.asset("assets/images/loading.gif",
                                width: 30),
                          ),
                        );
                      default:
                        if ((snapshot.hasError)) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(25, 10, 25, 12),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 0,
                              onPressed: null,
                              color: Colors.redAccent[700],
                              disabledColor: Colors.grey[200],
                              textColor: Colors.white,
                              minWidth: MediaQuery.of(context).size.width,
                              height: 0,
                              padding: EdgeInsets.only(
                                  left: 23, top: 12, right: 23, bottom: 10),
                              child: Text(
                                "No internet connection",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  fontFamily: 'Axiforma',
                                ),
                              ),
                            ),
                          );
                        } else {
                          if (!notsetup) {
                            return Column(
                              children: [
                                if (usersignedin & ordered == false)
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
                                              _confirmOrder();
                                            },
                                      color: Colors.redAccent[700],
                                      disabledColor: Colors.grey[200],
                                      textColor: Colors.white,
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      height: 0,
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
                                        ),
                                      ),
                                    ),
                                  ),
                                if (usersignedin & ordered)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 18.0),
                                    child: Center(
                                      child: Image.asset(
                                          "assets/images/loading.gif",
                                          width: 30),
                                    ),
                                  ),
                              ],
                            );
                          } else if (notsetup && usersignedin) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 0,
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileScreen()))
                                      .then((_) {
                                    setupVerification();
                                    setState(() {});
                                  });
                                },
                                color: Colors.redAccent[700],
                                disabledColor: Colors.grey[200],
                                textColor: Colors.white,
                                minWidth: MediaQuery.of(context).size.width,
                                height: 0,
                                padding: EdgeInsets.only(
                                    left: 23, top: 10, right: 23, bottom: 10),
                                child: Text(
                                  "Setup your profile to continue",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                    fontFamily: 'Axiforma',
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Padding(
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
                                padding: EdgeInsets.only(
                                    left: 23, top: 10, right: 23, bottom: 10),
                                child: Text(
                                  "Sign in to continue",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                    fontFamily: 'Axiforma',
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                    }
                  }),
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
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
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

  getShop(shop) async {
    var document = await Firestore.instance
        .collection('shops')
        .where("username", isEqualTo: shop)
        .getDocuments();
    return document.documents[0];
  }

  var rateArray = [];

  Padding buildCartItem_v2(dynamic cartitem, int count, String cartitemID) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var shopPrice = cartitem['data']['shop_price'] != null
        ? cartitem['data']['shop_price']
        : 1;

    rate = cartitem['rate'];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
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
                      offset: Offset(0, 8),
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
                  child: CachedNetworkImage(
                    height: 60,
                    width: 60,
                    placeholder: (context, url) =>
                        Image.asset("assets/images/loading.gif", height: 20),
                    imageUrl: cartitem['data']['image'] == null
                        ? "s"
                        : cartitem['data']['image'],
                    errorWidget: (context, url, error) =>
                        Center(child: new Icon(Icons.error)),
                  ),
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
                        cartitem['data']['name'],
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
                  visible: cartitem['data']['type'] == 'salle' &&
                      cartitem['data']['arabic_name'] != null,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: SizedBox(
                      width: width - 150,
                      child: Text(
                        cartitem['date-words'] != null
                            ? cartitem['date-words']
                            : '',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Row(
                          children: [
                            Visibility(
                              visible: cartitem['data']['type'] == 'salle'
                                  ? false
                                  : true,
                              child: Text(
                                (int.parse(shopPrice.toString()) *
                                            (cartitem['rate']))
                                        .toString() +
                                    "L.L.",
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
                              visible: cartitem['data']['type'] == 'salle'
                                  ? true
                                  : false,
                              child: Text(
                                cartitem['data']['serving_prices'] != null
                                    ? cartitem['data']['serving_prices'][count]
                                            .toString() +
                                        "L.L."
                                    : "",
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
                        visible:
                            cartitem['data']['type'] == 'salle' ? false : true,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            cartitem['data']['unit'] != null
                                ? cartitem['data']['unit'].toString()
                                : '',
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
                  visible: cartitem['data']['type'] == 'salle' ? true : false,
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
                                    cartitem['data'],
                                    cartitem['data']['day'],
                                    cartitem['data']['serving_prices'],
                                    cartitem['data']['descriptions'],
                                    cartitem['data']['description'],
                                    cartitem['date-words'],
                                    cartitem['date'],
                                    cartitemID)))
                            .then((_) {
                          refresh();
                        });
                      },
                      color: Colors.redAccent[700],
                      textColor: Colors.white,
                      minWidth: 0,
                      height: 0,
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
                Visibility(
                  visible: cartitem['data']['type'] == 'salle' ? false : true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 25,
                        child: RawMaterialButton(
                          onPressed: () {
                            if (count == 1) {
                              _askToRemoveProduct(
                                  cartitemID,
                                  cartitem['rate'],
                                  cartitem['data']['shop'],
                                  cartitem['data']['type'],
                                  (int.parse(cartitem['data']['shop_price']
                                          .toString()) *
                                      cartitem['rate']),
                                  cartitem['data']['currency'],
                                  cartitem['data']);
                            } else {
                              _remove(
                                  cartitemID,
                                  cartitem['rate'],
                                  cartitem['data']['shop'],
                                  cartitem['data']['type'],
                                  (int.parse(cartitem['data']['shop_price']
                                          .toString()) *
                                      cartitem['rate']),
                                  cartitem['data']['currency'],
                                  cartitem['data']);
                            }
                          },
                          elevation: 2,
                          fillColor: Colors.redAccent[700],
                          child: Icon(
                            Icons.remove,
                            size: 13,
                            color: Colors.white,
                          ),
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
                            _save(
                              cartitemID,
                              cartitem['rate'],
                              cartitem['data']['shop'],
                              cartitem['data']['type'],
                              (int.parse(cartitem['data']['shop_price']
                                      .toString()) *
                                  cartitem['rate']),
                              cartitem['data']['currency'],
                              cartitem['data'],
                            );
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

  Padding buildCartItem(DocumentSnapshot cartitem, int count, int rate) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var shopPrice = cartitem['shop_price'] != null ? cartitem['shop_price'] : 1;

    if (cartitem['currency'] != "dollar") {
      rate = 1;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
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
                      offset: Offset(0, 8),
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
                                (int.parse(shopPrice.toString()) *
                                            cartitem['rate'])
                                        .toString() +
                                    "L.L.",
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
                            cartitem['unit'] != null
                                ? cartitem['unit'].toString()
                                : '',
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
                      onPressed: () {},
                      color: Colors.redAccent[700],
                      textColor: Colors.white,
                      minWidth: 0,
                      height: 0,
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
                Visibility(
                  visible: cartitem['type'] == 'salle' ? false : true,
                  child: Row(
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
                                    cartitem['rate']),
                                cartitem['currency'],
                                cartitem['data']);
                          },
                          elevation: 2,
                          fillColor: Colors.redAccent[700],
                          child: Icon(
                            Icons.remove,
                            size: 13,
                            color: Colors.white,
                          ),
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
                            _save(
                                cartitem.documentID,
                                rate,
                                cartitem['shop'],
                                cartitem['type'],
                                (int.parse(cartitem['shop_price'].toString()) *
                                    cartitem['rate']),
                                cartitem['currency'],
                                cartitem['data']);
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
