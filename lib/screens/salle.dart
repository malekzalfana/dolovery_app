import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';
import 'package:intl/intl.dart';
import 'package:dolovery_app/widgets/salle.dart';

class SalleScreen extends StatefulWidget {
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

class FormScreenState extends State<SalleScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final weeks = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return ListView(
      children: <Widget>[
        // AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0.0,
        //   automaticallyImplyLeading: false,
        //   //BackButton(color: Colors.black),
        //   centerTitle: true,
        //   title: Text(
        //     getCurrentDate(),
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //       fontWeight: FontWeight.w800,
        //       fontSize: 16.0,
        //       fontFamily: 'Axiforma',
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.all(13.0),
          child: Text(
            getCurrentDate(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16.0,
              fontFamily: 'Axiforma',
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
          child: Container(
            // color: Colors.orangeAccent,
            height: 150,
            child: Hero(
              tag: 'salle',
              child: Image.asset(
                'assets/images/lebsec.png',
                width: 400,
                height: 150,
              ),
            ),
          ),
        ),
        DefaultTabController(
            length: 4,
            initialIndex: 0,
            child: Column(
              children: <Widget>[
                TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey[500],
                    tabs: [
                      Tab(text: 'Week 1'),
                      Tab(text: 'Week 2'),
                      Tab(text: 'Week 3'),
                      Tab(text: 'Week 4')
                    ]),
                Container(
                  height: height - 345,
                  child: TabBarView(children: [
                    buildSalleList(),
                    buildSalleList(),
                    buildSalleList(),
                    buildSalleList(),
                  ]),
                )
              ],
            ))
      ],
    );
  }

  Center buildSalleList() {
    return Center(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 5.0, right: 5, top: 0, bottom: 0),
          child: StreamBuilder(
            stream: Firestore.instance
                .collection('products')
                .where('salle', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  // MediaQuery.of(context).size.height / 1100,
                  controller: new ScrollController(keepScrollOffset: true),
                  // shrinkWrap: true,
                  // scrollDirection: Axis.vertical,
                  children: List.generate(5, (index) {
                    return Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 13),
                            child: Text(
                              weeks[index],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16.0,
                                fontFamily: 'Axiforma',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SalleImage(
                            salleName: snapshot.data.documents[0]['name'],
                            sallePhoto: snapshot.data.documents[0]['image'],
                            salleArabicName: snapshot.data.documents[0]
                                ['arabicname'],
                            salleItems:
                                snapshot.data.documents[0]['item'].toString(),
                            salleTime:
                                snapshot.data.documents[0]['time'].toString(),
                            salleStartingPrice: snapshot
                                .data.documents[0]['starting_price']
                                .toString())
                      ],
                    );
                  }).toList(),
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            },
          )),
    );
  }
}