import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dolovery_app/widgets/product.dart';
import 'package:intl/intl.dart';
import 'package:flutter_counter/flutter_counter.dart';
// import 'package:dolovery_app/widgets/counter.dart';


class SalleItem extends StatefulWidget {
  final dynamic data; //if you have multiple values add here
  final String day;
  final List descriptions;
  final List prices;
  SalleItem(this.data, this.day, this.prices, this.descriptions, {Key key})
      : super(key: key); //add also..example this.abc,this...

  @override
  State<StatefulWidget> createState() => _SalleItemState();
}

class _SalleItemState extends State<SalleItem> {
  int _n = 1;
  bool minimum = true;
  bool maximum = false;
  // int serving = 0;
  
void add() {
      // print ( _n );
      setState(() {
        if (_n < 10) 
        _n++;
        if (_n == 10){
        maximum = true;
        
        }
        else{
          minimum = false;
          maximum = false;
          }
        print (_n);
      });
    }

    void minus() {
      print ( _n );
      setState(() {
        if (_n != 1) 
          _n--;
          if (_n == 1)
            minimum = true;
            else
            {
            minimum = false;
            maximum = false;
            }
      });
    }

  @override
  Widget build(BuildContext context) {
    // final double itemHeight = (size.height) / 2;
    // final double itemWidth = size.width / 2;
    // new Date(widget.data.documents[0]['salle_date'].seconds * 1000 + widget.data.documents[0]['salle_date'].nanoseconds/1000000)
    // var date = DateTime.fromMicrosecondsSinceEpoch(
    // widget.data.documents[0]['salle_date']);
    

    


    var timestamp =
        (widget.data.documents[0]['salle_date'] as Timestamp).toDate();
        num _defaultValue = 0;
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
            child: Image.network(widget.data.documents[0]['image'], width: 330),
            // Hero(
            //   tag: 'salle' + widget.data.documents[0].documentID,
            //   child:
            //       Image.network(widget.data.documents[0]['image'], width: 330),
            // ),
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
            padding: const EdgeInsets.only(left: 30.0, top: 00, bottom: 00),
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
                widget.descriptions[_n].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 13.0,
                  fontFamily: 'Axiforma',
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 30, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Number of servings",
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
            padding: const EdgeInsets.only(left: 22,top: 20.0),
            child: Container(
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            RawMaterialButton(
              onPressed: minus,
              elevation: !minimum ? 2 : 0,
              fillColor: !minimum ? Colors.redAccent[700] : Colors.grey[200],
              child: Icon(
                Icons.remove, size: 18, color: !minimum ? Colors.white : Colors.grey[800],
              ),
              padding: EdgeInsets.all(0.0),
              shape: CircleBorder(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20,0,20,0),
              child: new Text('$_n' + ' Servings',
                  style: new TextStyle(fontSize:  20.0)),
            ),
            RawMaterialButton(
              onPressed: add,
              elevation: !maximum ? 2 : 0,
              fillColor: !maximum ? Colors.redAccent[700] : Colors.grey[200],
              child: Icon(
                Icons.add, size: 18, color: !maximum ? Colors.white : Colors.grey[800],
              ),
              padding: EdgeInsets.all(0.0),
              shape: CircleBorder(),
            ),


          ],
      ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 30, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Total",
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
                widget.prices[_n].toString() + 'L.L.',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 25.0,
                    fontFamily: 'Axiforma',
                    color: Colors.redAccent[700]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 0,
                        onPressed: (){},
                        color: Colors.redAccent[700],
                        // disabledColor: Colors.grey[200],
                        textColor: Colors.white,
                        minWidth: MediaQuery.of(context).size.width,
                        height: 0,
                        // padding: EdgeInsets.zero,
                        padding: EdgeInsets.only(
                            left: 23, top: 10, right: 23, bottom: 10),
                        child: Text(
                          "Confirm Order",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            fontFamily: 'Axiforma',
                            // color: Colors.white,
                          ),
                        ),
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Row(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right:18.0),
                child: Icon(
                    Icons.info, size: 18, color: Colors.grey[500],
                  ),
              ),
                Expanded(
                                    child: Text(
                            "All meal baskets come with a detailed cooking instructions!",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12.0,
                              fontFamily: 'Axiforma',
                              color: Colors.grey[500],
                            ),
                          ),
                ),
            ],),
          )
        ],
      )),
    );
  }
}
