import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dolovery_app/widgets/product.dart';
import 'package:intl/intl.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPage extends StatefulWidget {
  final String orderid;
  OrderPage(this.orderid, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    super.initState();
  }

  bool showChangeButton = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return new Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          AppBar(
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 20),
            child: Image.asset(
              'assets/images/check-mark.png',
              width: Adaptive.w(50),
            ),
          ),
          Text(
            "Order Successful",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: Adaptive.sp(20),
              fontFamily: 'Axiforma',
            ),
          ),
          SizedBox(height: 10),
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
                  width: width - 50,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 0),
                            child: Text(
                              'Address',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: Adaptive.sp(14),
                                  fontFamily: 'Axiforma',
                                  color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 7.0, bottom: 10),
                            child: Text(
                              "${order.data['address']['city'].toString()}, ${order.data['address']['street_address'].toString()}, ${order.data['address']['landmark'].toString()}, ${order.data['address']['apartment'].toString()}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: Adaptive.sp(13.5),
                                  fontFamily: 'Axiforma',
                                  color: Colors.black),
                            ),
                          ),
                          for (var shop in order.data['products'].keys)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        order.data['products'][shop]
                                            ['shop_name'],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: Adaptive.sp(15),
                                            fontFamily: 'Axiforma',
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: StreamBuilder(
                                            stream: Firestore.instance
                                                .collection('shop_orders')
                                                .document(order.data['products']
                                                    [shop]['order_id'])
                                                .snapshots(),
                                            builder: (context,
                                                AsyncSnapshot<DocumentSnapshot>
                                                    snapshot) {
                                              print(order.data['products'][shop]
                                                      ['order_id']
                                                  .toString());
                                              // print(snapshot.data.data);
                                              if (!snapshot.hasData) {
                                                return Text("..");
                                              } else {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(snapshot
                                                      .data['status']
                                                      .toString()
                                                      .toUpperCase()),
                                                );
                                              }
                                            }),
                                      )
                                    ],
                                  ),
                                ),
                                for (var product in order
                                    .data['products'][shop]['products'].keys)
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
                                        ? (double.parse(order.data['products'][shop]['products'][product]['data']['shop_price'].toString()).toInt() *
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
                          SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 0),
                            child: Text(
                              'Total Price:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: Adaptive.sp(14),
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
                                  fontSize: Adaptive.sp(21),
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
          SizedBox(height: 30),
        ],
      )),
    );
  }

  getShop(shop) async {
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
  ) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(
        "$arabic_name and $count $product_discount $product_image $product_name $product_price $product_type $product_unit $productid ");

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: new EdgeInsets.only(left: 0.0, right: 10),
            child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.07),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 8),
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
                      height: 20,
                      width: 20),
                  imageUrl: product_image == null ? "s" : product_image,
                  errorWidget: (context, url, error) =>
                      Center(child: new Icon(Icons.error)),
                ))),
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
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  height: 1.1,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "x$count",
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
