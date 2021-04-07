import 'package:dolovery_app/widgets/popupproduct.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';

import 'package:dolovery_app/widgets/product.dart';
import 'package:algolia/algolia.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
                                              context,
                                              snap.data['data'],
                                              index,
                                            );
                                          },
                                          child: ProductImage(
                                            productName: snap.data['data']
                                                        ['name'] !=
                                                    null
                                                ? snap.data['data']['name']
                                                : '',
                                            productImage: snap.data['data']
                                                        ['image'] !=
                                                    null
                                                ? snap.data['data']['image']
                                                : '',
                                            productPrice: snap.data['data']
                                                        ['shop_price'] !=
                                                    null
                                                ? snap.data['data']
                                                        ['shop_price']
                                                    .toString()
                                                : '0',
                                            oldPrice: snap.data['data']
                                                        ['old_price'] !=
                                                    null
                                                ? snap.data['data']['old_price']
                                                    .toString()
                                                : '',
                                            productUnit: snap.data['data']
                                                        ['unit'] !=
                                                    null
                                                ? snap.data['data']['unit']
                                                : '',
                                            productCurrency: snap.data['data']
                                                        ['currency'] !=
                                                    null
                                                ? snap.data['data']['currency']
                                                : '',
                                            shopName: snap.data['data']['shop']
                                                .toString(),
                                          ));
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
