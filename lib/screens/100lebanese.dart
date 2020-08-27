import 'package:dolovery_app/widgets/popupproduct.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dolovery_app/widgets/product.dart';

class TabsDemo extends StatefulWidget {
  @override
  _TabsDemoState createState() => _TabsDemoState();
}

class _TabsDemoState extends State<TabsDemo> {
  TabController _controller;

  @override
  void dispose() {
    // TODO: implement dispose
    // print("Back To old Screen");

    super.dispose();
  }

  @override
  Widget build(BuildContext ctxt) {
    var size = MediaQuery.of(ctxt).size;
    final double itemHeight = (size.height) / 2;
    final double itemWidth = size.width / 2;
    return new Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 30.0, bottom: 0.0),
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
                          () {};
                        },
                        color: Colors.redAccent[700],
                        textColor: Colors.white,
                        minWidth: 0,
                        height: 0,
                        // padding: EdgeInsets.zero,
                        padding: EdgeInsets.only(
                            left: 6, top: 0, right: 6, bottom: 1),
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
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
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
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 10.0, top: 0.0, bottom: 10.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "100% Lebanese",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0,
                              fontFamily: 'Axiforma',
                              color: Colors.black,
                            ),
                          ),
                          Image.asset("assets/images/fullfilldolovery.png",
                              height: 23),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: StreamBuilder(
                        stream: Firestore.instance
                            .collection('categroies')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children:
                                        List<Widget>.generate(10, (int index) {
                                  // print(categories[index]);
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10.0, bottom: 20),
                                    child: Container(
                                        height: 120,
                                        // 180
                                        width: 120,
                                        decoration: BoxDecoration(
                                          // image: DecorationImage(
                                          //   image: AssetImage(
                                          //       'assets/images/meat.png'),
                                          //   fit: BoxFit.cover,
                                          // ),
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15)),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.07),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  8), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Image.asset(
                                                "assets/images/meaticon.png",
                                                height: 40),
                                            Text(
                                              snapshot.data.documents[0]
                                                  ['name'],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 15.0,
                                                fontFamily: 'Axiforma',
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        )),
                                  );
                                })));
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: StreamBuilder(
                        stream: Firestore.instance
                            .collection('categroies')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children:
                                        List<Widget>.generate(10, (int index) {
                                  // print(categories[index]);
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10.0, bottom: 20),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        snapshot.data.documents[0]['name'],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16.0,
                                          fontFamily: 'Axiforma',
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                })));
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, right: 5, top: 0, bottom: 0),
                        child: StreamBuilder(
                          stream: Firestore.instance
                              .collection('products')
                              .where('type', isEqualTo: 'lebanese')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio: 0.635,
                                controller: new ScrollController(
                                    keepScrollOffset: false),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: List.generate(60, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      openProductPopUp(context,
                                          snapshot.data /*, refreshcart*/);
                                    },
                                    child: ProductImage(
                                      productName: snapshot.data.documents[0]
                                          ['name'],
                                      productImage: snapshot.data.documents[0]
                                          ['image'],
                                      productPrice: snapshot
                                          .data.documents[0]['shop_price']
                                          .toString(),
                                      productUnit: snapshot.data.documents[0]
                                                  ['unit'] !=
                                              null
                                          ? snapshot.data.documents[0]['unit']
                                          : '',
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
                    // List<Widget>.generate(categories.length, (int index) {
                    //   Container(child: Text("ssss"));
                    //   print(categories[index]);
                    //   // return ProduceAction(int, index);
                    // }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
