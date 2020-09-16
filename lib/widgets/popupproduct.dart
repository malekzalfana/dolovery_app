import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
// import 'package:country_code_picker/country_code_picker.dart';

class ProductPopUp extends StatefulWidget {
  // final Widget child;

  // final String popup_Name;

  // final String popup_Price;

  // final String popup_Image;

  // final String popup_Details;
  // final dynamic product;
  ProductPopUp(data, {Key key, this.notifyParent}) : super(key: key);
  final Function() notifyParent;

  @override
  _ProductPopUpState createState() => _ProductPopUpState();
}

class _ProductPopUpState extends State<ProductPopUp> {
  // String popup_Image;
  // String popup_Name;
  // String popup_Price;
  // final dynamic product;

  _ProductPopUpState();

  // _ProductPopUpState(this.popup_Image);
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      builder: (BuildContext context, myscrollController) {
        return DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.2,
          maxChildSize: 1.0,
          builder: (BuildContext context, myscrollController) {
            return Container(
              color: Colors.tealAccent[200],
              child: ListView.builder(
                controller: myscrollController,
                itemCount: 25,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      title: Text(
                    'Dish $index',
                    style: TextStyle(color: Colors.black54),
                  ));
                },
              ),
            );
          },
        );
      },
    );
  }
}

void sendrefreshtohome() {
  print('zooooooooom');
}

dynamic shopinfo;
bool started = false;
dynamic cachedshops;
int rate = 1;
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
    print("xxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    rate = json.decode(prefs.getString("cached_shops"))[shopName];
    print(prefs.getString("cached_shops"));
    started = true;
    // print("just got: " + rate.toString());
  }
  debugPrint("rate is:::::" + rate.toString());
  started = true;
  // return rate = 1;
}

