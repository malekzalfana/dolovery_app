import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditAddress extends StatefulWidget {
  final List addressArray;
  final int addressCount;
  final bool isDefault;
  final String thisuser;
  EditAddress(
      this.addressArray, this.addressCount, this.isDefault, this.thisuser,
      {Key key})
      : super(key: key);

  // final List addressArray;
  // // EditAddress(this.addressArray);

  // const EditAddress({Key key, this.addressArray}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditAddressState();
  }
}

class EditAddressState extends State<EditAddress> {
  // String _address = "";
  String _streetaddress = "";
  String _landmark = "";
  // String _city;
  String _apartment = "";
  String _phone = "";
  String _address_name = "";
  String _city = "";
  String addressID = "";
  // List addressArray;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  bool canSubmit = true;

  // Future checklocation() async {
  //   Position position = await getLastKnownPosition();

  //   bool isLocationServiceEnabled  = await isLocationServiceEnabled();

  // }

  void onTextChange(String fieldname, String value) {
    print("started phone");
    if (fieldname == "Address") {
      _streetaddress = value;
    } else if (fieldname == "Landmark") {
      _landmark = value;
    } else if (fieldname == "Apartment") {
      _apartment = value;
    } else if (fieldname == "Address Name") {
      _address_name = value;
      print(_phone);
    }
  }

  void onFieldChange() {
    // print()
    var fields = <String>[
      _address_name,
      _city,
      _streetaddress,
      _landmark,
      _apartment
    ];
    print(fields);
    if (fields.contains("") || fields.contains(null)) {
      print(canSubmit);
      setState(() {
        canSubmit = false;
      });
    } else {
      setState(() {
        canSubmit = true;
      });
    }
  }

  bool newuser = true;
  Future setupVerification() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;
    // final name = user.displayName;
    // final uemail = user.email;
    // print("USERNAME")
    var usercollection =
        await Firestore.instance.collection("users").document(uid).get();

