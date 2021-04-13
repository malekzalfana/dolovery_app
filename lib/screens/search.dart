import 'package:dolovery_app/widgets/product_popup.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dolovery_app/widgets/product.dart';
import 'package:algolia/algolia.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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

  bool searchlock = false;
  int counter = 0;
  TextEditingController _searchText = TextEditingController(text: "");
  @override
  Widget build(BuildContext ctxt) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    String pendingSearch = '';
    Algolia algolia = Algolia.init(
      applicationId: 'OHHGNC99AS',
      apiKey: 'a6b56f040dea346c56268af333d8c790',
    );

    _search() async {
      counter++;
      AlgoliaQuery query = algolia.instance.index('products');
      query = query.search(_searchText.text);

      _results = null;
      _results = (await query.getObjects()).hits;

      setState(() {
        searchlock = true;
        print('searching for ${_searchText.text}');
        pendingSearch = '';
      });
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                      padding:  EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image.asset("assets/icons/searchicon.png",
                              height: 16),
                          SizedBox(width: 16),
                          Padding(
                            padding:  EdgeInsets.only(top: 5.0),
                            child: SizedBox(
                              width: Adaptive.w(65),
                              child: Container(
                                  child: TextField(

                                controller: _searchText,
                                onSubmitted: (text) {
                                  if ((text.length > 2) & !searchlock) {
                                    _search();


                                    if (searchlock = true) {
                                      Future.delayed(Duration(seconds: 3),
                                          () {
                                        setState(() {
                                          searchlock = false;
                                        });
                                        if (pendingSearch != "" &&
                                            text.length > 2) {
                                          _search();
                                        }
                                      });
                                    }
                                  } else if ((text.length > 2) &&
                                      searchlock) {
                                    pendingSearch = text;
                                  } else if (text.length == 0) {
                                    _results = null;
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
                    padding: EdgeInsets.only(top: 5.0),
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
                ],
              ),
              // Text(searchlock.toString()),
              // Text(counter.toString()),
              // if (_results != null)
              //   Text('results count is' + _results.length.toString()),
              if (_results != null)
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: SizedBox(
                    height: height - 200,
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
                            : GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: Adaptive.w(50),
                        crossAxisSpacing: Adaptive.w(5),
                        mainAxisExtent: Adaptive.h(35),
                      ),
                                itemCount: _results.length,
                                itemBuilder: (BuildContext ctx, int index) {
                                  AlgoliaObjectSnapshot snap =
                                      _results[index];
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
                                                ? snap.data['data']
                                                        ['old_price']
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
                                                ? snap.data['data']
                                                    ['currency']
                                                : '',
                                            shopName: snap.data['data']
                                                    ['shop']
                                                .toString(),
                                          ));
                                },
                              ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
