import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dolovery_app/widgets/product.dart';
import 'package:intl/intl.dart';

class SalleItem extends StatefulWidget {
  final dynamic data; //if you have multiple values add here
  final String day;
  SalleItem(this.data, this.day, {Key key})
      : super(key: key); //add also..example this.abc,this...

  @override
  State<StatefulWidget> createState() => _SalleItemState();
}

class _SalleItemState extends State<SalleItem> {
  @override
  Widget build(BuildContext context) {
    // final double itemHeight = (size.height) / 2;
    // final double itemWidth = size.width / 2;
    // new Date(widget.data.documents[0]['salle_date'].seconds * 1000 + widget.data.documents[0]['salle_date'].nanoseconds/1000000)
    // var date = DateTime.fromMicrosecondsSinceEpoch(
    // widget.data.documents[0]['salle_date']);

    var timestamp =
        (widget.data.documents[0]['salle_date'] as Timestamp).toDate();
    String formatted_date = DateFormat.yMMMMd().format(timestamp);
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
            title: Text(
              'Basket Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16.0,
                fontFamily: 'Axiforma',
                color: Colors.black,
              ),
            ),
          ),
          Text(
            widget.day,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 32.0,
                color: Colors.black),
          ),
          Text(
            formatted_date,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
                fontFamily: 'Axiforma',
                color: Colors.black45),
          ),
          Container(
            child: Hero(
              tag: 'salle' + widget.data.documents[0].documentID,
              child:
                  Image.network(widget.data.documents[0]['image'], width: 330),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 30, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recipe",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                  fontFamily: 'Axiforma',
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 00, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.data.documents[0]['name'],
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 25.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 10, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Preparation Time",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                  fontFamily: 'Axiforma',
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 00, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.data.documents[0]['salle_time'].toString() + "mins",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 10, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Number of Items",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                  fontFamily: 'Axiforma',
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 00, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.data.documents[0]['items'].toString() + " Items",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 30, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Description",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                  fontFamily: 'Axiforma',
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 30.0, right: 30.0, top: 0, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.data.documents[0]['description'],
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 13.0,
                  fontFamily: 'Axiforma',
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