    if (usercollection.exists) {
      newuser = false;
    }
    return newuser = false;
  }

  bool newIsDefault;
  bool ult;
  // @override
  // void dispose() {
  //   controller?.dispose();
  //   super.dispose();
  // }

  var currentSelectedValue;
  static const deviceTypes = [
    "Aley",
    "Baabda",
    "Baalback",
    "Batroun",
    "Beirut ",
    "Bent Jbeil",
    "Besharreh",
    "Hasbayah",
    "Hermil",
    "Jbeil",
    "Jezzine",
    "Kesrouan",
    "Koura",
    "Marjayoun",
    "Matn",
    "Nabatiyeh",
    "Rashaya",
    "Shouf",
    "Sidon",
    "Tripoli",
    "Tyre",
    "West bekaa",
    "Zahle",
    "Zgharta",
  ];
  Widget _defaultAddress() {
    return CheckboxListTile(
      title: Text("Set as default address"),
      value: newIsDefault,
      onChanged: (newValue) {
        print(newValue);
        setState(() {
          newIsDefault = newValue;
          addressEdited = true;
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  Widget _address1Build() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FormField<String>(
            builder: (FormFieldState<String> state) {
              return InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),

                  // focusedBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),

                // errorBorder: InputBorder.none,
                // disabledBorder: InputBorder.none,),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text(_city),
                    isExpanded: true,
                    value: currentSelectedValue,
                    isDense: true,
                    onChanged: (newValue) {
                      setState(() {
                        _city = newValue;
                        currentSelectedValue = _city;
                      });
                      onFieldChange();
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
      ),
    );
  }

  Widget _address2Build() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: _streetaddress,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            // focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),

            // errorBorder: InputBorder.none,
            // disabledBorder: InputBorder.none,
            labelText: 'Street Adress'),
        maxLength: 100,
        style: new TextStyle(
          fontFamily: "Axiforma",
        ),
        // validator: (String value) {
        //   if (value.isEmpty) {
        //     return 'Street Adress is Required';
        //   }

        //   return null;
        // },
        onSaved: (String value) {
          _streetaddress = value;
        },
        onChanged: (value) {
          // print("street");
          onTextChange("Address", value);
          onFieldChange();
        },
      ),
    );
  }

  Widget _address3Build() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: _landmark,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            // focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            // errorBorder: InputBorder.none,
            // disabledBorder: InputBorder.none,
            labelText: 'Landmark'),
        maxLength: 50,
        style: new TextStyle(
          fontFamily: "Axiforma",
        ),
        // validator: (String value) {
        //   if (value.isEmpty) {
        //     return 'Landmark is Required';
        //   }

        //   return null;
        // },
        onSaved: (String value) {
          _landmark = value;
          // onFieldChange();
        },
        onChanged: (value) {
          onTextChange("Landmark", value);
          onFieldChange();
        },
      ),
    );
  }

  Widget _address_nameBuild() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: _address_name,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            // focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            // errorBorder: InputBorder.none,
            // disabledBorder: InputBorder.none,
            labelText: 'Address Name'),
        maxLength: 50,
        style: new TextStyle(
          fontFamily: "Axiforma",
        ),
        // validator: (String value) {
        //   if (value.isEmpty) {
        //     return 'Landmark is Required';
        //   }

        //   return null;
        // },
        onSaved: (String value) {
          _address_name = value;
          // onFieldChange();
        },
        onChanged: (value) {
          onTextChange("Address Name", value);
          onFieldChange();
        },
      ),
    );
  }

  Widget _address4Build() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: _apartment,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            // focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            // errorBorder: InputBorder.none,
            // disabledBorder: InputBorder.none,

            labelText: 'Apartment / Floor'),
        maxLength: 50,
        style: new TextStyle(
          fontFamily: "Axiforma",
        ),
        // validator: (String value) {
        //   if (value.isEmpty) {
        //     return 'Apartment is Required';
        //   }

        //   return null;
        // },
        onSaved: (String value) {
          _apartment = value;
          // onFieldChange();
        },
        onChanged: (value) {
          onTextChange("Apartment", value);
          onFieldChange();
        },
      ),
    );
  }

  // @override
  // void initState() {
  //   newIsDefault = widget.isDefault;
  //   super.initState();
  // }
  bool addressEdited = false;
  @override
  Widget build(BuildContext context) {
    _streetaddress = widget.addressArray[widget.addressCount]["street_address"];
    _landmark = widget.addressArray[widget.addressCount]["landmark"];
    // String _city;

    _address_name = widget.addressArray[widget.addressCount]["name"];
    _city = widget.addressArray[widget.addressCount]["city"];
    addressID = widget.addressArray[widget.addressCount]["id"];
    print("the address is $addressID");
    _apartment = widget.addressArray[widget.addressCount]["apartment"];
    if (!addressEdited) {
      newIsDefault = widget.isDefault;
    }

    print(widget.addressArray);
    print("above");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: BackButton(color: Colors.black),
        centerTitle: true,
        title: Text(
          "Edit " + _address_name,
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
        child: FutureBuilder(
            future: setupVerification(),
            builder: (context, snapshot) {
              return Container(
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
                      _address_nameBuild(),
                      _address1Build(),
                      _address2Build(),
                      _address3Build(),
                      _address4Build(),
                      _defaultAddress(),
                      SizedBox(height: 10),
                      Visibility(
                        visible: canSubmit,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
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
                                Map<String, dynamic> thisAddress = {
                                  "name": _address_name,
                                  "city": _city,
                                  "street_address": _streetaddress,
                                  "landmark": _landmark,
                                  "apartment": _apartment,
                                  "id": addressID
                                };
                                print('userid is' + uid.toString());
                                print(thisAddress);
                                print(widget.addressArray);

                                // addressArray  ;
                                // List finalAdressArray = [];
                                // widget.addressArray.add(thisAddress);
                                // var rList = [0, 1, 2, 3, 4, 5, 6];
                                widget.addressArray.replaceRange(
                                    widget.addressCount,
                                    widget.addressCount + 1,
                                    [thisAddress]);
                                // print('$rList'); // [0, 1, 10, 3, 4, 5, 6]

                                // Future
                                // List addresses = [thisAddress];
                                // Map<String, dynamic> thisuser = {
                                //   "fullname": _address_name,
                                //   "number": _phone,
                                //   "email": uemail,
                                //   "address": addresses
                                //   // "id": uid,
                                //   // "city": _city,
                                //   // "street_address": _streetaddress,
                                //   // "landmark": _landmark,
                                //   // "apartment": _apartment,
                                // };
                                Firestore.instance
                                    .collection('users')
                                    .document(uid)
                                    .updateData({
                                  "address": widget.addressArray
                                }).then((result) {
                                  print("address edited");
                                }).catchError((onError) {
                                  print("onError");
                                });
                                // print("USERNAME")
                                if (newIsDefault) {
                                  Firestore.instance
                                      .collection("users")
                                      .document(uid)
                                      .updateData({
                                    "chosen_address": addressID,
                                  });
                                }

                                // here you write the codes to input the data into firestore
                              }

                              inputData();
                              Navigator.of(context).pop();
                              // Navigator.of(context).pop();

                              //Send to API
                            },
                            color: Colors.redAccent[700],
                            textColor: Colors.white,
                            minWidth: MediaQuery.of(context).size.width,
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
                      ),
                      Visibility(
                        visible: canSubmit == false, //canSubmit,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 0,
                            onPressed: null,
                            color: Colors.grey[200],
                            disabledColor: Colors.grey[200],
                            textColor: Colors.grey[300],
                            minWidth: MediaQuery.of(context).size.width,
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
                                // color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
