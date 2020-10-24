import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dolovery_app/widgets/product.dart';
import 'package:intl/intl.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dolovery_app/widgets/counter.dart';

class OrderPage extends StatefulWidget {
  final String orderid;
  OrderPage(this.orderid, {Key key})
      : super(key: key); //add also..example this.abc,this...

  @override
  State<StatefulWidget> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // String order;
  // int serving = 0;

  @override
  void initState() {
    super.initState();
    // getSalleStatus();
  }

  bool showChangeButton = false;

  // Future getOrder

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // var timestamp = (widget.data['salle_date'] as Timestamp).toDate();
    // String formatted_date = DateFormat.yMMMMd().format(timestamp);
    return new Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,

            // automaticallyImplyLeading: false,
            //BackButton(color: Colors.black),
            centerTitle: true,
            // title: Text(
            //   'Order Details',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     fontWeight: FontWeight.w800,
            //     fontSize: 16.0,
            //     fontFamily: 'Axiforma',
            //     color: Colors.black,
            //   ),
            // ),
          ),
          // Text('${widget.order}'),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 20),
            child: Image.asset(
              'assets/images/check-mark.png',
              // height: 120.0,
              width: 120.0,
            ),
          ),
          Text(
            "Order Successful",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 25.0,
              fontFamily: 'Axiforma',
              // color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: Text(
              "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
                height: 1.15,
                fontFamily: 'Axiforma',
                color: Colors.black54,
              ),
            ),
          ),
          // Text(widget.orderid.toString()),
          SizedBox(
            height: 20,
          ),

          StreamBuilder(
              stream: Firestore.instance
                  .collection('orders')
                  .document(widget.orderid.toString())
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Text("Loading");
                }
                var order = snapshot.data;
                return SizedBox(
                  width: width - 20,
                  child: Container(
                    // color: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var shop in order.data['products'].keys)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 10),
                                  child: Text(
                                    order.data['products'][shop]['data']
                                        ['name'],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 19.0,
                                        fontFamily: 'Axiforma',
                                        color: Colors.black),
                                  ),
                                ),
                                for (var product in order
                                    .data['products'][shop]['products'].keys)
                                  // Text(order.data['products'][shop][product]['name']),
                                  // ]
                                  buildCartItem(
                                    product,
                                    order.data['products'][shop]['products']
                                        [product]['count'],
                                    order.data['products'][shop]['products']
                                        [product]['data']['name'],
                                    order.data['products'][shop]['products']
                                        [product]['data']['image'],
                                    order.data['products'][shop]['products']
                                        [product]['data']['shop_discounted'],
                                    order.data['products'][shop]['products']
                                                [product]['data']['type'] !=
                                            'salle'
                                        ? (int.parse(order.data['products'][shop]['products'][product]['data']['shop_price'].toString()) *
                                                (order.data['products'][shop]['products'][product]['rate'] != null
                                                    ? order.data['products']
                                                            [shop]['products']
                                                        [product]['rate']
                                                    : 1))
                                            .toString()
                                        : order.data['products'][shop]['products']
                                                [product]['data']['serving_prices']
                                                [order.data['products'][shop]['products'][product]['count']]
                                            .toString(),
                                    order.data['products'][shop]['products']
                                        [product]['data']['type'],
                                    order.data['products'][shop]['products']
                                        [product]['data']['arabic_name'],
                                    order.data['products'][shop]['products']
                                            [product]['data']['unit']
                                        .toString(),
                                  )
                              ],
                            ),
                          SizedBox(height: 0),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 0),
                            child: Text(
                              'Total Price:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17.0,
                                  fontFamily: 'Axiforma',
                                  color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 0.0, bottom: 10),
                            child: Text(
                              order.data['total'].toString() + 'L.L.',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 25.0,
                                  fontFamily: 'Axiforma',
                                  color: Colors.redAccent[700]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.redAccent[700],
              textColor: Colors.white,
              minWidth: 0,
              height: 0,
              // padding: EdgeInsets.zero,
              padding:
                  EdgeInsets.only(left: 30, top: 10, right: 30, bottom: 10),
              child: Text(
                "Continue",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  fontFamily: 'Axiforma',
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),

          // Column(
          //   children: [
          //     for (var shop in widget.order['products'].keys)
          //       Text('${shop.toString()}')
          //   ],
          // )
        ],
      )),
    );
  }

  getShop(shop) async {
    // print('seraching for: $shop');
    var document = await Firestore.instance
        .collection('shops')
        .where("username", isEqualTo: shop)
        .getDocuments();
    return document.documents[0];
  }

  Padding buildCartItem(
    String productid,
    int count,
    String product_name,
    String product_image,
    String product_discount,
    String product_price,
    String product_type,
    String arabic_name,
    String product_unit,
    // String salle_price
  ) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(
        "$arabic_name and $count $product_discount $product_image $product_name $product_price $product_type $product_unit $productid ");
    // if ()
    // if (cartitem['currency'] != "dollar") {
    //   rate = 1;
    // }
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 15, 5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            // color: Colors.green,
            margin: new EdgeInsets.only(left: 12.0, right: 10),
            child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
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
                child: Center(
                    child: CachedNetworkImage(
                  width: 120,
                  placeholder: (context, url) => Image.asset(
                      "assets/images/loading.gif",
                      height: 50,
                      width: 50),
                  imageUrl: product_image == null ? "s" : product_image,
                  errorWidget: (context, url, error) =>
                      Center(child: new Icon(Icons.error)),
                )
                    // Image.network(product_image, height: 50, width: 50),
                    )),
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: width - 160,
                      child: Text(
                        product_name,
                        // textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          height: 1.16,
                          fontFamily: 'Axiforma',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: product_type == 'salle' && arabic_name != null,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: SizedBox(
                      width: width - 200,
                      child: Text(
                        arabic_name != null ? arabic_name : '',
                        // textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          height: 1.1,
                          fontFamily: 'Axiforma',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: Row(
                          children: [
                            Visibility(
                              visible: true,
                              child: Text(
                                product_price + "L.L.",
                                // overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,

                                style: TextStyle(
                                  height: 1.1,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13,
                                  fontFamily: 'Axiforma',
                                  color: Colors.redAccent[700],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: product_type == 'salle' ? true : false,
                              child: Text(
                                product_type == 'salle'
                                    ? ''
                                    : product_price + "L.L.",
                                // overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  height: 1.1,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13,
                                  fontFamily: 'Axiforma',
                                  color: Colors.redAccent[700],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: product_type == 'salle' ? true : false,
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  onPressed: () {},
                                  color: Colors.redAccent[700],
                                  textColor: Colors.white,
                                  minWidth: 0,
                                  height: 0,
                                  // padding: EdgeInsets.zero,
                                  padding: EdgeInsets.only(
                                      left: 6, top: 2, right: 6, bottom: 1),
                                  child: Text(
                                    (count + 1).toString() + ' Servings',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12.0,
                                      fontFamily: 'Axiforma',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: product_type == 'salle' ? false : true,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent[700],
                                      // border: Border.all(
                                      //   color: Colors.green[500],
                                      // ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "x$count",
                                      // overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        height: 1.1,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13,
                                        fontFamily: 'Axiforma',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: product_type == 'salle' ? false : true,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                    child: Text(
                      product_unit.toString(),
                      // overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        height: 1.1,
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        fontFamily: 'Axiforma',
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
