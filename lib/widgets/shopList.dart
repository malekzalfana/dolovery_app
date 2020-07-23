import 'package:flutter/material.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';

class ShopList extends StatefulWidget {
  // final Widget child;

  final String shopName;

  final String shopTime;

  final String shopImage;

  ShopList({Key key, this.shopName, this.shopTime, this.shopImage})
      : super(key: key);

  @override
  _ShopListState createState() =>
      _ShopListState(this.shopImage, this.shopName, this.shopTime);
}

class _ShopListState extends State<ShopList> {
  String shopImage;
  String shopName;
  String shopTime;

  _ShopListState(this.shopImage, this.shopName, this.shopTime);
  // _shopImageState(this.shopImage);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0, bottom: 20),
      child: Container(
        height: 260,
        // 180
        width: 180,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              // color: Colors.green,
              margin: new EdgeInsets.only(left: 12.0, right: 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(shopImage),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.07),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 8), // changes position of shadow
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
                  ]),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 14),
                child: Text(
                  shopName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Axiforma',
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 0.0, left: 14),
                child: Text(
                  shopTime + " mins",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    fontFamily: 'Axiforma',
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
