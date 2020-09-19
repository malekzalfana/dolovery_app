import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dolovery_app/widgets/product.dart';
import 'package:intl/intl.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dolovery_app/widgets/counter.dart';

class SalleItem extends StatefulWidget {
  final dynamic data; //if you have multiple values add here
  final String day;
  final List descriptions;
  final List prices;
  SalleItem(this.data, this.day, this.prices, this.descriptions, {Key key})
      : super(key: key); //add also..example this.abc,this...

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
  // int serving = 0;

  void add() {
    // print ( _n );
    setState(() {
      if (_n < 10) _n++;
      if (_n == 10) {
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
  getSalleStatus() async {
    Map newusercartmap;
    final prefs = await SharedPreferences.getInstance();
    var temp = prefs.getString('usercartmap');
    if (temp == null) {
      temp = "";
      newusercartmap = {};
    } else {
      newusercartmap = json.decode(temp);
    }

    print('--------------------------');
    print(prefs.getString('usercartmap'));
    if (newusercartmap == null) {
      newusercartmap = {};
    }
    if (newusercartmap.containsKey('dolovery')) {
      print('it has dolovery in  it');
      print(widget.data.documentID);
      if (newusercartmap['dolovery'].containsKey(widget.data.documentID)) {
        print('dolovery has documentid in it');
        print(alreadyadded);
        if (loaded == false) {
          print("it has not loaded");
          setState(() {
            alreadyadded = true;
            loaded = true;
            inmycart = newusercartmap['dolovery'][widget.data.documentID];
            print("$inmycart is in my cart");

            print("there is one beforeeeeeeeeeee");
          });
        }

        return true;
      }
    }
  }

  int oldsalletotal = 0;
  _save(itemid, int count) async {
    oldsalletotal = 0;
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart');
    String shop_name = widget.data['shop'];
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

    if (cart == null) {
      cart = [];
    }

    if (usercartmap.containsKey(shop_name)) {
      if (usercartmap[shop_name].containsKey(itemid)) {
        oldsalletotal = usercartmap[shop_name][itemid];
        usercartmap[shop_name][itemid] = _n;
        // int.parse(usercartmap[shop_name][itemid].toString()) + (1 * count);
      } else {
        usercartmap[shop_name][itemid] = 1 * count;
        cart.add(itemid);
      }
    } else {
      usercartmap[shop_name] = {};
      usercartmap[shop_name][itemid] = 1 * count;
      cart.add(itemid);
    }

    // print(prefs.getString('usercartmap'));
    String type = widget.data[
        'type']; //prefs.getString('type') == null? 'nothing': prefs.getString('type');
    prefs.setString('type', type);
    if (prefs.getDouble('total') == null) {
      prefs.setDouble('total', 0);
    }
    print("the old salle total is: " + oldsalletotal.toString());
    var shop_price = int.parse(widget.data['shop_price'].toString()).toDouble();
    print(widget.data['serving_prices'][oldsalletotal]);
    print(widget.data['serving_prices'][count]);
    var oldprice =
        double.parse(widget.data['serving_prices'][oldsalletotal].toString());
    if (count == 0) {
      oldprice = 0;
    }
    double total = prefs.getDouble('total') == null
        ? 0
        : prefs.getDouble('total') -
            oldprice +
            double.parse(widget.data['serving_prices'][count].toString());
    print('above the erroes');
    print("the tortal is ${total.toString()}");
    prefs.setDouble('total', total);
    prefs.setString('usercartmap', json.encode(usercartmap));
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

    print(shop_name);
    print('shopaboive______________');
    if (!shops.contains(shop_name)) {
      shops.add(shop_name);
      prefs.setStringList("shops", shops);
    }
    alreadyadded = false;
    showChangeButton = false;

    // setState(() {});

    // print('saved $value');
    // print('saved $total');
    // print('saved $type');
    // print('saved $items');
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
    // getSalleStatus();
  }

  bool showChangeButton = false;

  @override
  Widget build(BuildContext context) {
    // final double itemHeight = (size.height) / 2;
    // final double itemWidth = size.width / 2;
    // new Date(widget.data['salle_date'].seconds * 1000 + widget.data['salle_date'].nanoseconds/1000000)
    // var date = DateTime.fromMicrosecondsSinceEpoch(
    // widget.data['salle_date']);
    double width = MediaQuery.of(context).size.width;

    var timestamp = (widget.data['salle_date'] as Timestamp).toDate();
    num _defaultValue = 0;
    String formatted_date = DateFormat.yMMMMd().format(timestamp);
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
            widget.day,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 32.0,
                color: Colors.black),
          ),
          Text(
            formatted_date,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
                fontFamily: 'Axiforma',
                color: Colors.black45),
          ),
          Container(
            child: Image.network(widget.data['image'], width: 330),
            // Hero(
            //   tag: 'salle' + widget.data.documentID,
            //   child:
            //       Image.network(widget.data['image'], width: 330),
            // ),
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
            padding: const EdgeInsets.only(left: 30.0, top: 00, bottom: 10),
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
                widget.data['salle_time'].toString() + "mins",
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
                widget.descriptions[_n == 0 ? 0 : _n - 1].toString(),
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
            padding: const EdgeInsets.only(left: 22, top: 20.0),
            child: Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                                  color: Colors.green[500],
                                  // border: Border.all(
                                  //   color: Colors.green[500],
                                  // ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              height: 45,
                              width: width - 44,
                              // color: Colors.red,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
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
                                  _save(widget.data.documentID, _n);
                                  setState(() {
                                    loaded = false;
                                    showChangeButton = false;
                                  });
                                },
                                color: Colors.redAccent[700],
                                // disabledColor: Colors.grey[200],
                                textColor: Colors.white,
                                minWidth: MediaQuery.of(context).size.width,
                                height: 0,
                                // padding: EdgeInsets.zero,
                                padding: EdgeInsets.only(
                                    left: 30, top: 10, right: 30, bottom: 10),
                                child: Text(
                                  "Change to ${_n + 1} Servings",
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
                        ],
                      ),
                    );
              }
              // print('snapshot >> is : ${snapshot.data}');
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
                  _save(widget.data.documentID, _n);
                  setState(() {});
                },
                color: Colors.redAccent[700],
                // disabledColor: Colors.grey[200],
                textColor: Colors.white,
                minWidth: MediaQuery.of(context).size.width,
                height: 0,
                // padding: EdgeInsets.zero,
                padding:
                    EdgeInsets.only(left: 30, top: 10, right: 30, bottom: 10),
                child: Text(
                  "Add to Cart",
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
          )
        ],
      )),
    );
  }
}
