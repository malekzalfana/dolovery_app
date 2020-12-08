import 'package:dolovery_app/widgets/popupproduct.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_svg/svg.dart';
import 'dart:async';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dolovery_app/widgets/product.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:algolia/algolia.dart';

// class Application {
//   static final Algolia algolia = Algolia.init(
//     applicationId: 'OHHGNC99AS',
//     apiKey: 'a6b56f040dea346c56268af333d8c790',
//   );
// }

// void main() async {
//   ///
//   /// Initiate Algolia in your project
//   ///
//   ///
//   ///
//   Algolia algolia = Application.algolia;
//   AlgoliaTask taskAdded,
//       taskUpdated,
//       taskDeleted,
//       taskBatch,
//       taskClearIndex,
//       taskDeleteIndex;
//   AlgoliaObjectSnapshot addedObject;

//   AlgoliaQuery query = algolia.instance.index('products').search('nescafe');
//   print('xxx');
//   print(query);
// }

class Search extends StatefulWidget {
  // final dynamic data;

  Search({Key key}) : super(key: key);
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TabController _controller2;

  @override
  void initState() {
    super.initState();
  }

  List<AlgoliaObjectSnapshot> _results = [];
  bool _searching = false;
  bool tosearch = true;
  TextEditingController _searchText = TextEditingController(text: "");
  @override
  Widget build(BuildContext ctxt) {
    var size = MediaQuery.of(ctxt).size;
    final double itemHeight = (size.height) / 2;
    final double itemWidth = size.width / 2;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    _search() async {
      setState(() {
        _searching = true;
        print('searching');
      });

      Algolia algolia = Algolia.init(
        applicationId: 'OHHGNC99AS',
        apiKey: 'a6b56f040dea346c56268af333d8c790',
      );

      AlgoliaQuery query = algolia.instance.index('products');
      query = query.search(_searchText.text);
      print(_searchText.text);

      _results = (await query.getObjects()).hits;
      print(_results);
      print(' above is the results');

      setState(() {
        _searching = false;
      });
    }

    // main();
    return new Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      height: 90,
                      width: width - 60,
                      decoration: BoxDecoration(
                        // color: Color(0xFFF5F5F7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Row(
                          children: <Widget>[
                            Image.asset("assets/icons/searchicon.png",
                                height: 16),
                            SizedBox(width: 16),
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: SizedBox(
                                width: 200,
                                height: 40,
                                child: Container(
                                    child: TextField(
                                  controller: _searchText,
                                  onChanged: (text) {
                                    if ((text.length > 1) & tosearch) {
                                      _search();
                                      tosearch = false;
                                    }
                                    if (!tosearch) {
                                      Future.delayed(Duration(seconds: 2), () {
                                        tosearch = true;
                                        print('search enabled again');
                                      });
                                    }

                                    // if (timer) {
                                    //   tosearch = true;
                                    // }
                                  },
                                  autofocus: true,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter a search term'),
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    // Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 17.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ),
                    ),
                  ],
                ),
                // FlatButton(
                //   color: Colors.blue,
                //   child: Text(
                //     "S",
                //     style: TextStyle(color: Colors.white),
                //   ),
                //   onPressed: _search,
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: SizedBox(
                    height: height - 70,
                    child: _searching == true
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : _results.length == 0
                            ? Center(
                                child: Image.asset(
                                  "assets/images/searchback.png",
                                ),
                              )
                            : ListView.builder(
                                itemCount: _results.length,
                                itemBuilder: (BuildContext ctx, int index) {
                                  AlgoliaObjectSnapshot snap = _results[index];

                                  return GridView.count(
                                    crossAxisCount: _results.length,
                                    childAspectRatio: .635,
                                    controller: new ScrollController(
                                        keepScrollOffset: false),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    children:
                                        List.generate(_results.length, (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          openProductPopUp(
                                              context, snap.data, index);
                                        },
                                        child: Text(snap.data['name']),
                                        // ProductImage(
                                        //   productName: snap.data['name'],
                                        //   productImage: snap.data['image'],
                                        //   productPrice: snap
                                        //       .data['shop_price']
                                        //       .toString(),
                                        //   productUnit:
                                        //       snap.data['unit'] != null
                                        //           ? snap.data['unit']
                                        //           : '',
                                        // )
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
