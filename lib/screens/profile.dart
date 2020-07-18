import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
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
