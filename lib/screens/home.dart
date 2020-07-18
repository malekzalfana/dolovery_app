import 'package:dolovery_app/widgets/product.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import '../screens/100lebanese.dart';
import '../screens/profile.dart';
import 'package:dolovery_app/widgets/shopImage.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0.0,
        //   leading: BackButton(color: Colors.black),
        //   centerTitle: true,
        //   title: Text(
        //     "Enter Details",
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //       fontWeight: FontWeight.w800,
        //       fontSize: 16.0,
        //       fontFamily: 'Axiforma',
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 30.0, bottom: 10.0),
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
                      // _signInOut();
                    },
                    color: Colors.redAccent[700],
                    textColor: Colors.white,
                    minWidth: 0,
                    height: 0,
                    // padding: EdgeInsets.zero,
                    padding:
                        EdgeInsets.only(left: 6, top: 0, right: 6, bottom: 1),
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
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 10.0, top: 0.0, bottom: 10.0),
            child: Row(
              children: <Widget>[
                Text(
                  "What are you looking for?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 10),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 0),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                // color: Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: <Widget>[
                  Image.asset("assets/icons/searchicon.png", height: 16),
                  SizedBox(width: 16),
                  Container(
                    child: Text(
                      "Search for anything",
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: "Axiforma",
                        color: Color(0xFFA0A5BD),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 135,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.07),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 8), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => TabsDemo()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "100% Lebanese",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20.0,
                              fontFamily: 'Axiforma',
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "20+ Shops ready to deliver",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              fontFamily: 'Axiforma',
                              color: Colors.redAccent[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/lebsec.png',
                    width: 120,
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 135,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.07),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 8), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Supplements",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20.0,
                              fontFamily: 'Axiforma',
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "20+ Shops ready to deliver",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              fontFamily: 'Axiforma',
                              color: Colors.redAccent[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/supsec.png',
                    width: 120,
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 135,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.07),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 8), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      // Navigator.of(context).pop();
                      // _welcomePopUp(context, "Malek Zalfana");
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Pet Shops",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20.0,
                              fontFamily: 'Axiforma',
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "20+ Shops ready to deliver",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              fontFamily: 'Axiforma',
                              color: Colors.redAccent[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/petsec.png',
                    width: 120,
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
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
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileScreen()));
                    },
                    child: Image.asset("assets/images/fullfilldolovery.png",
                        height: 23))
              ],
            ),
          ),
          Padding(
              padding:
                  const EdgeInsets.only(left: 5.0, right: 5, top: 0, bottom: 0),
              child: StreamBuilder(
                stream: Firestore.instance.collection('products').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio:
                          MediaQuery.of(context).size.height / 1100,
                      controller: new ScrollController(keepScrollOffset: false),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: List.generate(8, (index) {
                        return ProductImage(
                            productName: snapshot.data.documents[0]['name'],
                            productImage: snapshot.data.documents[0]['image'],
                            productPrice: snapshot
                                .data.documents[0]['shop_price']
                                .toString());
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8)),
              onPressed: () {
                // _signInOut();
              },
              elevation: 0,
              color: Colors.grey[100],
              // textColor: Colors.black45,
              minWidth: MediaQuery.of(context).size.width - 20,
              height: 0,
              // padding: EdgeInsets.zero,
              padding: EdgeInsets.only(left: 6, top: 10, right: 6, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "View All Lebanese Products".toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14.0,
                      fontFamily: 'Axiforma',
                      color: Colors.black38,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black38,
                    size: 20.0,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Monthly Bundle",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileScreen()));
                    },
                    child: Image.asset("assets/images/fullfilldolovery.png",
                        height: 23))
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, top: 0, bottom: 20),
              child: StreamBuilder(
                stream: Firestore.instance.collection('bundles').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Hexcolor(snapshot.data.documents[0]['bcolor']),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.07),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 8), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 15, left: 15),
                                  child: Text(
                                    snapshot.data.documents[0]['title'],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18.0,
                                      fontFamily: 'Axiforma',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      snapshot.data.documents[0]['price'] +
                                          "L.L.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17.0,
                                        fontFamily: 'Axiforma',
                                        color: Hexcolor(snapshot
                                            .data.documents[0]['buttoncolor']),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, left: 15),
                                  child: Text(
                                    snapshot.data.documents[0]['details'],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13.0,
                                      fontFamily: 'Axiforma',
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      snapshot.data.documents[0]['image']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: null /* add child content here */,
                            ),
                          )
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Supplements",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileScreen()));
                    },
                    child: Image.asset("assets/images/fullfilldolovery.png",
                        height: 23))
              ],
            ),
          ),
          Padding(
              padding:
                  const EdgeInsets.only(left: 5.0, right: 5, top: 0, bottom: 0),
              child: StreamBuilder(
                stream: Firestore.instance.collection('products').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio:
                          MediaQuery.of(context).size.height / 1100,
                      controller: new ScrollController(keepScrollOffset: false),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: List.generate(8, (index) {
                        return ProductImage(
                            productName: snapshot.data.documents[1]['name'],
                            productImage: snapshot.data.documents[1]['image'],
                            productPrice: snapshot
                                .data.documents[0]['shop_price']
                                .toString());
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8)),
              onPressed: () {
                // _signInOut();
              },
              elevation: 0,
              color: Colors.grey[100],
              // textColor: Colors.black45,
              minWidth: MediaQuery.of(context).size.width - 20,
              height: 0,
              // padding: EdgeInsets.zero,
              padding: EdgeInsets.only(left: 6, top: 10, right: 6, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "View All Suppliments Products".toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14.0,
                      fontFamily: 'Axiforma',
                      color: Colors.black38,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black38,
                    size: 20.0,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Pet Shops",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileScreen()));
                    },
                    child: Image.asset("assets/images/fullfilldolovery.png",
                        height: 23))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: StreamBuilder(
              stream: Firestore.instance.collection('shops').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot);
                  return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: List<Widget>.generate(10, (int index) {
                        // print(categories[index]);
                        return ShopImage(
                            shopName: snapshot.data.documents[1]['name'],
                            shopImage: snapshot.data.documents[1]['image'],
                            shopTime:
                                snapshot.data.documents[1]['time'].toString());
                      })));
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    ));
  }
}
