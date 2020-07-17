import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dolovery',
      theme: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
        fontFamily: "Axiforma",
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Homepage'),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

Widget _buildLebanese() {
  return SingleChildScrollView(
      child: Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(
            left: 5.0, right: 10.0, top: 30.0, bottom: 10.0),
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
                padding: EdgeInsets.only(left: 6, top: 0, right: 6, bottom: 1),
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
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
            left: 20.0, right: 10.0, top: 0.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "100% Lebanese",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26.0,
                fontFamily: 'Axiforma',
                color: Colors.black,
              ),
            ),
            Image.asset("assets/images/fullfilldolovery.png", height: 23),
          ],
        ),
      ),
    ],
  ));
}

List<String> categories = [
  "Produce",
  "Poltry",
  "Baked",
  "Canned Goods",
  "Beverage",
  "Dairy & Eggs",
  "Coffee",
  "Frozen",
  "Tobacco",
  "Chocolate"
];

class TabsDemo extends StatefulWidget {
  @override
  _TabsDemoState createState() => _TabsDemoState();
}

class _TabsDemoState extends State<TabsDemo> {
  TabController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext ctxt) {
    var size = MediaQuery.of(ctxt).size;
    final double itemHeight = (size.height) / 2;
    final double itemWidth = size.width / 2;
    return new Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 30.0, bottom: 0.0),
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
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 10.0, top: 0.0, bottom: 10.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "100% Lebanese",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0,
                              fontFamily: 'Axiforma',
                              color: Colors.black,
                            ),
                          ),
                          Image.asset("assets/images/fullfilldolovery.png",
                              height: 23),
                        ],
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
                                    child: Container(
                                        height: 120,
                                        // 180
                                        width: 120,
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
                                                height: 40),
                                            Text(
                                              snapshot.data.documents[0]
                                                  ['name'],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 15.0,
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
                                    MediaQuery.of(context).size.height / 1000,
                                controller: new ScrollController(
                                    keepScrollOffset: false),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: List.generate(60, (index) {
                                  return new Container(
                                      // color: Colors.green,
                                      margin: new EdgeInsets.only(
                                          left: 4.0, right: 4),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                height: 150,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                ),
                                                child: Center(
                                                  child: Image.network(
                                                      snapshot.data.documents[0]
                                                          ['image'],
                                                      height: 120,
                                                      width: 120),
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                snapshot.data.documents[0]
                                                    ['name'],
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.5,
                                                  fontFamily: 'Axiforma',
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0.0),
                                              child: Text(
                                                snapshot.data
                                                    .documents[0]['shop_price']
                                                    .toString(),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 13.5,
                                                  fontFamily: 'Axiforma',
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ]));
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

class ProduceAction extends StatefulWidget {
  ProduceAction(Type int, int index);

  @override
  State<StatefulWidget> createState() {
    return ProduceActionApp();
  }
}

class ProduceActionApp extends State<ProduceAction> {
  int counter = 0;
  bool tickmark = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[Text("This is ")],
    );
  }
}

