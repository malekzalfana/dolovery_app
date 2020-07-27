import 'package:flutter/material.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'dart:async';
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
  ProductPopUp(data, {Key key}) : super(key: key);

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

void openProductPopUp(context, data) {
  num _defaultValue = 0;
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // mpesachecked =false;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
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
                  Counter(
                    initialValue: _defaultValue,
                    minValue: 0,
                    // buttonSize: 20,
                    maxValue: 10,
                    step: 1,
                    decimalPlaces: 0,
                    textStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18.0,
                        fontFamily: 'Axiforma',
                        color: Colors.black),
                    onChanged: (value) {
                      mystate(() {
                        _defaultValue = value;
                      });
                      // get the latest value from here
                    },
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
                  )
                ],
              ),
            ),
          );
        });
      });
}

openProductPopUp2(context, data) {
  num _defaultValue = 0;
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
}
