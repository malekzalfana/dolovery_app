import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dolovery_app/widgets/product.dart';
import 'package:intl/intl.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalleItem extends StatefulWidget {
  final dynamic data;
  final String day;
  final List descriptions;
  final String description;
  final List prices;
  final String datenumbers;
  final String datewords;
  final String id;
  SalleItem(this.data, this.day, this.prices, this.descriptions,
      this.description, this.datewords, this.datenumbers, this.id,
      {Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SalleItemState();
}

class _SalleItemState extends State<SalleItem> {
  dynamic usercartmap;
  bool alreadyadded = false;
  int inmycart = 0;
  int _n = 0;
  bool minimum = true;
  bool maximum = false;

  void add() {
    setState(() {
      if (_n < 9) _n++;
      if (_n == 9) {
        maximum = true;
      } else {
        minimum = false;
        maximum = false;
      }
      print(_n);
      if (_n != inmycart) {
        showChangeButton = true;
      } else {
        showChangeButton = false;
      }
    });
  }

  bool loaded = false;
  dynamic usercartmap_v2;
  getSalleStatus() async {
    print('RAN THE FUTURE');
    Map newusercartmap_v2;
    final prefs = await SharedPreferences.getInstance();
    var temp = prefs.getString('usercartmap_v2');
    if (temp == null) {
      temp = "";
      newusercartmap_v2 = {};
    } else {
      newusercartmap_v2 = json.decode(temp);
    }

    if (newusercartmap_v2 == null) {
      newusercartmap_v2 = {};
    }

    if (newusercartmap_v2.containsKey('dolovery')) {
      print('it has dolovery in  it');
      print(widget.id);
      print(newusercartmap_v2['dolovery']['products']);
      print(newusercartmap_v2['dolovery']['products'][widget.id].toString());
      if (newusercartmap_v2['dolovery']['products'].containsKey(widget.id)) {
        print('dolovery has documentid in it');

        if (loaded == false) {
          setState(() {
            alreadyadded = true;
            loaded = true;
            inmycart =
                newusercartmap_v2['dolovery']['products'][widget.id]['count'];
            print("$inmycart is in my cart");
          });
        }

        return true;
      }
    }
  }

  int oldsalletotal = 0;

  _save(itemid, int count, item) async {
    print(count.toString());
    print('this is the count');

    oldsalletotal = null;
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart');
    String shop_name = 'dolovery';
    usercartmap_v2 = prefs.getString("usercartmap_v2");

    if (usercartmap_v2 == null) {
      usercartmap_v2 = {};
    } else {
      usercartmap_v2 = json.decode(usercartmap_v2);
    }

    var new_itemid = itemid;
    print(new_itemid);
    if (usercartmap_v2.containsKey(shop_name)) {
      if (usercartmap_v2[shop_name]['products'].containsKey(new_itemid)) {
        usercartmap_v2[shop_name]['products'][new_itemid]['count'] = count;

        usercartmap_v2[shop_name]['products'][new_itemid]['data'] = item;
        usercartmap_v2[shop_name]['products'][new_itemid]['date'] =
            widget.datenumbers;
        usercartmap_v2[shop_name]['products'][new_itemid]['rate'] = 1;
        usercartmap_v2[shop_name]['products'][new_itemid]['date-words'] =
            widget.datewords;
      } else {
        usercartmap_v2[shop_name]['products'][new_itemid] = {};

        usercartmap_v2[shop_name]['products'][new_itemid]['count'] = count;
        usercartmap_v2[shop_name]['products'][new_itemid]['data'] = item;
        usercartmap_v2[shop_name]['products'][new_itemid]['rate'] = 1;
        usercartmap_v2[shop_name]['products'][new_itemid]['date'] =
            widget.datenumbers;
        usercartmap_v2[shop_name]['products'][new_itemid]['date-words'] =
            widget.datewords;
      }
    } else {
      usercartmap_v2[shop_name] = {
        'data': {'name': 'Dolovery'},
        'products': {}
      };

      usercartmap_v2[shop_name]['products'][new_itemid] = {};

      usercartmap_v2[shop_name]['products'][new_itemid]['count'] = count;
      usercartmap_v2[shop_name]['products'][new_itemid]['data'] = item;
      usercartmap_v2[shop_name]['products'][new_itemid]['rate'] = 1;
      usercartmap_v2[shop_name]['products'][new_itemid]['date'] =
          widget.datenumbers;
      usercartmap_v2[shop_name]['products'][new_itemid]['date-words'] =
          widget.datewords;
    }
    prefs.setString('usercartmap_v2', json.encode(usercartmap_v2));

    usercartmap = prefs.getString("usercartmap");

    print(usercartmap_v2);

    if (usercartmap == null) {
      usercartmap = {};
    } else {
      usercartmap = json.decode(usercartmap);
    }

    if (cart == null) {
      cart = [];
    }

    if (usercartmap.containsKey(shop_name)) {
      if (usercartmap[shop_name]['products'].containsKey(new_itemid)) {
        oldsalletotal = usercartmap[shop_name]['products'][new_itemid];
        usercartmap[shop_name]['products'][new_itemid] = _n;
      } else {
        usercartmap[shop_name]['products'][new_itemid] = 1 * count;
        cart.add(new_itemid);
      }
    } else {
      usercartmap[shop_name] = {};
      usercartmap[shop_name]['products'] = {};
      usercartmap[shop_name]['products'][new_itemid] = 1 * count;
      cart.add(new_itemid);
    }

    String type = widget.data['type'];
    prefs.setString('type', type);
    if (prefs.getDouble('total') == null) {
      prefs.setDouble('total', 0);
    }

    var oldprice;
    if (oldsalletotal == null) {
      oldprice = 0;
    } else {
      oldprice =
          double.parse(widget.data['serving_prices'][oldsalletotal].toString());
    }

    double total = prefs.getDouble('total') == null
        ? 0
        : prefs.getDouble('total') -
            oldprice +
            double.parse(widget.data['serving_prices'][count].toString());

    prefs.setDouble('total', total);
    prefs.setString('usercartmap', json.encode(usercartmap));
    prefs.setString('usercartmap_v2', json.encode(usercartmap_v2));
    if (cart == null) {
      cart = [];
    }

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

    setState(() {
      oldsalletotal = count;
      loaded = false;
      alreadyadded = true;
      showChangeButton = false;
    });
  }

  cancelCartItem(itemid) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart');
    String shop_name = widget.data['shop'];

    usercartmap = prefs.getString("usercartmap");
    print('user cartmap');
    print(usercartmap);

    usercartmap = json.decode(usercartmap);

    usercartmap_v2 = prefs.getString("usercartmap_v2");
    print('user cartmap');
    print(usercartmap_v2);

    var new_itemid = itemid;
    usercartmap_v2 = json.decode(usercartmap_v2);
    usercartmap_v2[shop_name]['products'].remove(new_itemid);

    if (cart == null) {
      cart = [];
    }

    String type = widget.data['type'];
    prefs.setString('type', type);
    if (prefs.getDouble('total') == null) {
      prefs.setDouble('total', 0);
    }
    print("the current salle total is: " + inmycart.toString());
    var oldprice;
    if (oldsalletotal == null) {
      oldprice = 0;
    } else {
      oldprice =
          double.parse(widget.data['serving_prices'][inmycart].toString());
    }

    print("THE old price is $oldprice");
    double total = prefs.getDouble('total') == null
        ? 0
        : prefs.getDouble('total') - double.parse(oldprice.toString());

    if (cart == null) {
      cart = [];
    }
    cart.remove(new_itemid);
    usercartmap[shop_name]['products'].remove(new_itemid);
    prefs.setDouble('total', total);
    prefs.setString('usercartmap', json.encode(usercartmap));
    prefs.setString('usercartmap_v2', json.encode(usercartmap_v2));
    final value = cart;
    final double items = cart.length.toDouble();
    prefs.setDouble('items', items);
    prefs.setStringList('cart', value);
    List<String> shops = prefs.getStringList('shops');
    if (shops == null) {
      shops = [];
    }
    print('testing');
    print(usercartmap_v2[shop_name]['products'].keys);
    if (usercartmap_v2[shop_name]['products'].length == 0) {
      print('its the only prodyuct left');
      usercartmap_v2[shop_name].remove(itemid);
    }

    alreadyadded = false;
    showChangeButton = false;
    setState(() {});
  }

  void minus() {
    if (_n == 0) return null;
    print(_n);
    setState(() {
      if (_n != 0) _n--;
      if (_n == 0)
        minimum = true;
      else {
        minimum = false;
        maximum = false;
      }
      if (_n != inmycart) {
        showChangeButton = true;
      } else {
        showChangeButton = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  bool showChangeButton = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (inmycart != _n && loaded) {
      showChangeButton = true;
    }

    num _defaultValue = 0;

    return new Scaffold(
      body: SingleChildScrollView(
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
              'Basket Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16.0,
                fontFamily: 'Axiforma',
                color: Colors.black,
              ),
            ),
          ),
          Text(
            widget.datewords,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 22.0,
                color: Colors.black),
          ),
          CachedNetworkImage(
            imageUrl: widget.data['image'] == null ? 's' : widget.data['image'],
            width: 330,
            placeholder: (context, url) =>
                Image.asset("assets/images/loading.gif", height: 30),
            errorWidget: (context, url, error) => Container(
                margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: Icon(Icons.error)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 30, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recipe",
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
            padding: const EdgeInsets.only(left: 30.0, top: 00, bottom: 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.data['name'],
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 25.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 00, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.data['arabic_name'],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black87),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 10, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Preparation Time",
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
                widget.data['time'].toString() + "mins",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 10, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Number of Items",
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
            padding: const EdgeInsets.only(left: 30.0, top: 00, bottom: 00),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.data['items'].toString() + " Items",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 20, bottom: 10),
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
                widget.description,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 13.0,
                  fontFamily: 'Axiforma',
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 30, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Number of servings",
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
            padding: const EdgeInsets.only(left: 0, top: 20.0),
            child: Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RawMaterialButton(
                    onPressed: minus,
                    elevation: !minimum ? 2 : 0,
                    fillColor:
                        !minimum ? Colors.redAccent[700] : Colors.grey[200],
                    child: Icon(
                      Icons.remove,
                      size: 18,
                      color: !minimum ? Colors.white : Colors.grey[800],
                    ),
                    padding: EdgeInsets.all(0.0),
                    shape: CircleBorder(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: new Text('${_n + 1}' + ' Servings',
                        style: new TextStyle(fontSize: 20.0)),
                  ),
                  RawMaterialButton(
                    onPressed: add,
                    elevation: !maximum ? 2 : 0,
                    fillColor:
                        !maximum ? Colors.redAccent[700] : Colors.grey[200],
                    child: Icon(
                      Icons.add,
                      size: 18,
                      color: !maximum ? Colors.white : Colors.grey[800],
                    ),
                    padding: EdgeInsets.all(0.0),
                    shape: CircleBorder(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 30, bottom: 10),
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
                widget.prices[_n].toString() + 'L.L.',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 25.0,
                    fontFamily: 'Axiforma',
                    color: Colors.redAccent[700]),
              ),
            ),
          ),
          FutureBuilder(
            future: getSalleStatus(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text('Loading....');
                default:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  else
                    return Visibility(
                      visible: alreadyadded,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.green[700],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              height: 45,
                              width: width - 44,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 15.0),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            '${inmycart + 1} Servings added to cart',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16.0,
                                              fontFamily: 'Axiforma',
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      cancelCartItem(widget.id);
                                      final snackBar = SnackBar(
                                          content: Text('Removed from cart!'),
                                          action: SnackBarAction(
                                            label: 'OK',
                                            onPressed: () {},
                                          ));
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: showChangeButton,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(22, 12, 22, 12),
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 0,
                                onPressed: () {
                                  _save(widget.id, _n, widget.data);
                                  setState(() {
                                    loaded = false;
                                    showChangeButton = false;
                                    alreadyadded = true;
                                  });
                                },
                                color: Colors.redAccent[700],
                                textColor: Colors.white,
                                minWidth: MediaQuery.of(context).size.width,
                                height: 0,
                                padding: EdgeInsets.only(
                                    left: 30, top: 10, right: 30, bottom: 10),
                                child: Text(
                                  "Change to ${_n + 1} Servings",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                    fontFamily: 'Axiforma',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
              }
            },
          ),
          Visibility(
            visible: !alreadyadded,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 0,
                onPressed: () {
                  print('the id is the :::::::::::${widget.id}');
                  _save(widget.id, _n, widget.data);

                  print(alreadyadded);
                },
                color: Colors.green,
                textColor: Colors.white,
                minWidth: MediaQuery.of(context).size.width,
                height: 0,
                padding:
                    EdgeInsets.only(left: 30, top: 10, right: 30, bottom: 10),
                child: Text(
                  "Add to Cart",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    fontFamily: 'Axiforma',
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22.0),
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
                    "All meal baskets come with detailed cooking instructions.",
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
          )
        ],
      )),
    );
  }
}