class FormScreenState extends State<ProfileScreen> {
  String _address;
  String _streetaddress;
  String _landmark;
  String _city;
  String _apartment;
  String _phone;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _phoneNumber() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: TextFormField(
        style: new TextStyle(
          fontFamily: "Axiforma",
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          // focusedBorder: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[200], width: 1.0),
          ),
          // errorBorder: InputBorder.none,
          // disabledBorder: InputBorder.none,
          labelText: "Phone Number",

          // contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          fillColor: Colors.grey[300],
        ),
        maxLength: 10,
        keyboardType: TextInputType.phone,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Phone number is Required';
          }

          return null;
        },
        onSaved: (String value) {
          _phone = value;
        },
      ),
    );
  }

  var currentSelectedValue;
  static const deviceTypes = ["Beirut", "Tripoli", "Saida"];

  Widget _address1Build() {
    String _selectedCity = "Beirut";
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        child: FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),

                // focusedBorder: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[200], width: 1.0),
                ),
              ),

              // errorBorder: InputBorder.none,
              // disabledBorder: InputBorder.none,),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text("Select City"),
                  isExpanded: true,
                  value: currentSelectedValue,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCity = newValue;
                      currentSelectedValue = _selectedCity;
                    });
                    print(currentSelectedValue);
                  },
                  items: deviceTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget _address1Build() {
  //   return TextFormField(
  //     decoration: InputDecoration(
  //         border: InputBorder.none,
  //         focusedBorder: InputBorder.none,
  //         enabledBorder: InputBorder.none,
  //         errorBorder: InputBorder.none,
  //         disabledBorder: InputBorder.none,
  //         labelText: 'City'),
  //     maxLength: 10,
  //     style: new TextStyle(
  //       fontFamily: "Axiforma",
  //     ),
  //     validator: (String value) {
  //       if (value.isEmpty) {
  //         return 'City is Required';
  //       }

  //       return null;
  //     },
  //     onSaved: (String value) {
  //       _address1 = value;
  //     },
  //   );
  // }

  Widget _address2Build() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            // focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200], width: 1.0),
            ),
            // errorBorder: InputBorder.none,
            // disabledBorder: InputBorder.none,
            labelText: 'Street Adress'),
        maxLength: 95,
        style: new TextStyle(
          fontFamily: "Axiforma",
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Street Adress is Required';
          }

          return null;
        },
        onSaved: (String value) {
          _streetaddress = value;
        },
      ),
    );
  }

  Widget _address3Build() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            // focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200], width: 1.0),
            ),
            // errorBorder: InputBorder.none,
            // disabledBorder: InputBorder.none,
            labelText: 'Landmark'),
        maxLength: 50,
        style: new TextStyle(
          fontFamily: "Axiforma",
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Landmark is Required';
          }

          return null;
        },
        onSaved: (String value) {
          _landmark = value;
        },
      ),
    );
  }

  Widget _address4Build() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            // focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200], width: 1.0),
            ),
            // errorBorder: InputBorder.none,
            // disabledBorder: InputBorder.none,

            labelText: 'Apartment / Floor'),
        maxLength: 50,
        style: new TextStyle(
          fontFamily: "Axiforma",
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Apartment is Required';
          }

          return null;
        },
        onSaved: (String value) {
          _apartment = value;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: BackButton(color: Colors.black),
        centerTitle: true,
        title: Text(
          "Enter Details",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16.0,
            fontFamily: 'Axiforma',
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(44),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Text(
                //   "Enter the details",
                //   textAlign: TextAlign.left,
                //   style: TextStyle(
                //     fontWeight: FontWeight.w800,
                //     fontSize: 28.0,
                //     fontFamily: 'Axiforma',
                //     color: Colors.black,
                //   ),
                // ),
                _phoneNumber(),
                _address1Build(),
                _address2Build(),
                _address3Build(),
                _address4Build(),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: Colors.red)),
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }

                      _formKey.currentState.save();

                      print("adding profile");
                      void inputData() async {
                        final FirebaseUser user =
                            await FirebaseAuth.instance.currentUser();
                        final uid = user.uid;
                        final name = user.displayName;
                        final uemail = user.email;
                        // print("USERNAME")
                        Firestore.instance.collection("users").add({
                          "Full Name": name,
                          "Number": _phone,
                          "Email": uemail,
                          "City": _city,
                          "Address": _address,
                          "Street Address": _streetaddress,
                          "Landmark": _landmark,
                          "Apartment": _apartment,
                        });

                        // here you write the codes to input the data into firestore
                      }

                      inputData();

                      //Send to API
                    },
                    color: Colors.redAccent[700],
                    textColor: Colors.white,
                    minWidth: 0,
                    height: 0,
                    // padding: EdgeInsets.zero,
                    padding: EdgeInsets.only(
                        left: 20, top: 10, right: 20, bottom: 10),
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        fontFamily: 'Axiforma',
                        color: Colors.white,
                      ),
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

