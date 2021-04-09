import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAddress extends StatefulWidget {
  final List addressArray;
  AddAddress(this.addressArray, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddAddressState();
  }
}

class AddAddressState extends State<AddAddress> {
  String _streetaddress = "";
  String _landmark = "";

  String _apartment = "";
  String _phone = "";
  String _addressName = "";
  String _city = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  bool canSubmit = false;

  void onTextChange(String fieldname, String value) {
    print("started phone");
    if (fieldname == "Address") {
      _streetaddress = value;
    } else if (fieldname == "Landmark") {
      _landmark = value;
    } else if (fieldname == "Apartment") {
      _apartment = value;
    } else if (fieldname == "Address Name") {
      _addressName = value;
      print(_phone);
    }
  }

  void onFieldChange() {
    var fields = <String>[
      _addressName,
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

    var usercollection =
        await Firestore.instance.collection("users").document(uid).get();

    if (usercollection.exists) {
      newuser = false;
    }
    return newuser = false;
  }

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

  Widget _address1Build() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
      child: Container(
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
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text("Select City"),
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
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            labelText: 'Street Adress'),
        maxLength: 100,
        style: new TextStyle(
          fontFamily: "Axiforma",
        ),
        onSaved: (String value) {
          _streetaddress = value;
        },
        onChanged: (value) {
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
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            labelText: 'Landmark'),
        maxLength: 50,
        style: new TextStyle(
          fontFamily: "Axiforma",
        ),
        onSaved: (String value) {
          _landmark = value;
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
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            labelText: 'Address Name'),
        maxLength: 50,
        style: new TextStyle(
          fontFamily: "Axiforma",
        ),
        onSaved: (String value) {
          _addressName = value;
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
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            labelText: 'Apartment / Floor'),
        maxLength: 50,
        style: new TextStyle(
          fontFamily: "Axiforma",
        ),
        onSaved: (String value) {
          _apartment = value;
        },
        onChanged: (value) {
          onTextChange("Apartment", value);
          onFieldChange();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.addressArray);
    print("above");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: BackButton(color: Colors.black),
        centerTitle: true,
        title: Text(
          "Add New Address",
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
                _address_nameBuild(),
                _address1Build(),
                _address2Build(),
                _address3Build(),
                _address4Build(),
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
                            "name": _addressName,
                            "city": _city,
                            "street_address": _streetaddress,
                            "landmark": _landmark,
                            "apartment": _apartment,
                            "id": UniqueKey().hashCode.toString()
                          };
                          print('userid is' + uid.toString());
                          print(thisAddress);
                          print(widget.addressArray);

                          widget.addressArray.add(thisAddress);

                          Firestore.instance
                              .collection('users')
                              .document(uid)
                              .updateData({
                            "address": widget.addressArray
                          }).then((result) {
                            print("address added");
                          }).catchError((onError) {
                            print("onError");
                          });
                        }

                        inputData();
                        Navigator.of(context).pop();
                      },
                      color: Colors.redAccent[700],
                      textColor: Colors.white,
                      minWidth: MediaQuery.of(context).size.width,
                      height: 0,
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
                  visible: canSubmit == false,
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
                      padding: EdgeInsets.only(
                          left: 20, top: 10, right: 20, bottom: 10),
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          fontFamily: 'Axiforma',
                        ),
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
