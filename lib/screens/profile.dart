import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:dropdownfield/dropdownfield.dart';
// import 'package:country_code_picker/country_code_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import 'package:international_phone_input/international_phone_input.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

class FormScreenState extends State<ProfileScreen> {
  // String _address = "";
  String _streetaddress = "";
  String _landmark = "";
  // String _city;
  String _apartment = "";
  String _phone = "";
  String _fullname = "";
  String _city = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'LB';
  PhoneNumber number = PhoneNumber(isoCode: 'LB');

  String phoneNumber;
  String phoneIsoCode;
  bool canSubmit = false;

  // void onStart() {
  //   canSubmit = false;
  //   print("sss");
  // }

  List<String> countries = [
    "AF",
    "AL",
    "DZ",
    "AS",
    "AD",
    "AO",
    "AI",
    "AQ",
    "AG",
    "AR",
    "AM",
    "AW",
    "AU",
    "AT",
    "AZ",
    "BS",
    "BH",
    "BD",
    "BB",
    "BY",
    "BE",
    "BZ",
    "BJ",
    "BM",
    "BT",
    "BO",
    "BQ",
    "BA",
    "BW",
    "BV",
    "BR",
    "IO",
    "BN",
    "BG",
    "BF",
    "BI",
    "CV",
    "KH",
    "CM",
    "CA",
    "KY",
    "CF",
    "TD",
    "CL",
    "CN",
    "CX",
    "CC",
    "CO",
    "KM",
    "CD",
    "CG",
    "CK",
    "CR",
    "HR",
    "CU",
    "CW",
    "CY",
    "CZ",
    "CI",
    "DK",
    "DJ",
    "DM",
    "DO",
    "EC",
    "EG",
    "SV",
    "GQ",
    "ER",
    "EE",
    "SZ",
    "ET",
    "FK",
    "FO",
    "FJ",
    "FI",
    "FR",
    "GF",
    "PF",
    "TF",
    "GA",
    "GM",
    "GE",
    "DE",
    "GH",
    "GI",
    "GR",
    "GL",
    "GD",
    "GP",
    "GU",
    "GT",
    "GG",
    "GN",
    "GW",
    "GY",
    "HT",
    "HM",
    "VA",
    "HN",
    "HK",
    "HU",
    "IS",
    "IN",
    "ID",
    "IQ",
    "IE",
    "IM",
    "IT",
    "JM",
    "JP",
    "JE",
    "JO",
    "KZ",
    "KE",
    "KI",
    "KP",
    "KR",
    "KW",
    "KG",
    "LA",
    "LV",
    "LB",
    "LS",
    "LR",
    "LY",
    "LI",
    "LT",
    "LU",
    "MO",
    "MG",
    "MW",
    "MY",
    "MV",
    "ML",
    "MT",
    "MH",
    "MQ",
    "MR",
    "MU",
    "YT",
    "MX",
    "FM",
    "MD",
    "MC",
    "MN",
    "ME",
    "MS",
    "MA",
    "MZ",
    "MM",
    "NA",
    "NR",
    "NP",
    "NL",
    "NC",
    "NZ",
    "NI",
    "NE",
    "NG",
    "NU",
    "NF",
    "MP",
    "NO",
    "OM",
    "PK",
    "PW",
    "PS",
    "PA",
    "PG",
    "PY",
    "PE",
    "PH",
    "PN",
    "PL",
    "PT",
    "PR",
    "QA",
    "MK",
    "RO",
    "RU",
    "RW",
    "RE",
    "BL",
    "SH",
    "KN",
    "LC",
    "MF",
    "PM",
    "VC",
    "WS",
    "SM",
    "ST",
    "SA",
    "SN",
    "RS",
    "SC",
    "SL",
    "SG",
    "SX",
    "SK",
    "SI",
    "SB",
    "SO",
    "ZA",
    "GS",
    "SS",
    "ES",
    "LK",
    "SD",
    "SR",
    "SJ",
    "SE",
    "CH",
    "SY",
    "TW",
    "TJ",
    "TZ",
    "TH",
    "TL",
    "TG",
    "TK",
    "TO",
    "TT",
    "TN",
    "TR",
    "TM",
    "TC",
    "TV",
    "UG",
    "UA",
    "AE",
    "GB",
    "UM",
    "US",
    "UY",
    "UZ",
    "VU",
    "VE",
    "VN",
    "VG",
    "VI",
    "WF",
    "EH",
    "YE",
    "ZM",
    "ZW",
    "AX",
  ];

