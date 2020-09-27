import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';

class RecentOrder extends StatefulWidget {
  // final Widget child;

  final int orderCount;

  final Timestamp orderDate;

  final String orderImage;

  final String orderPrice;

  RecentOrder(
      {Key key,
      this.orderCount,
      this.orderDate,
      this.orderImage,
      this.orderPrice})
      : super(key: key);

  @override
  _RecentOrderState createState() => _RecentOrderState(
      this.orderImage, this.orderCount, this.orderDate, this.orderPrice);
}

// var newOrderDate;

class _RecentOrderState extends State<RecentOrder> {
  String orderImage;
  int orderCount;
  Timestamp orderDate;
  String orderPrice;

  _RecentOrderState(
      this.orderImage, this.orderCount, this.orderDate, this.orderPrice);
  // _orderImageState(this.orderImage);
  @override
  Widget build(BuildContext context) {
    var timestamp = (orderDate as Timestamp).toDate();
    num _defaultValue = 0;
    String newOrderDate = DateFormat.yMMMMd().format(timestamp);
    print('thi s is the new image $orderImage');
// double width = 200;
    double width = MediaQuery.of(context).size.width - 22;
    return Padding(
      padding: const EdgeInsets.only(right: 0, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            // color: Colors.green,
            width: width - 30,
            margin: new EdgeInsets.only(left: 30.0, right: 0),
            child: Container(
                height: 80,
                width: width - 100,
                decoration: BoxDecoration(
                  // image: DecorationImage(
                  //   image: NetworkImage(orderImage),
                  //   fit: BoxFit.cover,
                  // ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2.2,
                      blurRadius: 2.5,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0.0, left: 6, bottom: 5),
                              child: Text(
                                int.parse(orderCount.toString()).toString() +
                                    " Items",
                                // textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  fontFamily: 'Axiforma',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 8),
                                    child: Text(
                                      orderPrice + " L.L.",
                                      // overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        height: 1,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        fontFamily: 'Axiforma',
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                newOrderDate,
                                // overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  height: 1,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13.6,
                                  fontFamily: 'Axiforma',
                                  color: Colors.grey[500],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
