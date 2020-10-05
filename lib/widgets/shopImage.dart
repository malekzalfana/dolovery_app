import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';

class ShopImage extends StatefulWidget {
  // final Widget child;

  final String shopName;

  final String shopTime;

  final String shopImage;
  final int shopIndex;
  final String currency;

  ShopImage(
      {Key key,
      this.shopName,
      this.shopTime,
      this.shopImage,
      this.shopIndex,
      this.currency})
      : super(key: key);

  @override
  _ShopImageState createState() => _ShopImageState(this.shopImage,
      this.shopName, this.shopTime, this.shopIndex, this.currency);
}

class _ShopImageState extends State<ShopImage> {
  String shopImage;
  String shopName;
  String shopTime;
  int shopIndex;
  String currency;

  _ShopImageState(this.shopImage, this.shopName, this.shopTime, this.shopIndex,
      this.currency);
  // _shopImageState(this.shopImage);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0, bottom: 20),
      child: SizedBox(
        width: 200,
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
                          // image: DecorationImage(
                          //   image: NetworkImage(shopImage),
                          //   fit: BoxFit.cover,
                          // ),
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
                        child: Center(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Image.asset(
                                "assets/images/loading.gif",
                                height: 30),
                            imageUrl: shopImage,
                            errorWidget: (context, url, error) =>
                                Center(child: new Icon(Icons.error)),
                          ),
                        )),
                  ]),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 13.0, left: 14, bottom: 6),
                child: Text(
                  shopName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    height: 1.1,
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
                  shopTime,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 13.7,
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
