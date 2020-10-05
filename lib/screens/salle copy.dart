// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// //import 'package:flutter_svg/svg.dart';
// // ignore: unused_import
// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:dolovery_app/widgets/salle.dart';
// import 'package:dolovery_app/screens/salleitem.dart';

// class SalleScreen extends StatefulWidget {
//   final Function() notifyParent;
//   final Function() notifyParent2;
//   // final Function() notifyParent2;
//   // ProfileMainScreen(thisUser);
//   SalleScreen(
//       {Key key, @required this.notifyParent, @required this.notifyParent2})
//       : super(key: key);
//   @override
//   State<StatefulWidget> createState() {
//     return SalleScreenState();
//   }
// }

// // String finalDate = '';

// getCurrentDate() {
//   final DateTime now = DateTime.now();
//   final DateFormat formatter = DateFormat('yMMMMd');
//   final String formatted = formatter.format(now);
//   return formatted; // s
// }

// String formattedThisMonth;
// var date;
// var dateParse;

// getMonth() {
//   // DateTime now = DateTime.now();
//   date = new DateTime.now().toString();

//   dateParse = DateTime.parse(date);

//   formattedThisMonth = "${dateParse.month}-${dateParse.year}";
//   // DateFormat thisMonth = DateFormat('yM');
//   // formattedThisMonth = thisMonth.format(now);
// }

// setSalle() async {
//   Map<String, dynamic> week = {
//     "1": "Lebanese_Freekeh_With_Chicken",
//     "2": "Lebanese_Freekeh_With_Chicken",
//     "3": "Lebanese_Freekeh_With_Chicken",
//     "4": "Lebanese_Freekeh_With_Chicken",
//     "5": "Lebanese_Freekeh_With_Chicken",
//     "6": "Lebanese_Freekeh_With_Chicken",
//     "7": "Lebanese_Freekeh_With_Chicken",
//     "8": "Lebanese_Freekeh_With_Chicken",
//     "9": "Lebanese_Freekeh_With_Chicken",
//     "10": "Lebanese_Freekeh_With_Chicken",
//     "11": "Lebanese_Freekeh_With_Chicken",
//     "12": "Lebanese_Freekeh_With_Chicken",
//     "13": "Lebanese_Freekeh_With_Chicken",
//     "14": "Lebanese_Freekeh_With_Chicken",
//     "15": "Lebanese_Freekeh_With_Chicken",
//     "16": "Lebanese_Freekeh_With_Chicken",
//     "17": "Lebanese_Freekeh_With_Chicken",
//     "18": "Lebanese_Freekeh_With_Chicken",
//     "19": "Lebanese_Freekeh_With_Chicken",
//     "20": "Lebanese_Freekeh_With_Chicken",
//     "21": "Lebanese_Freekeh_With_Chicken",
//     "22": "Lebanese_Freekeh_With_Chicken",
//     "23": "Lebanese_Freekeh_With_Chicken",
//     "24": "Lebanese_Freekeh_With_Chicken",
//     "25": "Lebanese_Freekeh_With_Chicken",
//     "26": "Lebanese_Freekeh_With_Chicken",
//     "27": "Lebanese_Freekeh_With_Chicken",
//     "28": "Lebanese_Freekeh_With_Chicken",
//     "29": "Lebanese_Freekeh_With_Chicken",
//     "30": "Lebanese_Freekeh_With_Chicken",
//     "31": "Lebanese_Freekeh_With_Chicken",

//     // "Monday": "Lebanese_Freekeh_With_Chicken",
//     // "Tuesday": "Lebanese_Freekeh_With_Chicken",
//     // "Wednesday": "Lebanese_Freekeh_With_Chicken",
//     // "Thursday": "Lebanese_Freekeh_With_Chicken",
//     // "Friday": "Lebanese_Freekeh_With_Chicken",
//     // "Saturday": "Lebanese_Freekeh_With_Chicken",
//     // "Sund6ay": "Lebanese_Freekeh_With_Chicken",
//   };
//   Map<String, dynamic> month = {
//     "Week 1": week,
//     "Week 2": week,
//     "Week 3": week,
//     "Week 4": week,
//   };

//   Firestore.instance.collection('salle').document('10-2020').setData(week);
// }

