import 'package:dolovery_app/screens/shoppage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dolovery_app/widgets/shopList.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ShopListing extends StatefulWidget {
  final String type;

  const ShopListing({Key key, @required this.type}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

class FormScreenState extends State<ShopListing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(
                      left: 5.0, right: 10.0, top: 15.0, bottom: 10.0),
                  child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.keyboard_arrow_left,
                                color: Colors.black,
                                size: 35.0,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Text(
                            widget.type == 'supplements'
                                ? "Supplements"
                                : widget.type == 'cosmetics'
                                    ? 'Cosmetics'
                                    : 'Lebanese',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0.sp,
                              fontFamily: 'Axiforma',
                              color: Colors.black,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ])),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('shops')
                      .where('type', isEqualTo: widget.type)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data.documents.length == 0) {
                      return Opacity(
                        opacity: 0.3,
                        child: SizedBox(
                            height: 200,
                            child: Center(child: Text('No shops found.'))),
                      );
                    }
                    if (snapshot.hasData) {
                      print(snapshot);
                      return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                              children: List<Widget>.generate(
                                  snapshot.data.documents.length, (int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ShopPage(
                                        snapshot.data.documents[index])));
                              },
                              child: ShopList(
                                  shopName: snapshot.data.documents[index]
                                      ['name'],
                                  shopImage: snapshot.data.documents[index]
                                      ['image'],
                                  shopTime: snapshot
                                      .data.documents[index]['time']
                                      .toString(),
                                  shopAddress: snapshot.data.documents[index]
                                      ['address']),
                            );
                          })));
                    } else if (snapshot.hasError) {
                      return Opacity(
                        opacity: 0.3,
                        child: SizedBox(
                            height: 300,
                            child: Center(child: Text('There was an error.'))),
                      );
                    }
                    return SizedBox(
                      height: 300,
                      child: Center(
                        child: Image.asset(
                          "assets/images/loading.gif",
                          width: 30,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
