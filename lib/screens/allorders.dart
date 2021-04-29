import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dolovery_app/screens/orderpage.dart';
import 'package:dolovery_app/widgets/recentorder.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Orders extends StatefulWidget {
  final String uid;
  Orders({Key key, this.uid}) : super(key: key);

  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                          Navigator.pop(context);
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
                    padding: const EdgeInsets.fromLTRB(13, 0, 13, 0),
                    child: Text(
                      'Recent Orders',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: Adaptive.sp(13),
                        fontFamily: 'Axiforma',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Spacer()
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    StreamBuilder(
                      stream: Firestore.instance
                          .collection('orders')
                          .where('user', isEqualTo: widget.uid)
                          .orderBy('date', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print(snapshot);
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: List<Widget>.generate(
                                        snapshot.data.documents.length,
                                        (int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderPage(snapshot
                                                          .data
                                                          .documents[index]
                                                          .documentID)));
                                        },
                                        child: RecentOrder(
                                            orderDate: snapshot
                                                .data.documents[index]['date'],
                                            orderCount: snapshot
                                                .data.documents[index]['count']
                                                .toInt(),
                                            orderImage: snapshot
                                                .data.documents[index]['image'],
                                            orderPrice: snapshot
                                                .data.documents[index]['total']
                                                .toString()),
                                      );
                                    })),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
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