// class SalleScreenState extends State<SalleScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final weeks = [
//     "Monday",
//     "Tuesday",
//     "Wednesday",
//     "Thursday",
//     "Friday",
//     "Saturday",
//     "Sunday"
//   ];

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print("initState");
//     getMonth();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     // var newdate = DateTime.parse("1969-07-01").day;
//     // setSalle();
//     // DateTime now = DateTime.now();
//     // DateFormat thisMonth = DateFormat('yM');
//     // String formattedThisMonth = thisMonth.format(now);
//     return SafeArea(
//       child: ListView(
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               SizedBox(
//                 width: 7,
//               ),
//               Expanded(
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () {
//                       widget.notifyParent();
//                       // Navigator.pop(context);
//                     },
//                     child: Icon(
//                       Icons.keyboard_arrow_left,
//                       color: Colors.black,
//                       size: 30.0,
//                     ),
//                   ),
//                 ),
//               ),
//               Text(formattedThisMonth.toString()),
//               Padding(
//                 padding: const EdgeInsets.all(13.0),
//                 child: Text(
//                   getCurrentDate(),
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontWeight: FontWeight.w800,
//                     fontSize: 16.0,
//                     fontFamily: 'Axiforma',
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//               Spacer()
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0, bottom: 8),
//             child: Container(
//               // color: Colors.orangeAccent,
//               height: 150,
//               child: Image.asset(
//                 'assets/images/salle.png',
//                 width: 400,
//                 height: 150,
//               ),
//             ),
//           ),
//           DefaultTabController(
//               length: 4,
//               initialIndex: 0,
//               child: Column(
//                 children: <Widget>[
//                   TabBar(
//                       labelColor: Colors.black,
//                       unselectedLabelColor: Colors.grey[500],
//                       tabs: [
//                         Tab(text: 'Week 1'),
//                         Tab(text: 'Week 2'),
//                         Tab(text: 'Week 3'),
//                         Tab(text: 'Week 4')
//                       ]),
//                   StreamBuilder(
//                     stream: Firestore.instance
//                         .collection('salle')
//                         .document(formattedThisMonth)
//                         .snapshots(),
//                     builder: (context, sallesnapshot) {
//                       if (!sallesnapshot.hasData)
//                         return Text('loading...');
//                       else
//                         return Container(
//                           height: height - 345,
//                           child: TabBarView(children: [
//                             for (var numb = 1; numb < 5; numb++)
//                               // ListView(
//                               //   controller:
//                               //       new ScrollController(keepScrollOffset: true),
//                               //   children: List.generate(7, (dayindex) {
//                               // if (dayindex == 0)
//                               SingleChildScrollView(
//                                 scrollDirection: Axis.vertical,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(bottom: 30.0),
//                                   child: Column(
//                                     children: [
//                                       for (var dayindex = 1 + ((numb - 1) * 7);
//                                           dayindex < 8 + ((numb - 1) * 7);
//                                           dayindex++)
//                                         Column(
//                                           children: [
//                                             Align(
//                                               alignment: Alignment.centerLeft,
//                                               child: Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     left: 20.0, top: 13),
//                                                 child: Text(
//                                                   // weeks[dayindex - 1],
//                                                   dayindex.toString(),
//                                                   //  + dateParse.month.toString(),
//                                                   textAlign: TextAlign.left,
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.w800,
//                                                     fontSize: 16.0,
//                                                     fontFamily: 'Axiforma',
//                                                     color: Colors.black,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             StreamBuilder(
//                                               stream: Firestore.instance
//                                                   .collection('products')
//                                                   .document(sallesnapshot.data[
//                                                       (dayindex).toString()])
//                                                   .snapshots(),
//                                               builder: (context, snapshot) {
//                                                 print(sallesnapshot.data[
//                                                     (dayindex).toString()]);
//                                                 print('index above');

//                                                 if (sallesnapshot.data[
//                                                         (dayindex)
//                                                             .toString()] ==
//                                                     null)
//                                                   return Container();
//                                                 else
//                                                   // var salleid = dayindex > 9
//                                                   //     ? '01'
//                                                   //     : sallesnapshot
//                                                   //         .data[dayindex.toString()];
//                                                   return GestureDetector(
//                                                     onTap: () {
//                                                       Navigator.of(context)
//                                                           .push(MaterialPageRoute(
//                                                               builder: (context) => SalleItem(
//                                                                   snapshot.data,
//                                                                   weeks[0],
//                                                                   snapshot.data[
//                                                                       'serving_prices'],
//                                                                   snapshot.data[
//                                                                       'descriptions'])))
//                                                           .then((_) {
//                                                         // widgenotifyParent2();
//                                                         setState(() {});
//                                                       });
//                                                     },
//                                                     child:
//                                                         // Text(snapshot
//                                                         //         .data['name']
//                                                         //         .toString()
//                                                         SalleImage(
//                                                             salleName: snapshot
//                                                                 .data['name'],
//                                                             sallePhoto:
//                                                                 snapshot.data['image'] ==
//                                                                         null
//                                                                     ? 's'
//                                                                     : snapshot
//                                                                             .data[
//                                                                         'image'],
//                                                             salleArabicName:
//                                                                 snapshot.data[
//                                                                     'arabic_name'],
//                                                             salleItems: snapshot
//                                                                 .data['items']
//                                                                 .toString(),
//                                                             salleTime: snapshot
//                                                                 .data['time']
//                                                                 .toString(),
//                                                             salleID: snapshot
//                                                                 .data
//                                                                 .documentID,
//                                                             salleStartingPrice:
//                                                                 snapshot
//                                                                     .data['serving_prices']
//                                                                         [0]
//                                                                     .toString()),
//                                                   );
//                                               },
//                                             ),
//                                           ],
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             //   }),
//                             // ),
//                             // Column(
//                             //   children: [
//                             //     for (var days = 0; days < 7; days++)
//                             //       // var newdays =
//                             //       //                     ? days
//                             //       //                         .toString()
//                             //       //
//                             //       //                     : days.toString()

//                             //   ],
//                             // )

//                             // buildSalleList(1, snapshot),
//                             // buildSalleList(2, snapshot),
//                             // buildSalleList(3, snapshot),
//                             // buildSalleList(4, snapshot),
//                           ]),
//                         );
//                     },
//                   ),
//                 ],
//               ))
//         ],
//       ),
//     );
//   }

//   Center buildSalleList(weekNumber, monthSpanshot) {
//     return Center(
//       child: Padding(
//           padding:
//               const EdgeInsets.only(left: 5.0, right: 5, top: 0, bottom: 0),
//           child: StreamBuilder(
//             stream: Firestore.instance
//                 .collection('snapshot')
//                 // .where('salle', isEqualTo: true)
//                 .document()
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return ListView(
//                   // MediaQuery.of(context).size.height / 1100,
//                   controller: new ScrollController(keepScrollOffset: true),
//                   // shrinkWrap: true,
//                   // scrollDirection: Axis.vertical,
//                   children: List.generate(1, (index) {
//                     return
//                         // Text(snapshot.data[index]['name'].toString());
//                         Column(
//                       children: <Widget>[
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 20.0, top: 13),
//                             child: Text(
//                               weeks[index],
//                               textAlign: TextAlign.left,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w800,
//                                 fontSize: 16.0,
//                                 fontFamily: 'Axiforma',
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.of(context)
//                                 .push(MaterialPageRoute(
//                                     builder: (context) => SalleItem(
//                                         snapshot.data.documents[index],
//                                         weeks[index],
//                                         snapshot.data.documents[index]
//                                             ['serving_prices'],
//                                         snapshot.data.documents[index]
//                                             ['descriptions'])))
//                                 .then((_) {
//                               widget.notifyParent2();
//                               setState(() {});
//                             });
//                           },
//                           child: SalleImage(
//                               salleName: snapshot.data.documents[index]['name'],
//                               sallePhoto: snapshot.data.documents[index]
//                                   ['image'],
//                               salleArabicName: snapshot.data.documents[0]
//                                   ['arabic_name'],
//                               salleItems: snapshot
//                                   .data.documents[index]['items']
//                                   .toString(),
//                               salleTime: snapshot
//                                   .data.documents[index]['salle_time']
//                                   .toString(),
//                               salleID:
//                                   snapshot.data.documents[index].documentID,
//                               salleStartingPrice: snapshot
//                                   .data.documents[index]['serving_prices'][0]
//                                   .toString()),
//                         )
//                       ],
//                     );
//                   }).toList(),
//                 );
//               } else if (snapshot.hasError) {
//                 return Text(snapshot.error.toString());
//               }
//               return Center(child: CircularProgressIndicator());
//             },
//           )),
//     );
//   }
// }