  void onTextChange(String fieldname, String value) {
    print("started phone");
    if (fieldname == "Address") {
      _streetaddress = value;
    } else if (fieldname == "Landmark") {
      _landmark = value;
    } else if (fieldname == "Apartment") {
      _apartment = value;
    } else if (fieldname == "Phone") {
      _phone = value;
    } else if (fieldname == "Full Name") {
      _fullname = value;
      print(_phone);
    }
  }

  void onFieldChange() {
    // print()
    var fields = <String>[
      _fullname,
      _phone,
      _city,
      _streetaddress,
      _landmark,
      _apartment
    ];
    bool allgood = true;
    print(fields);
    // for (var i = 0; i <= fields.length; i++) {
    //   if (fields[i].toString().length < 2) {
    //     allgood = false;
    //   }
    // }
    // if (allgood) {
    //   setState(() {
    //     canSubmit = true;
    //   });
    // }
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

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget _newPhoneNumber() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber number) {
          print(number.phoneNumber);
          onTextChange("Phone", number.phoneNumber);
          onFieldChange();
        },
        onInputValidated: (bool value) {
          print(value);
        },
        ignoreBlank: false,
        selectorType: PhoneInputSelectorType.DIALOG,
        countries: countries,
        maxLength: 15,
        autoValidate: false,
        selectorTextStyle: TextStyle(color: Colors.black),
        initialValue: number,
        textFieldController: controller,
        inputBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: new BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  var currentSelectedValue;
  static const deviceTypes = ["Beirut", "Tripoli", "Saida"];

  Widget _address1Build() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
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
                    borderSide: BorderSide(color: Colors.grey[500], width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
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
            // focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[500], width: 1.0),
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
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            // focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[500], width: 1.0),
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

  Widget _fullnameBuild() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            // focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[500], width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            // errorBorder: InputBorder.none,
            // disabledBorder: InputBorder.none,
            labelText: 'Full Name'),
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
          _fullname = value;
          // onFieldChange();
        },
        onChanged: (value) {
          onTextChange("Full Name", value);
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
            // focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[500], width: 1.0),
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
                _fullnameBuild(),
                _address1Build(),
                _newPhoneNumber(),
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
                            "name": 'Home',
                            "city": _city,
                            "street_address": _streetaddress,
                            "landmark": _landmark,
                            "apartment": _apartment,
                          };
                          List addresses = [thisAddress];
                          Map<String, dynamic> thisuser = {
                            "fullname": _fullname,
                            "number": _phone,
                            "email": uemail,
                            "address": addresses
                            // "id": uid,
                            // "city": _city,
                            // "street_address": _streetaddress,
                            // "landmark": _landmark,
                            // "apartment": _apartment,
                          };

                          // print("USERNAME")
                          Firestore.instance
                              .collection("users")
                              .document(uid)
                              .setData(thisuser);
                          //     .add({
                          //   "fullname": name,
                          //   "number": _phone,
                          //   "email": uemail,
                          //   "id": uid,
                          //   "city": _city,
                          //   "street_address": _streetaddress,
                          //   "landmark": _landmark,
                          //   "apartment": _apartment,
                          // });

                          // here you write the codes to input the data into firestore
                        }

                        inputData();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();

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
                      textColor: Colors.grey[500],
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
        ),
      ),
    );
  }
}
