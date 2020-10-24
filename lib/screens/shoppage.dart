import 'package:dolovery_app/widgets/popupproduct.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_svg/svg.dart';
import 'dart:async';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dolovery_app/widgets/product.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShopPage extends StatefulWidget {
  final dynamic data;

  ShopPage(this.data, {Key key}) : super(key: key);
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  Completer<GoogleMapController> _controller = Completer();

  TabController _controller2;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();
  }

  String chosen_category = '';
  String chosen_subcategory = '';
  setSubCategory(subcat) {
    // print("asdasd");

    if (chosen_subcategory == subcat) {
      setState(() {
        chosen_subcategory = '';
      });
    } else {
      cancelSubCategory();
      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          chosen_subcategory = subcat;
          hideeverything = false;
        });
      });
    }
    return chosen_subcategory;

    // print(subcat);
  }

  bool hideeverything = false;
  cancelCategory() {
    setState(() {
      chosen_category = '';
      chosen_subcategory = '';
      hideeverything = true;
    });
  }

  cancelSubCategory() {
    setState(() {
      chosen_subcategory = '';
      hideeverything = true;
    });
  }

  setCategory(cat) {
    // print("asdasd");

    print('$chosen_category is the chosen shub and new one is $cat');
    // setState(() {
    //   chosen_subcategory = '';
    // });
    if (chosen_category == cat) {
      print('not change');
      setState(() {
        chosen_category = '';
        chosen_subcategory = '';
      });
    } else {
      print('changed');
      cancelCategory();
      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          chosen_category = cat;
          chosen_subcategory = '';
          hideeverything = false;
        });
      });
    }

    return chosen_category;
    // print("$chosen_category and ubb is $chosen_subcategory");
    // print(subcat);
  }

  dynamic type;
  Future getcategories() async {
    // print("USER BEING WATCHED");
    String shoptype = widget.data['type'];
    type = await Firestore.instance
        .collection("types")
        .document(shoptype.toLowerCase())
        .get();
    if (type != null) {
      type.data['categories'].forEach((cat, sub) {
        // print("Key : $cat, Value : $sub");
        for (var i = 0; i < sub.length; i++) {
          // print(sub[i]);
        }
      });
    }
    print(
        "loaded and chosen cat is $chosen_category and sub $chosen_subcategory");
    return chosen_category;
  }

  @override
  Widget build(BuildContext ctxt) {
    // getcategories();
    // GeoPoint shoplocation;
    // GeoPoint geoPoint = widget.data['location'].getGeoPoint("position");
    // print (widget.data['location']);
    double lat = widget.data['location'].latitude;
    double lng = widget.data['location'].longitude;
    Set<Marker> markers = Set();
    LatLng _center = new LatLng(lat, lng);
    markers.addAll([
      Marker(markerId: MarkerId('value'), position: LatLng(lat, lng)),
    ]);
    // const LatLng _center = const LatLng(45.521563, -122.677433);
    var size = MediaQuery.of(ctxt).size;
    final double itemHeight = (size.height) / 2;
    final double itemWidth = size.width / 2;
    double width = MediaQuery.of(context).size.width;
    // Firestore.instance.collection("types").document(widget.data['type']).get()
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
                        // widget.notifyParent();
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
                Visibility(
                  visible: false,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 17.0, right: 0.0, top: 10.0, bottom: 0.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Icon(
                            Icons.near_me,
                            color: Colors.redAccent[700],
                            size: 20.0,
                          ),
                        ),
                        Text(
                          "Delivering to",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            fontFamily: 'Axiforma',
                            color: Colors.redAccent[700],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                          child: MaterialButton(
                            onPressed: () {
                              () {};
                            },
                            color: Colors.redAccent[700],
                            textColor: Colors.white,
                            minWidth: 0,
                            height: 0,
                            // padding: EdgeInsets.zero,
                            padding: EdgeInsets.only(
                                left: 6, top: 0, right: 6, bottom: 1),
                            child: Text(
                              "Badaro",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                fontFamily: 'Axiforma',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: IconButton(
                        //       icon: Icon(
                        //         Icons.clear,
                        //         color: Colors.grey,
                        //         size: 30,
                        //       ),
                        //       onPressed: () {
                        //         Navigator.of(context).pop();
                        //       }),
                        // ),
                      ],
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Align(
                //       alignment: Alignment.centerRight,
                //       child: IconButton(
                //           icon: Icon(
                //             Icons.clear,
                //             color: Colors.grey,
                //             size: 30,
                //           ),
                //           onPressed: () {
                //             Navigator.of(context).pop();
                //           }),
                //     ),
                //   ],
                // ),
                // Text('$chosen_category is cat and sub is $chosen_subcategory'),
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
                              // color: Colors.green,
                              margin:
                                  new EdgeInsets.only(left: 12.0, right: 10),
                              child: Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(widget.data['image']),
                                      fit: BoxFit.cover,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 2.2,
                                        blurRadius: 2.5,
                                        offset: Offset(
                                            0, 4), // changes position of shadow
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                  ),
                                  child: null),
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
                                            // textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
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
                                                // overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  height: 1.1,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 11.5,
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
                                                // overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  height: 1.1,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 11.5,
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
                                    target: _center,
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
                          // print(type.data['categories'].keys[0]);
                          // return Text("dsddd");

                          // for (var cat in type.data['categories'].keys) {
                          //   print('$type was written by ${type[cat]}');
                          // }
                          var first = 0;
                          switch (snapshot.connectionState) {
                            // case ConnectionState.waiting:
                            //   return Container();
                            default:
                              if (snapshot.hasError)
                                return Text('Error: ${snapshot.error}');
                              else if (type != null)
                                return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        children: type['categories']
                                            .keys
                                            .map<Widget>((entry) {
                                      // print("main category");
                                      // print(entry);
                                      // print(type["categories"].keys[1]);
                                      // for (var book in type["categories"].keys) {
                                      //   print(
                                      //       '$book was written by ${type["categories"][book]}');
                                      // }
                                      // print(type['categories'][entry]);

                                      first++;
                                      // print

                                      // var w = Text("ssss");
                                      // type['categories'](entry.key);
                                      // return w;
                                      if (widget.data['categories'] != null)
                                        return Visibility(
                                          visible: widget.data['categories']
                                              .contains(entry),
                                          child: Padding(
                                            padding: first == 1
                                                ? const EdgeInsets.only(
                                                    left: 10)
                                                : const EdgeInsets.only(
                                                    left: 0),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10.0,
                                                  bottom: 20,
                                                  top: 26),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setCategory(entry);
                                                  setState(() {});
                                                },
                                                child: Container(
                                                    height: 80,
                                                    // 180
                                                    width: 120,
                                                    decoration: BoxDecoration(
                                                      // image: DecorationImage(
                                                      //   image: AssetImage(
                                                      //       'assets/images/meat.png'),
                                                      //   fit: BoxFit.cover,
                                                      // ),
                                                      color: entry ==
                                                              chosen_category
                                                          ? Colors
                                                              .redAccent[700]
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(15),
                                                              topRight: Radius
                                                                  .circular(15),
                                                              bottomLeft: Radius
                                                                  .circular(15),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          15)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.1),
                                                          spreadRadius: 2.2,
                                                          blurRadius: 2.5,
                                                          offset: Offset(0,
                                                              4), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: <Widget>[
                                                        // Image.asset(
                                                        //     "assets/images/meaticon.png",
                                                        //     height: 30),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            entry,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 12.5,
                                                              height: 1.3,
                                                              fontFamily:
                                                                  'Axiforma',
                                                              color: entry ==
                                                                      chosen_category
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ),
                                          ),
                                        );
                                    }).toList()));
                          }
                        },
                      ),
                      FutureBuilder(
                        future: getcategories(),
                        builder: (context, snapshot) {
                          // print(type.data['categories'].keys[0]);
                          // return Text("dsddd");

                          // for (var cat in type.data['categories'].keys) {
                          //   print('$type was written by ${type[cat]}');
                          // }
                          switch (snapshot.connectionState) {
                            // case ConnectionState.waiting:
                            //   return Padding(
                            //     padding: const EdgeInsets.only(top: 45.0),
                            //     child: Center(
                            //       child: Image.asset(
                            //         "assets/images/loading.gif",
                            //         width: 30,
                            //       ),
                            //     ),
                            //   );
                            default:
                              if (snapshot.hasError)
                                return Text('Error: ${snapshot.error}');
                              else if (type != null)
                                return Column(
                                  children: [
                                    Column(
                                        children: type['categories']
                                            .keys
                                            .map<Widget>((entry) {
                                      // print("key");
                                      // var w = Text("ssss");
                                      // type['categories'](entry.key);
                                      // return w;
                                      // return Text(entry);
                                      // return Row(children: [
                                      //   type['categories'][entry].map<Widget>((entry) {
                                      //     return Text("text");
                                      //   })
                                      // ]);
                                      if (!widget.data['categories']
                                          .contains(entry))
                                        return Container(
                                          child: null,
                                        );
                                      else
                                        return SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Row(
                                                children: List<Widget>.generate(
                                                    type['categories'][entry]
                                                        .length, (int index) {
                                              // print(categories[index]);
                                              return Visibility(
                                                visible: entry ==
                                                            chosen_category &&
                                                        widget.data[
                                                                'subcategories']
                                                            .contains(type[
                                                                    'categories']
                                                                [entry][index])
                                                    ? true
                                                    : false,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 0.0,
                                                          bottom: 0,
                                                          top: 0,
                                                          left: 0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      // print("something");
                                                      setSubCategory(
                                                          type['categories']
                                                              [entry][index]);
                                                      // setState(() {});
                                                      // setState(() {
                                                      //   chosen_subcategory =
                                                      //       type['categories'][entry][index];
                                                      //   print(chosen_subcategory);
                                                      // });
                                                    },
                                                    child: Container(
                                                        height: 50,
                                                        // 180
                                                        width: 110,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: <Widget>[
                                                            // Image.asset(
                                                            //     "assets/images/meaticon.png",
                                                            //     height: 30),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                type['categories']
                                                                        [entry]
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
                                                                  color: type['categories'][entry]
                                                                              [
                                                                              index] ==
                                                                          chosen_subcategory
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
                                        );
                                    }).toList()),
                                    // Text('$hideeverything is the hideeverything'),
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
                                              chosen_category != '' &&
                                              chosen_subcategory != ''
                                          ? true
                                          : false,
                                      // visible: false,
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
                                                    isEqualTo: chosen_category)
                                                .where('subcategory',
                                                    isEqualTo:
                                                        chosen_subcategory)
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
                                              chosen_category != '' &&
                                              chosen_subcategory == ''
                                          ? true
                                          : false,
                                      // visible: !hideeverything,
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
                                                    isEqualTo: chosen_category)
                                                // .where('subcategory',
                                                //     isEqualTo: chosen_subcategory)
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
                                              }
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            },
                                          )),
                                    ),
                                    Visibility(
                                      visible: !hideeverything &&
                                              chosen_category == '' &&
                                              chosen_subcategory == ''
                                          ? true
                                          : false,
                                      // visible: false,
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
                                                // .where('category', isEqualTo: chosen_category)
                                                // .where('subcategory',
                                                //     isEqualTo: chosen_subcategory)
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
