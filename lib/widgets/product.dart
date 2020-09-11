import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductImage extends StatefulWidget {
  // final Widget child;

  final String productName;

  final String productPrice;

  final String productUnit;

  final String productImage;

  ProductImage({
    Key key,
    this.productName,
    this.productImage,
    this.productUnit,
    this.productPrice,
  }) : super(key: key);

  @override
  _ProductImageState createState() => _ProductImageState(
      this.productImage, this.productName, this.productPrice, this.productUnit);
}

class _ProductImageState extends State<ProductImage> {
  String productImage;
  String productName;

  String productPrice;
  String productUnit;

  _ProductImageState(
      this.productImage, this.productName, this.productPrice, this.productUnit);
  // _ProductImageState(this.productImage);
  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.green,
        margin: new EdgeInsets.only(left: 4.0, right: 4),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
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
                  child: Center(
                      child: CachedNetworkImage(
                    placeholder: (context, url) =>
                        Image.asset("assets/images/loading.gif", height: 30),
                    imageUrl: productImage,
                  )

                      // FadeInImage.assetNetwork(
                      //   placeholder: 'assets/images/loading.gif',
                      //   image: productImage,
                      // ),

                      // Image.network(productImage, height: 120, width: 120),
                      )),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 2),
                child: Text(
                  productName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5,
                    fontFamily: 'Axiforma',
                    height: 1.2,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Text(
                        productPrice + "L.L.",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 11.7,
                          fontFamily: 'Axiforma',
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        productUnit,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 11.7,
                          fontFamily: 'Axiforma',
                          color: Colors.black26,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]));
  }
}