void openProductPopUp(context, data, index, [sendrefreshtohome]) {
  started = false;
  print("opened product fireddddddddddd");
  int _n = 0;
  bool minimum = true;
  bool maximum = false;

  var productCurrency = data.documents[index]['currency'];
  var productPrice = data.documents[index]['shop_price'];
  var shopName = data.documents[index]['shop'];
  // var rate = 6000;

  // int rate;

  // Map newCachedShops;
  removeRate() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("cached_shops");
  }

  Padding buildProductPrice() {
    if (productCurrency == "dollar") {
      return Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: EnhancedFutureBuilder(
            future: getRate(shopName),
            // this is where the magic happens
            rememberFutureResult: true,
            whenDone: (dynamic data) => Text(
                (int.parse(productPrice.toString()) *
                            int.parse(rate.toString()))
                        .toString() +
                    "L.L.",
                // rate.toString(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 11.7,
                  fontFamily: 'Axiforma',
                  color: Colors.black54,
                )),
            whenNotDone: Center(child: Text('Loading...')),
          ));
    } else {
      // print('product is not dollar');
      rate = 1;
      started = true;
      return Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            productPrice + "L.L.",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14.7,
              fontFamily: 'Axiforma',
              color: Colors.black54,
            ),
          ));
    }
  }

  // int serving = 0;

  Future<void> future = showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      // isDismissible: false,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // mpesachecked =false;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
          add() {
            // print ( _n );

            mystate(() {
              if (_n < 10) _n++;
              if (_n == 10) {
                // maximum = true;
              } else {
                minimum = false;
                maximum = false;
              }
              print(_n);
            });
          }

          dynamic usercartmap;

          _save(itemid, rate) async {
            // {
            //   "shop1": {
            //     "12123":1123,
            //     "aasas":2133221
            //   }
            // }
            add();
            final prefs = await SharedPreferences.getInstance();
            List<String> cart = prefs.getStringList('cart');
            String shop_name = data.documents[index]['shop'];
            // START
            usercartmap = prefs.getString("usercartmap");
            // prefs.remove('usercartmap');
            if (usercartmap == null) {
              usercartmap = {};
              print('made an empty map');
            } else {
              usercartmap = json.decode(usercartmap);
              print('found the map');
              print(json.encode(usercartmap));
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
            String type = data.documents[index][
                'type']; //prefs.getString('type') == null? 'nothing': prefs.getString('type');
            prefs.setString('type', type);
            if (prefs.getDouble('total') == null) {
              prefs.setDouble('total', 0);
            }
            var shop_price =
                int.parse(data.documents[index]['shop_price'].toString())
                    .toDouble();
            double total = prefs.getDouble('total') == null
                ? 0
                : prefs.getDouble('total') +
                    (double.parse(shop_price.toString()) *
                        double.parse(rate.toString()));
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

            print(shop_name);
            print('shopaboive______________');
            if (!shops.contains(shop_name)) {
              shops.add(shop_name);
              prefs.setStringList("shops", shops);
            }

            // print('saved $value');
            // print('saved $total');
            // print('saved $type');
            // print('saved $items');
          }

          void minus() {
            print(_n);
            mystate(() {
              if (_n != 0) _n--;
              if (_n == 0)
                minimum = true;
              else {
                minimum = false;
                maximum = false;
              }
            });
          }

          _remove(itemid, rate) async {
            minus();
            final prefs = await SharedPreferences.getInstance();
            List<String> cart = prefs.getStringList('cart');
            String shop_name = data.documents[index]['shop'];
            // START
            usercartmap = prefs.getString("usercartmap");
            // prefs.remove('usercartmap');
            if (usercartmap == null) {
              usercartmap = {};
              print('made an empty map');
            } else {
              usercartmap = json.decode(usercartmap);
              print('found the map');
              print(json.encode(usercartmap));
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
            String type = data.documents[index][
                'type']; //prefs.getString('type') == null? 'nothing': prefs.getString('type');
            prefs.setString('type', type);
            if (prefs.getDouble('total') == null) {
              prefs.setDouble('total', 0);
            }
            var shop_price =
                int.parse(data.documents[index]['shop_price'].toString())
                    .toDouble();
            double total = prefs.getDouble('total') == null
                ? 0
                : prefs.getDouble('total') -
                    (double.parse(shop_price.toString()) *
                        double.parse(rate.toString()));
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

            print(shop_name);
            print('shopaboive______________');
            if (!shops.contains(shop_name)) {
              shops.remove(shop_name);
              prefs.setStringList("shops", shops);
            }
            print('saved $value');
            print('saved $total');
            print('saved $type');
            print('saved $items');
          }

          int countOccurrencesUsingLoop(List<String> list, String element) {
            if (list == null || list.isEmpty) {
              return 0;
            }

            int count = 0;
            for (int i = 0; i < list.length; i++) {
              if (list[i] == element) {
                count++;
              }
            }

            return count;
          }

          _setnumber() async {
            final prefs = await SharedPreferences.getInstance();
            List<String> cart = prefs.getStringList('cart');
            mystate(() {
              _n = countOccurrencesUsingLoop(
                  cart, data.documents[index].documentID);
              if (_n > 0) {
                minimum = false;
              }
            });
            // print (count)
          }

          _setnumber();
          // print(_n);

          double width = MediaQuery.of(context).size.width;

          // print(_setnumber());

          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {}),
                      ),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            data.documents[index]['category'].toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0,
                                letterSpacing: 1.1,
                                fontFamily: 'Axiforma',
                                color: Colors.grey[400]),
                          )),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey,
                              size: 30,
                            ),
                            onPressed: () {
                              // sendrefreshtohome();
                              Navigator.of(context).pop();
                              // setState(() {
                              //   showerrortextbool = false;
                              // });
                            }),
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, top: 20),
                      child: Center(
                          child: CachedNetworkImage(
                        width: 170,
                        placeholder: (context, url) => Image.asset(
                            "assets/images/loading.png",
                            height: 30),
                        imageUrl: data.documents[index]['image'],
                      ))),
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 00),
                    child: SizedBox(
                      width: width - 50,
                      child: Text(
                        data.documents[index]['name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontFamily: 'Axiforma',
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Text((int.parse(productPrice.toString()) *
                      //             int.parse(rate.toString()))
                      //         .toString() +
                      //     "L.L."),
                      buildProductPrice(),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          data.documents[index]['unit'],
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                              fontFamily: 'Axiforma',
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: true,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0, top: 20.0),
                      child: Container(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RawMaterialButton(
                              onPressed: () {
                                _remove(data.documents[index].documentID, rate);
                              },
                              elevation: !minimum ? 2 : 0,
                              fillColor: !minimum
                                  ? Colors.redAccent[700]
                                  : Colors.grey[200],
                              child: Icon(
                                Icons.remove,
                                size: 18,
                                color:
                                    !minimum ? Colors.white : Colors.grey[800],
                              ),
                              padding: EdgeInsets.all(0.0),
                              shape: CircleBorder(),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: new Text('$_n',
                                  style: new TextStyle(fontSize: 20.0)),
                            ),
                            RawMaterialButton(
                              onPressed: () {
                                // add;
                                _save(data.documents[index].documentID, rate);
                              },
                              elevation: !maximum ? 2 : 0,
                              fillColor: !maximum
                                  ? Colors.redAccent[700]
                                  : Colors.grey[200],
                              child: Icon(
                                Icons.add,
                                size: 18,
                                color:
                                    !maximum ? Colors.white : Colors.grey[800],
                              ),
                              padding: EdgeInsets.all(0.0),
                              shape: CircleBorder(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: data.documents[index]['description'] != null
                        ? true
                        : false,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30.0, top: 30, bottom: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Description",
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
                              left: 30.0, right: 30.0, top: 0, bottom: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              data.documents[index]['description'] != null
                                  ? data.documents[index]['description']
                                  : "",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 13.0,
                                fontFamily: 'Axiforma',
                                color: Colors.black,
                              ),
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
        });
      });
  future.then((void value) => sendrefreshtohome());
}
