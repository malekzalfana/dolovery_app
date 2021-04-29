import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:intl/intl.dart';
import 'package:dolovery_app/widgets/salle.dart';
import 'package:dolovery_app/screens/salleitem.dart';

class SalleScreen extends StatefulWidget {
  final Function() notifyParent;
  final Function() notifyParent2;

  SalleScreen(
      {Key key, @required this.notifyParent, @required this.notifyParent2})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return SalleScreenState();
  }
}

getCurrentDate() {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yMMMMd');
  final String formatted = formatter.format(now);
  return formatted;
}

String formattedThisMonth;
var date;
var dateParse;
var today;
DateTime first;

getMonth() {
  date = new DateTime.now().toString();

  dateParse = DateTime.parse(date);
  today = dateParse.day;
  DateTime first = new DateTime(2012, 1, 1);

  formattedThisMonth = "${dateParse.month}-${dateParse.year}";
  print(formattedThisMonth);
  print('^^^^^^^^^^^');
}

setSalle() async {
  Map<String, dynamic> week = {
    "1": "Lebanese_Freekeh_With_Chicken",
    "2": "Lebanese_Freekeh_With_Chicken",
    "3": "Lebanese_Freekeh_With_Chicken",
    "4": "Lebanese_Freekeh_With_Chicken",
    "5": "Lebanese_Freekeh_With_Chicken",
    "6": "Lebanese_Freekeh_With_Chicken",
    "7": "Lebanese_Freekeh_With_Chicken",
    "8": "Lebanese_Freekeh_With_Chicken",
    "9": "Lebanese_Freekeh_With_Chicken",
    "10": "Lebanese_Freekeh_With_Chicken",
    "11": "Lebanese_Freekeh_With_Chicken",
    "12": "Lebanese_Freekeh_With_Chicken",
    "13": "Lebanese_Freekeh_With_Chicken",
    "14": "Lebanese_Freekeh_With_Chicken",
    "15": "Lebanese_Freekeh_With_Chicken",
    "16": "Lebanese_Freekeh_With_Chicken",
    "17": "Lebanese_Freekeh_With_Chicken",
    "18": "Lebanese_Freekeh_With_Chicken",
    "19": "Lebanese_Freekeh_With_Chicken",
    "20": "Lebanese_Freekeh_With_Chicken",
    "21": "Lebanese_Freekeh_With_Chicken",
    "22": "Lebanese_Freekeh_With_Chicken",
    "23": "Lebanese_Freekeh_With_Chicken",
    "24": "Lebanese_Freekeh_With_Chicken",
    "25": "Lebanese_Freekeh_With_Chicken",
    "26": "Lebanese_Freekeh_With_Chicken",
    "27": "Lebanese_Freekeh_With_Chicken",
    "28": "Lebanese_Freekeh_With_Chicken",
    "29": "Lebanese_Freekeh_With_Chicken",
    "30": "Lebanese_Freekeh_With_Chicken",
    "31": "Lebanese_Freekeh_With_Chicken",
  };
  Map<String, dynamic> month = {
    "Week 1": week,
    "Week 2": week,
    "Week 3": week,
    "Week 4": week,
  };

  Firestore.instance.collection('salle').document('12-2020').setData(week);
}

var dato;

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
  void initState() {
    super.initState();
    print("initState");
    getMonth();
  }

  Future<String> getDateDay(String daynumber) {
    var date = new DateTime.now();
    var numdate = new DateTime(date.year, date.month, int.parse(daynumber));

    dato = DateFormat('EEEE, d MMM, yyyy').format(numdate).toString();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: ListView(
        children: <Widget>[
          SizedBox(height:50.0),
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
                    },
                    child: Visibility(
                      visible: false,
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.black,
                        size: 30.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
            child: Container(
              height: 150,
              child: Image.asset(
                'assets/images/salle.png',
                width: 400,
                height: 150,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Text(
              'Meal Basket',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 26.0,
                fontFamily: 'Axiforma',
                color: Colors.black,
              ),
            ),
          ),
          Spacer(),
          // shuuuwuuu pierre.. 7abbet hal condition
          if (1 == 2)
            FutureBuilder(
              future: getMonth(),
              builder: (context, snapshot) {
                return DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: Column(
                      children: <Widget>[
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection('salle')
                              .document(formattedThisMonth)
                              .snapshots(),
                          builder: (context, sallesnapshot) {
                            if (snapshot.hasError) {
                              return RaisedButton(
                                child: Text('Retry'),
                                onPressed: null,
                              );
                            }
                            if (!sallesnapshot.hasData)
                              return SizedBox(
                                height: 300,
                                child: Center(
                                    child: Image.asset(
                                        "assets/images/loading.gif",
                                        height: 30)),
                              );
                            else
                              return Container(
                                height: height - 345,
                                child: Opacity(
                                  opacity: 1,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 45.0),
                                      child: Column(
                                        children: [
                                          for (var dayindex = 1 + today;
                                              dayindex < today + (32 - today);
                                              dayindex++)
                                            Column(
                                              children: [
                                                buildDateOfSalle(
                                                    dayindex.toString(),
                                                    sallesnapshot,
                                                    dayindex,
                                                    2),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                          },
                        ),
                      ],
                    ));
              },
            ),
          if (1 == 1)
            Opacity(
              opacity: 0.3,
              child: SizedBox(
                  height: 200, child: Center(child: Text('No items found.'))),
            ),
        ],
      ),
    );
  }

  Column buildDateOfSalle(String daynumber, sallesnapshot, dayindex, numb) {
    var date = new DateTime.now();
    var numdate = new DateTime(date.year, date.month, int.parse(daynumber));

    var dato = DateFormat('EEEE, d MMM, yyyy').format(numdate).toString();
    var datenumbers = numdate.year.toString() +
        "-" +
        numdate.month.toString() +
        "-" +
        numdate.day.toString();

    return Column(
      children: [
        Opacity(
          opacity: numb == 1 ? 0.5 : 1,
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection('products')
                  .document(sallesnapshot.data[(dayindex).toString()])
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Padding(
                      padding: const EdgeInsets.only(top: 45.0),
                      child: Center(
                        child: Image.asset(
                          "assets/images/loading.gif",
                          width: 30,
                        ),
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else if (sallesnapshot.data[(dayindex).toString()] == null)
                      return Container();
                    else
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, bottom: 5, top: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                dato,
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
                              if (numb == 1) {
                                null;
                              } else {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => SalleItem(
                                            snapshot.data.data,
                                            weeks[0],
                                            snapshot.data['serving_prices'],
                                            snapshot.data['descriptions'],
                                            snapshot.data['description'],
                                            dato,
                                            datenumbers,
                                            snapshot.data.documentID +
                                                '_' +
                                                datenumbers)))
                                    .then((_) {
                                  widget.notifyParent2();
                                  setState(() {});
                                });
                              }
                            },
                            child: SalleImage(
                                salleName: snapshot.data['name'],
                                sallePhoto: snapshot.data['image'] == null
                                    ? 's'
                                    : snapshot.data['image'],
                                salleArabicName: snapshot.data['arabic_name'],
                                salleItems: snapshot.data['items'].toString(),
                                salleTime: snapshot.data['time'].toString(),
                                salleID: snapshot.data.documentID,
                                salleStartingPrice: snapshot
                                    .data['serving_prices'][0]
                                    .toString()),
                          ),
                        ],
                      );
                }
              }),
        ),
      ],
    );
  }
}
