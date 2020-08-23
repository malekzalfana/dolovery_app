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

void openProductPopUp(context, data, [sendrefreshtohome]) {
  num _defaultValue = 0;
  int _n = 0;
  bool minimum = true;
  bool maximum = false;

  // int serving = 0;

  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      isDismissible: false,
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

          _save(itemid) async {
            add();
            final prefs = await SharedPreferences.getInstance();
            List<String> cart = prefs.getStringList('cart');
            final key = 'cart';
            String type = data.documents[0][
                'type']; //prefs.getString('type') == null? 'nothing': prefs.getString('type');
            prefs.setString('type', type);
            double total = prefs.getDouble('total') == null
                ? 0
                : prefs.getDouble('total') + data.documents[0]['shop_price'];
            prefs.setDouble('total', total);
            if (cart == null) {
              cart = [];
            }
            cart.add(itemid);
            final value = cart;
            final double items = cart.length.toDouble();
            prefs.setDouble('items', items);
            prefs.setStringList(key, value);
            print('saved $value');
            print('saved $total');
            print('saved $type');
            print('saved $items');
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

          _remove(itemid) async {
            minus();
            final prefs = await SharedPreferences.getInstance();
            List<String> cart = prefs.getStringList('cart');
            final key = 'cart';
            String type = data.documents[0][
                'type']; //prefs.getString('type') == null? 'nothing': prefs.getString('type');
            prefs.setString('type', type);
            double total = prefs.getDouble('total') == null
                ? 0
                : prefs.getDouble('total') - data.documents[0]['shop_price'];
            prefs.setDouble('total', total);
            cart.remove(itemid);
            final value = cart;
            final double items = cart.length.toDouble();
            prefs.setDouble('items', items);
            prefs.setStringList(key, value);
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
              _n =
                  countOccurrencesUsingLoop(cart, data.documents[0].documentID);
              if (_n > 0) {
                minimum = false;
              }
            });
            // print (count)
          }

          _setnumber();
          // print(_n);

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
                            data.documents[0]['category'].toUpperCase(),
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
                              sendrefreshtohome();
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
                      child: Image.network(data.documents[0]['image'],
                          width: 120)),
                  Text(
                    data.documents[0]['name'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        fontFamily: 'Axiforma',
                        color: Colors.black),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        data.documents[0]['shop_price'].toString() + " L.L.",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                            fontFamily: 'Axiforma',
                            color: Colors.black),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          data.documents[0]['unit'],
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                              fontFamily: 'Axiforma',
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0, top: 20.0),
                    child: Container(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RawMaterialButton(
                            onPressed: () {
                              _remove(data.documents[0].documentID);
                            },
                            elevation: !minimum ? 2 : 0,
                            fillColor: !minimum
                                ? Colors.redAccent[700]
                                : Colors.grey[200],
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
                            child: new Text('$_n',
                                style: new TextStyle(fontSize: 20.0)),
                          ),
                          RawMaterialButton(
                            onPressed: () {
                              // add;
                              _save(data.documents[0].documentID);
                            },
                            elevation: !maximum ? 2 : 0,
                            fillColor: !maximum
                                ? Colors.redAccent[700]
                                : Colors.grey[200],
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
                    padding:
                        const EdgeInsets.only(left: 30.0, top: 30, bottom: 10),
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
                        data.documents[0]['description'],
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
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 0, bottom: 35),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        data.documents[0]['description'],
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13.0,
                          fontFamily: 'Axiforma',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
      });
}

// openProductPopUp2(context, data) {
//   num _defaultValue = 0;
//   return DraggableScrollableSheet(
//     initialChildSize: 0.3,
//     minChildSize: 0.2,
//     maxChildSize: 1.0,
//     builder: (BuildContext context, myscrollController) {
//       return Container(
//         color: Colors.tealAccent[200],
//         child: ListView.builder(
//           controller: myscrollController,
//           itemCount: 25,
//           itemBuilder: (BuildContext context, int index) {
//             return ListTile(
//                 title: Text(
//               'Dish $index',
//               style: TextStyle(color: Colors.black54),
//             ));
//           },
//         ),
//       );
//     },
//   );
// }
