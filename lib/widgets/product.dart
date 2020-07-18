import 'package:flutter/material.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';

class ProductImage extends StatefulWidget {
  // final Widget child;

  final String productName;

  final String productPrice;

  final String productImage;

  ProductImage(
      {Key key, this.productName, this.productPrice, this.productImage})
      : super(key: key);

  @override
  _ProductImageState createState() => _ProductImageState(
      this.productImage, this.productName, this.productPrice);
}

class _ProductImageState extends State<ProductImage> {
  String productImage;
  String productName;
  String productPrice;

  _ProductImageState(this.productImage, this.productName, this.productPrice);
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
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  child: Center(
                    child: Image.network(productImage, height: 120, width: 120),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  productName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                    fontFamily: 'Axiforma',
                    color: Colors.black,
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
                    fontSize: 12,
                    fontFamily: 'Axiforma',
                    color: Colors.black54,
                  ),
                ),
              ),
            ]));
  }
}
