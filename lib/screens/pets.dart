import 'package:dolovery_app/screens/shoppage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';
import 'package:intl/intl.dart';
import 'package:dolovery_app/widgets/shopList.dart';

class PetsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

// String finalDate = '';

getCurrentDate() {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yMMMMd');
  final String formatted = formatter.format(now);
  return formatted; // s
}

class FormScreenState extends State<PetsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Visibility(
              visible: false,
              child: Padding(
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
            ),
            Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 10.0, top: 55.0, bottom: 10.0),
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Pets",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28.0,
                            fontFamily: 'Axiforma',
                            color: Colors.black,
                          ),
                        ),
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
                        // Image.asset("assets/images/fullfilldolovery.png",
                        //     height: 23),
                      ],
                    ),
                  ),
                ])),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('shops')
                    .where('type', isEqualTo: 'pets')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot);
                    return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                            children: List<Widget>.generate(
                                snapshot.data.documents.length, (int index) {
                          // print(categories[index]);
                          return GestureDetector(
                            onTap: () {
                              // Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ShopPage(
                                      snapshot.data.documents[index])));
                            },
                            child: ShopList(
                                shopName: snapshot.data.documents[index]
                                    ['name'],
                                shopImage: snapshot.data.documents[index]
                                    ['image'],
                                shopTime: snapshot.data.documents[index]['time']
                                    .toString(),
                                shopAddress: snapshot.data.documents[index]
                                    ['address']),
                          );
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
      ),
    );
  }
}
