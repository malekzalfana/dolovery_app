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

  @override
  Widget build(BuildContext ctxt) {
    // GeoPoint shoplocation;
    // GeoPoint geoPoint = widget.data['location'].getGeoPoint("position");
    // print (widget.data['location']);
    double lat = widget.data['location'].latitude;
    double lng = widget.data['location'].longitude;
    Set<Marker> markers = Set();
    LatLng _center = new LatLng(lat, lng);
    markers.addAll([
      Marker(
          markerId: MarkerId('value'),
          position: LatLng(lat, lng)),
      
    ]);
    // const LatLng _center = const LatLng(45.521563, -122.677433);
    var size = MediaQuery.of(ctxt).size;
    final double itemHeight = (size.height) / 2;
    final double itemWidth = size.width / 2;
    double width = MediaQuery.of(context).size.width;
    return new Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 0.0, right: 0.0, top: 30.0, bottom: 0.0),
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
                    Align(
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 0.0, right: 0.0, top: 0.0, bottom: 10.0),
                child: Column(
                  children: <Widget>[
                    
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            // color: Colors.green,
                            margin: new EdgeInsets.only(left: 12.0, right: 10),
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
                                      color: Colors.grey.withOpacity(0.07),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 8), // changes position of shadow
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.timer,
                                          color: Colors.grey[500],
                                          size: 18.0,
                                          semanticLabel: 'time for shop to deliver',
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              widget.data['time'].toString() + " mins",
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
                                      mainAxisAlignment: MainAxisAlignment.start,
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
                                            padding: const EdgeInsets.all(8.0),
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
                      child:Row(children: [
                    SizedBox(
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

                    ],),
                    ),
                    

                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: StreamBuilder(
                        stream: Firestore.instance
                            .collection('categroies')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children:
                                        List<Widget>.generate(10, (int index) {
                                  // print(categories[index]);
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10.0, bottom: 20),
                                    child: Container(
                                        height: 90,
                                        // 180
                                        width: 90,
                                        decoration: BoxDecoration(
                                          // image: DecorationImage(
                                          //   image: AssetImage(
                                          //       'assets/images/meat.png'),
                                          //   fit: BoxFit.cover,
                                          // ),
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15)),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.07),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  8), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Image.asset(
                                                "assets/images/meaticon.png",
                                                height: 30),
                                            Text(
                                              snapshot.data.documents[0]
                                                  ['name'],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 14.0,
                                                fontFamily: 'Axiforma',
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        )),
                                  );
                                })));
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: StreamBuilder(
                        stream: Firestore.instance
                            .collection('categroies')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children:
                                        List<Widget>.generate(10, (int index) {
                                  // print(categories[index]);
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10.0, bottom: 20),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        snapshot.data.documents[0]['name'],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16.0,
                                          fontFamily: 'Axiforma',
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                })));
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, right: 5, top: 0, bottom: 0),
                        child: StreamBuilder(
                          stream: Firestore.instance
                              .collection('products')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio:
                                    MediaQuery.of(context).size.height / 1150,
                                controller: new ScrollController(
                                    keepScrollOffset: false),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: List.generate(60, (index) {
                                  return ProductImage(
                                      productName: snapshot.data.documents[0]
                                          ['name'],
                                      productImage: snapshot.data.documents[0]
                                          ['image'],
                                      productPrice: snapshot
                                          .data.documents[0]['shop_price']
                                          .toString());
                                }).toList(),
                              );
                            } else if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        )),
                    // List<Widget>.generate(categories.length, (int index) {
                    //   Container(child: Text("ssss"));
                    //   print(categories[index]);
                    //   // return ProduceAction(int, index);
                    // }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
