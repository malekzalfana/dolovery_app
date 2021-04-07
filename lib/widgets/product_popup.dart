import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPopUp extends StatefulWidget {
  ProductPopUp(data, {Key key, this.notifyParent}) : super(key: key);
  final Function() notifyParent;

  @override
  _ProductPopUpState createState() => _ProductPopUpState();
}

class _ProductPopUpState extends State<ProductPopUp> {
  _ProductPopUpState();

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

dynamic shopinfo;
bool started = false;
dynamic cachedshops;
int rate = 1;
getRate(shopName) async {
  if (started == true) {
    return rate;
  }
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

          started = true;
          return rate = value.documents[0].data['rate'];
        } else {
          return null;
        }
      },
    );
  } else {
    rate = json.decode(prefs.getString("cached_shops"))[shopName];
    print(prefs.getString("cached_shops"));
    started = true;
  }
  debugPrint("rate is:" + rate.toString());
  started = true;
}

void openProductPopUp(context, productData, index, [sendrefreshtohome]) {
  started = false;
  int _n = 0;
  bool minimum = true;
  bool maximum = false;
  print(productData);
  var productCurrency = productData['currency'];
  var productPrice = productData['shop_price'];
  var shopName = productData['shop'];
  var oldPrice = productData['old_price'];
  if (oldPrice == null) {
    oldPrice = 0;
  }

  Widget buildProductPrice() {
    if (productCurrency == "dollar") {
      return Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: EnhancedFutureBuilder(
            future: getRate(shopName),
            rememberFutureResult: true,
            whenDone: (dynamic data) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (oldPrice != null)
                  Visibility(
                    visible: oldPrice.toString().length > 0,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                          (int.parse(oldPrice.toString()) *
                                      int.parse(rate.toString()))
                                  .toString() +
                              "L.L.",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            decorationThickness: 2,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontFamily: 'Axiforma',
                            color: Colors.black54,
                          )),
                    ),
                  ),
                if (productPrice != null)
                  Text(
                      (int.parse(productPrice.toString()) *
                                  int.parse(rate.toString()))
                              .toString() +
                          "L.L.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        fontFamily: 'Axiforma',
                        color: Colors.black54,
                      )),
              ],
            ),
            whenNotDone: Center(child: Text('Loading...')),
          ));
    } else {
      rate = 1;
      started = true;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (oldPrice != null)
            Visibility(
              visible: oldPrice.toString().length > 0,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(oldPrice.toString() + "L.L.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      decorationThickness: 2,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: 'Axiforma',
                      color: Colors.black54,
                    )),
              ),
            ),
          if (productPrice != null)
            Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text(
                  productPrice.toString() + "L.L.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14.7,
                    fontFamily: 'Axiforma',
                    color: Colors.black54,
                  ),
                )),
        ],
      );
    }
  }

  bool showmessage = false;

  Future<void> future = showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
          add() {
            mystate(() {
              if (_n < 10) _n++;
              if (_n == 10) {
              } else {
                minimum = false;
                maximum = false;
              }
              print(_n);
            });
          }

          dynamic usercartmap_v2;

          _save(item, itemid, rate) async {
            final prefs = await SharedPreferences.getInstance();
            List<String> cart = prefs.getStringList('cart');
            String shop_name = productData['shop'];
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
                usercartmap_v2[shop_name]['products'][itemid]['count'] =
                    int.parse(usercartmap_v2[shop_name]['products'][itemid]
                                ['count']
                            .toString()) +
                        1;
                usercartmap_v2[shop_name]['products'][itemid]['rate'] = rate;
                usercartmap_v2[shop_name]['products'][itemid]['data'] =
                    item.data;
                usercartmap_v2[shop_name]['products'][itemid]['date'] =
                    item.data['date'];
              } else {
                usercartmap_v2[shop_name]['products'][itemid] = {};
                usercartmap_v2[shop_name]['products'][itemid]['rate'] = rate;
                usercartmap_v2[shop_name]['products'][itemid]['count'] = 1;
                usercartmap_v2[shop_name]['products'][itemid]['data'] =
                    item.data;
                usercartmap_v2[shop_name]['products'][itemid]['date'] =
                    item.data['date'];
              }
            } else {
              var shopname;
              var shopinfo2 = await Firestore.instance
                  .collection('shops')
                  .where('username', isEqualTo: shopName)
                  .getDocuments()
                  .then(
                (value) {
                  print('thid id the value');
                  print(value);
                  if (value.documents.length > 0) {
                    shopname = value.documents[0].data['name'];
                    usercartmap_v2[shop_name] = {
                      'products': {},
                      'data': {'name': shopname}
                    };
                  } else {
                    print('returbned none');
                  }
                },
              );

              usercartmap_v2[shop_name]['products'] = {};
              usercartmap_v2[shop_name]['products'][itemid] = {};
              usercartmap_v2[shop_name]['products'][itemid]['rate'] = rate;
              usercartmap_v2[shop_name]['products'][itemid]['count'] = 1;
              usercartmap_v2[shop_name]['products'][itemid]['data'] = item.data;
              usercartmap_v2[shop_name]['products'][itemid]['date'] =
                  item.data['date'];
            }
            add();
            prefs.setString('usercartmap_v2', json.encode(usercartmap_v2));
            String type = productData['type'];
            prefs.setString('type', type);
            if (prefs.getDouble('total') == null) {
              prefs.setDouble('total', 0);
            }
            var shop_price =
                int.parse(productData['shop_price'].toString()).toDouble();
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

            print(rate);
            print('################');
            showmessage = true;
            Timer(Duration(seconds: 3), () {
              showmessage = false;
            });
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

          _remove(item, itemid, rate) async {
            minus();
            final prefs = await SharedPreferences.getInstance();
            List<String> cart = prefs.getStringList('cart');
            String shop_name = productData['shop'];
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
                usercartmap_v2[shop_name]['products'][itemid]['count'] =
                    int.parse(usercartmap_v2[shop_name]['products'][itemid]
                                ['count']
                            .toString()) -
                        1;
                if (usercartmap_v2[shop_name]['products'][itemid]['count'] ==
                    0) {
                  usercartmap_v2[shop_name]['products'].remove(itemid);
                }
              }
            }

            prefs.setString('usercartmap_v2', json.encode(usercartmap_v2));

            String type = productData['type'];
            prefs.setString('type', type);
            if (prefs.getDouble('total') == null) {
              prefs.setDouble('total', 0);
            }
            var shop_price =
                int.parse(productData['shop_price'].toString()).toDouble();
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
            if (usercartmap_v2[shop_name]['products'].keys.length == 0) {
              usercartmap_v2.remove(shop_name);
            }
            print('saved $value');
            print('saved $total');
            print('saved $type');
            print('saved $items');
            showmessage = true;
            Timer(Duration(seconds: 3), () {
              showmessage = false;
            });
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
              _n = countOccurrencesUsingLoop(cart, productData.documentID);
              if (_n > 0) {
                minimum = false;
              }
            });
          }

          _setnumber();

          double width = MediaQuery.of(context).size.width;

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
                      if (productData['category'] != null)
                        Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              productData['category'].toUpperCase(),
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
                              Navigator.of(context).pop();
                            }),
                      ),
                    ],
                  ),
                  if (productData['image'] != null)
                    Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, top: 20),
                        child: Center(
                            child: CachedNetworkImage(
                          width: 170,
                          placeholder: (context, url) => Image.asset(
                              "assets/images/loading.gif",
                              height: 30),
                          imageUrl: productData['image'],
                          errorWidget: (context, url, error) => Center(
                              child: Expanded(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                  width: 400,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[100]),
                                  child: new Icon(Icons.error)),
                            ),
                          )),
                        ))),
                  if (productData['name'] != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 00),
                      child: SizedBox(
                        width: width - 50,
                        child: Text(
                          productData['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              fontFamily: 'Axiforma',
                              color: Colors.black),
                        ),
                      ),
                    ),
                  if (productData['unit'] != null)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (productData['unit'] != "")
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              productData['unit'],
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.0,
                                  fontFamily: 'Axiforma',
                                  color: Colors.black38),
                            ),
                          ),
                        buildProductPrice(),
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
                                _remove(
                                    productData, productData.documentID, rate);
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
                                _save(
                                    productData, productData.documentID, rate);
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
                    visible: showmessage,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: DelayedDisplay(
                          delay: Duration(milliseconds: 200),
                          fadingDuration: const Duration(milliseconds: 300),
                          slidingBeginOffset: const Offset(0.0, 0.15),
                          child: Text(
                            _n > 0
                                ? 'You have ${_n} items in your cart!'
                                : 'Item removed from your cart!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              fontFamily: 'Axiforma',
                              color: Colors.black54,
                            ),
                          )),
                    ),
                  ),
                  Visibility(
                    visible: productData['description'] != null ? true : false,
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
                        if (productData['description'] != null)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30.0, right: 30.0, top: 0, bottom: 30),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                productData['description'] != null
                                    ? productData['description']
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
