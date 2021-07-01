import 'package:cached_network_image/cached_network_image.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ShopList extends StatefulWidget {
  // final Widget child;

  final String shopName;

  final String shopTime;

  final String shopImage;

  final String shopAddress;

  ShopList({Key key, this.shopName, this.shopTime, this.shopImage, this.shopAddress}) : super(key: key);

  @override
  _ShopListState createState() =>
      _ShopListState(this.shopImage, this.shopName, this.shopTime, this.shopAddress);
}

class _ShopListState extends State<ShopList> {
  String shopImage;
  String shopName;
  String shopTime;
  String shopAddress;

  _ShopListState(this.shopImage, this.shopName, this.shopTime, this.shopAddress);
  // _shopImageState(this.shopImage);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 22;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            // color: Colors.green,
            margin: new EdgeInsets.only(left: 12.0, right: 10),
            child: Container(
                height: Adaptive.h(15),
                width: Adaptive.h(15),
                decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     image: NetworkImage(shopImage),
                  //     fit: BoxFit.cover,
                  //   ),
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
                    placeholder: (context, url) => Image.asset("assets/images/loading.gif", height: 30),
                    imageUrl: shopImage,
                    errorWidget: (context, url, error) =>
                        Center(child: new Icon(Icons.error, size: Adaptive.h(5))),
                  ),
                )),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          shopName,
                          // textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Adaptive.sp(12),
                            height: 1.1,
                            fontFamily: 'Axiforma',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.timer,
                          color: Colors.grey[500],
                          size: Adaptive.h(2),
                          semanticLabel: 'time for shop to deliver',
                        ),
                        if (shopTime != null)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                shopTime,
                                // overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  height: 1.1,
                                  fontWeight: FontWeight.normal,
                                  fontSize: Adaptive.sp(9),
                                  fontFamily: 'Axiforma',
                                  color: Colors.grey[500],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.grey[500],
                            size: Adaptive.h(2),
                          ),
                        ),
                        if (shopAddress != null)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                shopAddress,
                                // overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  height: 1.1,
                                  fontWeight: FontWeight.normal,
                                  fontSize: Adaptive.sp(9),
                                  fontFamily: 'Axiforma',
                                  color: Colors.grey[500],
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
          )
        ],
      ),
    );
  }
}
