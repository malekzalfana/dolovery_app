import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';
import 'package:hexcolor/hexcolor.dart';

class Bundle extends StatefulWidget {
  // final Widget child;

  final String bundleImage;

  final String bundleName;
  final int bundlePrice;

  final int bundleIndex;
  final String bundleDescription;
  // final String currency;

  Bundle({
    Key key,
    this.bundleImage,
    this.bundleName,
    this.bundlePrice,
    this.bundleIndex,
    this.bundleDescription,
  }) : super(key: key);

  @override
  _BundleState createState() => _BundleState(this.bundleImage, this.bundleName,
      this.bundleIndex, this.bundlePrice, this.bundleDescription);
}

class _BundleState extends State<Bundle> {
  // String Bundle;
  String bundleImage;
  String bundleName;
  int bundleIndex;
  String bundleDescription;
  int bundlePrice;
  // String currency;

  _BundleState(this.bundleImage, this.bundleName, this.bundleIndex,
      this.bundlePrice, this.bundleDescription);
  // _BundleState(this.Bundle);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 50, //16,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, bottom: 20),
        child: Container(
          height: 200,
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
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, left: 0),
                          child: Text(
                            bundleName,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18.0,
                              height: 1.1,
                              fontFamily: 'Axiforma',
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            bundlePrice.toString() + "L.L.",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              fontFamily: 'Axiforma',
                              // color: Hexcolor(
                              //     snapshot.data.documents[0]['buttoncolor']),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 20,
                            child: Text(
                              bundleDescription,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13.0,
                                color: Colors.grey,
                                height: 1.1,
                                fontFamily: 'Axiforma',
                                // color: Hexcolor(
                                //     snapshot.data.documents[0]['buttoncolor']),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    image: DecorationImage(
                      image: NetworkImage(bundleImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: null /* add child content here */,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
