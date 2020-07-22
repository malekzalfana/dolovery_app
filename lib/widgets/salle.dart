import 'package:flutter/material.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';

class SalleImage extends StatefulWidget {
  // final Widget child;

  final String sallePhoto;
  final String salleName;
  final String salleArabicName;
  final String salleTime;
  final String salleItems;
  final String salleStartingPrice;

  SalleImage(
      {Key key,
      this.sallePhoto,
      this.salleName,
      this.salleArabicName,
      this.salleItems,
      this.salleStartingPrice,
      this.salleTime})
      : super(key: key);

  @override
  _SalleImageState createState() => _SalleImageState(
      this.sallePhoto,
      this.salleName,
      this.salleArabicName,
      this.salleItems,
      this.salleStartingPrice,
      this.salleTime);
}

class _SalleImageState extends State<SalleImage> {
  String sallePhoto;
  String salleName;
  String salleArabicName;
  String salleTime;
  String salleItems;
  String salleStartingPrice;

  _SalleImageState(this.sallePhoto, this.salleName, this.salleArabicName,
      this.salleItems, this.salleStartingPrice, this.salleTime);
  // _SalleImageState(this.salleImage);
  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.green,
        margin: new EdgeInsets.only(left: 4.0, right: 4, bottom: 7),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 135,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.07),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 8), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            salleTime + " mins",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 13.0,
                              fontFamily: 'Axiforma',
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 7.0, left: 5, right: 5),
                            child: Container(
                              height: 3,
                              width: 3,
                              margin: EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey, shape: BoxShape.circle),
                            ),
                          ),
                          Text(
                            salleItems.toString() + " items",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 13.0,
                              fontFamily: 'Axiforma',
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        salleName,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18.0,
                          fontFamily: 'Axiforma',
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        salleArabicName,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          height: 0.9,
                          fontFamily: 'Axiforma',
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Starting from " + salleStartingPrice,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                          height: 1.9,
                          fontFamily: 'Axiforma',
                          color: Colors.redAccent[700],
                        ),
                      ),
                    ],
                  ),
                ),
                Hero(
                  tag: 'salle',
                  child: Image.network(sallePhoto, height: 120, width: 120),
                )
              ],
            ),
          ),
        ));
  }
}
