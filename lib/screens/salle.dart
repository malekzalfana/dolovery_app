import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';
import 'package:intl/intl.dart';
import 'package:dolovery_app/widgets/salle.dart';
import 'package:dolovery_app/screens/salleitem.dart';

class SalleScreen extends StatefulWidget {
  final Function() notifyParent;
  // final Function() notifyParent2;
  // ProfileMainScreen(thisUser);
  SalleScreen({Key key, @required this.notifyParent}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return SalleScreenState();
  }
}

// String finalDate = '';

getCurrentDate() {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yMMMMd');
  final String formatted = formatter.format(now);
  return formatted; // s
}

class SalleScreenState extends State<SalleScreen> {
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 7,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    widget.notifyParent();
                    // Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.black,
                    size: 30.0,
                  ),
                ),
              ),
            ),
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
            Spacer()
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
          child: Container(
            // color: Colors.orangeAccent,
            height: 150,
            child: Image.asset(
              'assets/images/salle.png',
              width: 400,
              height: 150,
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
                  children: List.generate(1, (index) {
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
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SalleItem(
                                    snapshot.data,
                                    weeks[index],
                                    snapshot.data.documents[index]
                                        ['serving_prices'],
                                    snapshot.data.documents[index]
                                        ['descriptions'])));
                          },
                          child: SalleImage(
                              salleName: snapshot.data.documents[index]['name'],
                              sallePhoto: snapshot.data.documents[index]
                                  ['image'],
                              salleArabicName: snapshot.data.documents[0]
                                  ['arabic_name'],
                              salleItems: snapshot
                                  .data.documents[index]['items']
                                  .toString(),
                              salleTime: snapshot
                                  .data.documents[index]['salle_time']
                                  .toString(),
                              salleID:
                                  snapshot.data.documents[index].documentID,
                              salleStartingPrice: snapshot
                                  .data.documents[index]['shop_price']
                                  .toString()),
                        )
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
