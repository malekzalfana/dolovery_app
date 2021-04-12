import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProductImage extends StatefulWidget {
  final String productName;

  final String productPrice;

  final String productUnit;

  final String productImage;

  final String productCurrency;

  final String shopName;

  final String oldPrice;

  ProductImage(
      {Key key,
      this.productName,
      this.productImage,
      this.productUnit,
      this.productPrice,
      this.productCurrency,
      this.shopName,
      this.oldPrice})
      : super(key: key);

  @override
  _ProductImageState createState() => _ProductImageState(
        this.productImage,
        this.productName,
        this.productPrice,
        this.productUnit,
        this.productCurrency,
        this.shopName,
        this.oldPrice,
      );
}

class _ProductImageState extends State<ProductImage> {
  String productImage;
  String productName;
  String shopName;
  String productPrice;
  String productUnit;
  String productCurrency;
  String oldPrice;
  _ProductImageState(this.productImage, this.productName, this.productPrice,
      this.productUnit, this.productCurrency, this.shopName, this.oldPrice);

  @override
  void initState() {
    super.initState();
    getRate();
  }

  @override
  Widget build(BuildContext context) {
    if (productPrice == "") {
      productPrice = '1';
    }
    print(oldPrice + 'is the old price');

    return Container(
        margin: new EdgeInsets.only(left: 4.0, right: 4),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  height: Adaptive.h(22.5),
                  width: Adaptive.h(22.5),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2.2,
                        blurRadius: 2.5,
                        offset: Offset(0, 4),
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
                    width: Adaptive.w(35),
                    placeholder: (context, url) =>
                        Image.asset("assets/images/loading.gif", height: 30),
                    imageUrl: productImage == null ? "s" : productImage,
                    errorWidget: (context, url, error) =>
                        Center(child: new Icon(Icons.error)),
                  ))),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 2),
                child: Text(
                  productName,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Adaptive.sp(10),
                    fontFamily: 'Axiforma',
                    height: 1.2,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildProductPrice(),
                  ],
                ),
              )
            ]));
  }

  int rate;
  dynamic shopinfo;
  bool started = false;
  dynamic cachedshops;

  removeRate() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("cached_shops");
  }

  getRate() async {
    final prefs = await SharedPreferences.getInstance();

    bool skip = false;

    cachedshops = prefs.getString("cached_shops");

    if (cachedshops != null) {
      cachedshops = json.decode(cachedshops);
    } else {
      cachedshops = {};
      skip = true;
    }
    if (!cachedshops.containsKey(shopName)) {
      shopinfo = Firestore.instance
          .collection('shops')
          .where('username', isEqualTo: shopName)
          .getDocuments()
          .then(
        (value) {
          if (value.documents.length > 0) {
            cachedshops[shopName] = value.documents[0].data['rate'];
            prefs.setString('cached_shops', json.encode(cachedshops));
            return rate = value.documents[0].data['rate'];
          } else {
            return null;
          }
        },
      );
    } else {
      rate = json.decode(prefs.getString("cached_shops"))[shopName];
    }
    started = true;
  }

  Widget buildProductPrice() {
    if (productCurrency == "dollar") {
      return Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: FutureBuilder(
            future: getRate(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  else
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: true,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 7.0),
                                child: SizedBox(
                                  height: 20,
                                  child: Text(
                                    (int.parse(oldPrice.toString()) *
                                                (rate != null
                                                    ? int.parse(rate.toString())
                                                    : 1))
                                            .toString() +
                                        "L.L.",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      decorationThickness: 2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.7,
                                      fontFamily: 'Axiforma',
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (productPrice != null)
                              SizedBox(
                                height: 20,
                                child: Text(
                                  (int.parse(productPrice.toString()) *
                                              (rate != null
                                                  ? int.parse(rate.toString())
                                                  : 1))
                                          .toString() +
                                      "L.L.",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 11.7,
                                    fontFamily: 'Axiforma',
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (productUnit != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: SizedBox(
                              height: 20,
                              child: Text(
                                productUnit.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 11.7,
                                  fontFamily: 'Axiforma',
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  break;

                default:
                  return Text('...');
              }
            }),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Visibility(
                visible: oldPrice.length > 0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 7.0),
                  child: SizedBox(
                    height: 20,
                    child: Text(
                      oldPrice.toString() + "L.L.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        decorationThickness: 2,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.7,
                        fontFamily: 'Axiforma',
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Text(
                    productPrice + "L.L.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: Adaptive.sp(9),
                      fontFamily: 'Axiforma',
                      color: Colors.black54,
                    ),
                  )),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 1.0),
              child: SizedBox(
                height: 20,
                child: Text(
                  productUnit.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: Adaptive.sp(9),
                    fontFamily: 'Axiforma',
                    color: Colors.black26,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
