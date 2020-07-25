import 'package:flutter/material.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';

class RecentOrder extends StatefulWidget {
  // final Widget child;

  final String orderCount;

  final String orderDate;

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

class _RecentOrderState extends State<RecentOrder> {
  String orderImage;
  String orderCount;
  String orderDate;
  String orderPrice;

  _RecentOrderState(
      this.orderImage, this.orderCount, this.orderDate, this.orderPrice);
  // _orderImageState(this.orderImage);
  @override
  Widget build(BuildContext context) {
    double width = 200; //MediaQuery.of(context).size.width - 22;
    return Padding(
      padding: const EdgeInsets.only(right: 10.0, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            // color: Colors.green,
            margin: new EdgeInsets.only(left: 30.0, right: 0),
            child: Container(
                height: 68,
                width: 68,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(orderImage),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.07),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 8), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: null),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 0.0, left: 6, bottom: 5),
                        child: Text(
                          orderCount + " Items",
                          // textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Axiforma',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, bottom: 8),
                            child: Text(
                              orderPrice + " L.L.",
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
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            orderDate,
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
            ),
          )
        ],
      ),
    );
  }
}
