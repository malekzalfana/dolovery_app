import 'package:cached_network_image/cached_network_image.dart';
import 'package:dolovery_app/widgets/product_popup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:dolovery_app/widgets/product.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ShopPage extends StatefulWidget {
  final dynamic data;

  ShopPage(this.data, {Key key}) : super(key: key);
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();
  }

  String chosenCategory = '';
  String chosenSubcategory = '';
  setSubCategory(subcat) {
    if (chosenSubcategory == subcat) {
      setState(() {
        chosenSubcategory = '';
      });
    } else {
      cancelSubCategory();
      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          chosenSubcategory = subcat;
          hideeverything = false;
        });
      });
    }
    return chosenSubcategory;
  }

  bool hideeverything = false;
  cancelCategory() {
    setState(() {
      chosenCategory = '';
      chosenSubcategory = '';
      hideeverything = true;
    });
  }

  cancelSubCategory() {
    setState(() {
      chosenSubcategory = '';
      hideeverything = true;
    });
  }

  setCategory(cat) {
    print('$chosenCategory is the chosen shub and new one is $cat');

    if (chosenCategory == cat) {
      print('not change');
      setState(() {
        chosenCategory = '';
        chosenSubcategory = '';
      });
    } else {
      print('changed');
      cancelCategory();
      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          chosenCategory = cat;
          chosenSubcategory = '';
          hideeverything = false;
        });
      });
    }

    return chosenCategory;
  }

  dynamic type;
  Future getcategories() async {
    String shoptype = widget.data['type'];
    type = await Firestore.instance
        .collection("types")
        .document(shoptype.toLowerCase())
        .get();

    print(
        "loaded and chosen cat is $chosenCategory and sub $chosenSubcategory");
    return chosenCategory;
  }

  bool shophaslocation = false;
  LatLng _shopCoordinates;

  @override
  Widget build(BuildContext ctxt) {
    Set<Marker> markers = Set();
    if (widget.data['location'] != null) {
      double lat = widget.data['location'].latitude;
      double lng = widget.data['location'].longitude;

      _shopCoordinates = new LatLng(lat, lng);
      markers.addAll([
        Marker(markerId: MarkerId('value'), position: LatLng(lat, lng)),
      ]);
      shophaslocation = true;
    }

    double width = MediaQuery.of(context).size.width;
    return new Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: Align(
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
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 0.0, top: 0.0, bottom: 10.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin:
                                  new EdgeInsets.only(left: 12.0, right: 10),
                              child: Container(
                                height: Adaptive.h(10),
                                width: Adaptive.h(10),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2.2,
                                      blurRadius: 2.5,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: widget.data['image'],
                                  placeholder: (context, url) =>
                                      new CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            widget.data['name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: Adaptive.sp(14),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.timer,
                                            color: Colors.grey[500],
                                            size: 18.0,
                                            semanticLabel:
                                                'time for shop to deliver',
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                widget.data['time'].toString() +
                                                    " mins",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  height: 1.1,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: Adaptive.sp(8),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: Icon(
                                              Icons.location_on,
                                              color: Colors.grey[500],
                                              size: 16.0,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                widget.data['address'],
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  height: 1.1,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: Adaptive.sp(8),
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
                      ),
                      if (shophaslocation)
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Row(
                            children: [
                              IgnorePointer(
                                child: SizedBox(
                                  width: width,
                                  height: 180,
                                  child: GoogleMap(
                                    onMapCreated: _onMapCreated,
                                    myLocationButtonEnabled: false,
                                    mapToolbarEnabled: false,
                                    zoomControlsEnabled: false,
                                    markers: markers,
                                    initialCameraPosition: CameraPosition(
                                      target: _shopCoordinates,
                                      zoom: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      FutureBuilder(
                        future: getcategories(),
                        builder: (context, snapshot) {
                          var first = 0;
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Padding(
                                padding: const EdgeInsets.only(top: 45.0),
                                child: Center(
                                  child: Image.asset(
                                    "assets/images/loading.gif",
                                    width: 30,
                                  ),
                                ),
                              );
                            default:
                              if (snapshot.hasError)
                                return Text('Error: ${snapshot.error}');
                              else if (type != null &&
                                  snapshot.connectionState ==
                                      ConnectionState
                                          .done) if (snapshot.data.length == 0)
                                return SizedBox(height: 30);
                              else
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15.0, left: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Categories',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                  fontFamily: 'Axiforma',
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: type['categories']
                                                      .keys
                                                      .map<Widget>((entry) {
                                                    first++;
                                                    if (widget.data[
                                                            'categories'] !=
                                                        null)
                                                      return Visibility(
                                                        visible: widget
                                                            .data['categories']
                                                            .contains(entry),
                                                        child: Padding(
                                                          padding: first == 1
                                                              ? const EdgeInsets
                                                                      .only(
                                                                  left: 10)
                                                              : const EdgeInsets
                                                                      .only(
                                                                  left: 0),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 10.0,
                                                                    bottom: 20,
                                                                    top: 20),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                setCategory(
                                                                    entry);
                                                                setState(() {});
                                                              },
                                                              child: Container(
                                                                  height: 80,
                                                                  width: 120,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: entry ==
                                                                            chosenCategory
                                                                        ? Colors.redAccent[
                                                                            700]
                                                                        : Colors
                                                                            .white,
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                15),
                                                                        topRight:
                                                                            Radius.circular(
                                                                                15),
                                                                        bottomLeft:
                                                                            Radius.circular(
                                                                                15),
                                                                        bottomRight:
                                                                            Radius.circular(15)),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.1),
                                                                        spreadRadius:
                                                                            2.2,
                                                                        blurRadius:
                                                                            2.5,
                                                                        offset: Offset(
                                                                            0,
                                                                            4),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: <
                                                                        Widget>[
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Text(
                                                                          entry,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w800,
                                                                            fontSize:
                                                                                12.5,
                                                                            height:
                                                                                1.3,
                                                                            fontFamily:
                                                                                'Axiforma',
                                                                            color: entry == chosenCategory
                                                                                ? Colors.white
                                                                                : Colors.black,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                  }).toList()),
                                            ],
                                          ),
                                        ),
                                      )),
                                );
                          }
                          return null;
                        },
                      ),
                      FutureBuilder(
                        future: getcategories(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Padding(
                                padding: const EdgeInsets.only(top: 45.0),
                                child: Center(
                                  child: Container(),
                                ),
                              );
                            default:
                              if (snapshot.hasError)
                                return Text('Error: ${snapshot.error}');
                              else if (type != null &&
                                  snapshot.connectionState ==
                                      ConnectionState.done)
                                return Column(
                                  children: [
                                    Column(
                                        children: type['categories']
                                            .keys
                                            .map<Widget>((entry) {
                                      if (!widget.data['categories']
                                          .contains(entry))
                                        return Container(
                                          child: null,
                                        );
                                      else
                                        return Align(
                                          alignment: Alignment.centerLeft,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Row(
                                                  children:
                                                      List<Widget>.generate(
                                                          type['categories']
                                                                  [entry]
                                                              .length,
                                                          (int index) {
                                                return Visibility(
                                                  visible: entry ==
                                                              chosenCategory &&
                                                          widget.data[
                                                                  'subcategories']
                                                              .contains(type[
                                                                      'categories']
                                                                  [
                                                                  entry][index])
                                                      ? true
                                                      : false,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 0.0,
                                                            bottom: 10,
                                                            top: 0,
                                                            left: 0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setSubCategory(
                                                            type['categories']
                                                                [entry][index]);
                                                      },
                                                      child: Container(
                                                          height: 50,
                                                          width: 110,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Text(
                                                                  type['categories']
                                                                          [
                                                                          entry]
                                                                      [index],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    fontSize:
                                                                        12.0,
                                                                    height: 1.3,
                                                                    fontFamily:
                                                                        'Axiforma',
                                                                    color: type['categories'][entry][index] ==
                                                                            chosenSubcategory
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .grey,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                  ),
                                                );
                                              })),
                                            ),
                                          ),
                                        );
                                    }).toList()),
                                    Visibility(
                                      visible: hideeverything,
                                      child: SizedBox(
                                        height: 200,
                                        child: Center(
                                            child: Image.asset(
                                                "assets/images/loading.gif",
                                                height: 30)),
                                      ),
                                    ),
                                    Visibility(
                                      visible: !hideeverything &&
                                              chosenCategory != '' &&
                                              chosenSubcategory != ''
                                          ? true
                                          : false,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0,
                                              right: 5,
                                              top: 0,
                                              bottom: 0),
                                          child: StreamBuilder(
                                            stream: Firestore.instance
                                                .collection('products')
                                                .where('shop',
                                                    isEqualTo:
                                                        widget.data['username'])
                                                .where('category',
                                                    isEqualTo: chosenCategory)
                                                .where('subcategory',
                                                    isEqualTo:
                                                        chosenSubcategory)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                if (snapshot
                                                        .data.documents.length <
                                                    2) {
                                                  return Opacity(
                                                    opacity: 0.3,
                                                    child: SizedBox(
                                                        height: 200,
                                                        child: Center(
                                                            child: Text(
                                                                'No items found.'))),
                                                  );
                                                }
                                                return GridView.count(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 0.65,
                                                  controller:
                                                      new ScrollController(
                                                          keepScrollOffset:
                                                              false),
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  children: List.generate(
                                                      snapshot.data.documents
                                                          .length, (index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        openProductPopUp(
                                                            context,
                                                            snapshot.data,
                                                            index);
                                                      },
                                                      child: ProductImage(
                                                          productName: snapshot
                                                                  .data
                                                                  .documents[index]
                                                              ['name'],
                                                          productImage: snapshot
                                                                  .data
                                                                  .documents[index]
                                                              ['image'],
                                                          productPrice: snapshot
                                                              .data
                                                              .documents[index]
                                                                  ['shop_price']
                                                              .toString(),
                                                          shopName: snapshot.data.documents[index]
                                                              ['shop'],
                                                          productUnit: snapshot.data.documents[index]['unit'] != null
                                                              ? snapshot.data.documents[index]['unit']
                                                              : '',
                                                          oldPrice: snapshot.data.documents[index]['old_price'] == null ? "0" : snapshot.data.documents[index]['old_price'].toString(),
                                                          productCurrency: snapshot.data.documents[index]['currency'] != null ? snapshot.data.documents[index]['currency'] : "lebanese"),
                                                    );
                                                  }).toList(),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    snapshot.error.toString());
                                              }
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            },
                                          )),
                                    ),
                                    Visibility(
                                      visible: !hideeverything &&
                                              chosenCategory != '' &&
                                              chosenSubcategory == ''
                                          ? true
                                          : false,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0,
                                              right: 5,
                                              top: 0,
                                              bottom: 0),
                                          child: StreamBuilder(
                                            stream: Firestore.instance
                                                .collection('products')
                                                .where('shop',
                                                    isEqualTo:
                                                        widget.data['username'])
                                                .where('category',
                                                    isEqualTo: chosenCategory)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return GridView.count(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 0.65,
                                                  controller:
                                                      new ScrollController(
                                                          keepScrollOffset:
                                                              false),
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  children: List.generate(
                                                      snapshot.data.documents
                                                          .length, (index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        openProductPopUp(
                                                            context,
                                                            snapshot.data,
                                                            index);
                                                      },
                                                      child: ProductImage(
                                                          oldPrice: snapshot.data.documents[index]['old_price'] == null
                                                              ? "0"
                                                              : snapshot.data.documents[index]['old_price']
                                                                  .toString(),
                                                          productName: snapshot
                                                                  .data
                                                                  .documents[index]
                                                              ['name'],
                                                          productImage:
                                                              snapshot.data.documents[index]
                                                                  ['image'],
                                                          productPrice: snapshot
                                                              .data
                                                              .documents[index]
                                                                  ['shop_price']
                                                              .toString(),
                                                          shopName: snapshot
                                                              .data
                                                              .documents[index]['shop'],
                                                          productUnit: snapshot.data.documents[index]['unit'] != null ? snapshot.data.documents[index]['unit'] : '',
                                                          productCurrency: snapshot.data.documents[index]['currency'] != null ? snapshot.data.documents[index]['currency'] : "lebanese"),
                                                    );
                                                  }).toList(),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    snapshot.error.toString());
                                              } else if (!snapshot.hasData) {
                                                return Opacity(
                                                  opacity: 0.3,
                                                  child: SizedBox(
                                                      height: 200,
                                                      child: Center(
                                                          child: Text(
                                                              'No items found.'))),
                                                );
                                              }
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            },
                                          )),
                                    ),
                                    Visibility(
                                      visible: !hideeverything &&
                                              chosenCategory == '' &&
                                              chosenSubcategory == ''
                                          ? true
                                          : false,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0,
                                              right: 5,
                                              top: 0,
                                              bottom: 0),
                                          child: StreamBuilder(
                                            stream: Firestore.instance
                                                .collection('products')
                                                .where('shop',
                                                    isEqualTo:
                                                        widget.data['username'])
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.data.documents
                                                          .length <
                                                      1) {
                                                return Opacity(
                                                  opacity: 0.3,
                                                  child: SizedBox(
                                                      height: 200,
                                                      child: Center(
                                                          child: Text(
                                                              'No items found.'))),
                                                );
                                              }
                                              if (snapshot.hasData) {
                                                return GridView.count(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 0.65,
                                                  controller:
                                                      new ScrollController(
                                                          keepScrollOffset:
                                                              false),
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  children: List.generate(
                                                      snapshot.data.documents
                                                          .length, (index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        openProductPopUp(
                                                            context,
                                                            snapshot.data
                                                                    .documents[
                                                                index],
                                                            index);
                                                      },
                                                      child: ProductImage(
                                                          oldPrice: snapshot.data.documents[index]['old_price'] == null
                                                              ? "0"
                                                              : snapshot.data.documents[index]['old_price']
                                                                  .toString(),
                                                          productName: snapshot.data.documents[index]['name'] != null
                                                              ? snapshot.data
                                                                      .documents[index]
                                                                  ['name']
                                                              : '[NO NAME]',
                                                          productImage: snapshot
                                                                  .data
                                                                  .documents[index]
                                                              ['image'],
                                                          productPrice: snapshot.data.documents[index]['shop_price'].toString() != null
                                                              ? snapshot
                                                                  .data
                                                                  .documents[index]
                                                                      ['shop_price']
                                                                  .toString()
                                                              : '[NO PRICE]',
                                                          shopName: snapshot.data.documents[index]['shop'],
                                                          productUnit: snapshot.data.documents[index]['unit'] != null ? snapshot.data.documents[index]['unit'] : '',
                                                          productCurrency: snapshot.data.documents[index]['currency'] != null ? snapshot.data.documents[index]['currency'] : "lebanese"),
                                                    );
                                                  }).toList(),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    snapshot.error.toString());
                                              }
                                              return Center(
                                                  child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 45.0),
                                                child: Center(
                                                  child: Image.asset(
                                                    "assets/images/loading.gif",
                                                    width: 30,
                                                  ),
                                                ),
                                              ));
                                            },
                                          )),
                                    ),
                                  ],
                                );
                          }
                          return null;
                        },
                      ),
                    ],
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