List<String> lebproductcount = ['A', 'B', 'C'];

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  // @override
  void signOut() {
    FirebaseAuth.instance.signOut().then((onValue) {
      print("JUST LOGGED OUT");
    });
  }

  Future<void> _signInOut() async {
    if (await FirebaseAuth.instance.currentUser() == null) {
      _signInPopUp(context);
    } else {
      signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   title: Text(
        //     widget.title,
        //   ),
        // ),
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 30.0, bottom: 10.0),
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
                      _signInOut();
                    },
                    color: Colors.redAccent[700],
                    textColor: Colors.white,
                    minWidth: 0,
                    height: 0,
                    // padding: EdgeInsets.zero,
                    padding:
                        EdgeInsets.only(left: 6, top: 0, right: 6, bottom: 1),
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
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 10.0, top: 0.0, bottom: 10.0),
            child: Row(
              children: <Widget>[
                Text(
                  "What are you looking for?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 10),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 0),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                // color: Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: <Widget>[
                  Image.asset("assets/icons/searchicon.png", height: 16),
                  SizedBox(width: 16),
                  Container(
                    child: Text(
                      "Search for anything",
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: "Axiforma",
                        color: Color(0xFFA0A5BD),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
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
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => TabsDemo()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "100% Lebanese",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20.0,
                              fontFamily: 'Axiforma',
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "20+ Shops ready to deliver",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              fontFamily: 'Axiforma',
                              color: Colors.redAccent[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/lebsec.png',
                    width: 120,
                  )
                ],
              ),
            ),
          ),
          Padding(
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
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Supplements",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20.0,
                              fontFamily: 'Axiforma',
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "20+ Shops ready to deliver",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              fontFamily: 'Axiforma',
                              color: Colors.redAccent[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/supsec.png',
                    width: 120,
                  )
                ],
              ),
            ),
          ),
          Padding(
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
                  GestureDetector(
                    onTap: () {
                      // Navigator.of(context).pop();
                      _welcomePopUp(context, "Malek Zalfana");
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Pet Shops",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20.0,
                              fontFamily: 'Axiforma',
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "20+ Shops ready to deliver",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              fontFamily: 'Axiforma',
                              color: Colors.redAccent[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/petsec.png',
                    width: 120,
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "100% Lebanese",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileScreen()));
                    },
                    child: Image.asset("assets/images/fullfilldolovery.png",
                        height: 23))
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, top: 0, bottom: 0),
              child: StreamBuilder(
                stream: Firestore.instance.collection('products').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (itemWidth / itemHeight),
                      controller: new ScrollController(keepScrollOffset: false),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: List.generate(4, (index) {
                        return new Container(
                          color: Colors.green,
                          margin: new EdgeInsets.all(1.0),
                          child: new Center(
                            child: new Text(
                              snapshot.data.documents[0]['name'],
                              style: new TextStyle(
                                fontSize: 50.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )),
          Padding(
            padding:
                const EdgeInsets.only(left: 10.0, right: 10, top: 0, bottom: 0),
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('products')
                  //.where("shop_price", "<", 20000)
                  .orderBy("shop_price")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Text('Loading data.. Please Wait..');
                return GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (itemWidth / itemHeight),
                  controller: new ScrollController(keepScrollOffset: false),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: lebproductcount.map((String value) {
                    return new Container(
                      color: Colors.green,
                      margin: new EdgeInsets.all(1.0),
                      child: new Center(
                        child: new Text(
                          snapshot.data.documents[0]['name'],
                          style: new TextStyle(
                            fontSize: 50.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }

  void _signInPopUp(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 450,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Image.asset(
                    'assets/images/doloverywhiteback.png',
                    // height: 120.0,
                    width: 120.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: GestureDetector(
                    child: Image.asset('assets/images/fblogin.jpg', width: 300),
                    onTap: () => signUpWithFacebook(),
                  ),
                ),
                GestureDetector(
                  child: Image.asset('assets/images/glogin.jpg', width: 300),
                  onTap: () => _googleSignUp(),
                )
              ],
            ),
          );
        });
  }

  void _welcomePopUp(context, name) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 400,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Image.asset(
                    'assets/images/doloverywhiteback.png',
                    // height: 120.0,
                    width: 120.0,
                  ),
                ),
                Text(
                  "Welcome",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black,
                  ),
                ),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 28.0,
                    fontFamily: 'Axiforma',
                    color: Colors.redAccent[700],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: Colors.red)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileScreen()));
                    },
                    color: Colors.redAccent[700],
                    textColor: Colors.white,
                    minWidth: 0,
                    height: 0,
                    // padding: EdgeInsets.zero,
                    padding: EdgeInsets.only(
                        left: 20, top: 10, right: 20, bottom: 10),
                    child: Text(
                      "Setup your profile",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                        fontFamily: 'Axiforma',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _popDetails(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 700,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
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
                Text(
                  "Add Details",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _googleSignUp() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      final snackBar = SnackBar(
        content: Text('Welcome to Dolovery!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      // var docRef = db.collection("cities").doc("SF");
      print("signed in " + user.uid);
      Navigator.of(context).pop();
      _welcomePopUp(context, user.displayName);
      // used before user.uid
      final newUser =
          await Firestore.instance.collection("users").document(user.uid).get();
      if (!newUser.exists) {
        print("user exists");
      } else {
        Firestore.instance.collection("users").add({
          "name": "john",
          "age": 50,
          "email": "example@example.com",
          "address": {"street": "street 24", "city": "new york"}
        }).then((value) {
          print(value.documentID);
        });
      }

      // if (Firestore.instance.collection("users").document(user.uid).get() != null) {

      // Scaffold.of(context).showSnackBar(snackBar);
      // }

      return user;
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> signUpWithFacebook() async {
    try {
      var facebookLogin = new FacebookLogin();
      var result = await facebookLogin.logIn(['email']);

      if (result.status == FacebookLoginStatus.loggedIn) {
        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        );
        final FirebaseUser user =
            (await FirebaseAuth.instance.signInWithCredential(credential)).user;
        print('signed in ' + user.displayName);
        return user;
      }
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> signUpWithMail() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Success sign up'),
            );
          });
    } catch (e) {
      print(e.message);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message),
            );
          });
    }
  }
}
