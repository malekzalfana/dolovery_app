import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditProfileState();
  }
}

class EditProfileState extends State<EditProfileScreen> {
  String _streetaddress = "";
  String _landmark = "";

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
  bool canSubmit = true;

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
    }
  }

  void onFieldChange() {
    var fields = <String>[
      _fullname,
      _phone,
      _city,
      _streetaddress,
      _landmark,
      _apartment
    ];
  }

  String _name;
  var _newnumber;
  var _number;
  PhoneNumber _numberparsed;
  var _code;
  PhoneNumber this_number;

  bool newuser = true;
  Future setupVerification() async {
    final User user = await FirebaseAuth.instance.currentUser;
    final uid = user.uid;
    var usercollection =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (usercollection.exists) {
      newuser = false;
      _name = usercollection.data()['fullname'];
      _number = usercollection.data()['number'];
      _code = usercollection.data()['code'];
      String phoneNumber = _code + _number;
      this_number = await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber);
    }
    return newuser = false;
  }

  Widget _newPhoneNumber() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber number) {
          onTextChange("Phone", number.phoneNumber);
          _newnumber =
              number.toString().replaceAll(number.dialCode.toString(), '');
          onFieldChange();
        },
        onInputValidated: (bool value) {},
        ignoreBlank: true,
        selectorType: PhoneInputSelectorType.DIALOG,
        countries: countries,
        maxLength: 15,
        autoValidate: false,
        selectorTextStyle: TextStyle(color: Colors.black),
        initialValue: this_number,
        locale: 'LB',
        hintText: 'Phone Number',
        textFieldController: controller,
        inputBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: new BorderSide(color: Colors.red),
        ),
      ),
    );
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

  Widget _fullnameBuild() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: _name,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            labelText: 'Full Name'),
        maxLength: 50,
        style: new TextStyle(
          fontFamily: "Axiforma",
        ),
        onSaved: (String value) {
          _fullname = value;
        },
        onChanged: (value) {
          onTextChange("Full Name", value);
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
          "Edit Profile",
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
          child: FutureBuilder(
            future: setupVerification(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text('Loading....');
                default:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  else
                    return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _fullnameBuild(),
                              _newPhoneNumber(),
                              SizedBox(height: 10),
                              Visibility(
                                visible: canSubmit,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        side: BorderSide(color: Colors.red)),
                                    onPressed: () {
                                      if (!_formKey.currentState.validate()) {
                                        return;
                                      }

                                      _formKey.currentState.save();

                                      void inputData() async {
                                        final User user =
                                            await FirebaseAuth.instance
                                                .currentUser;
                                        final uid = user.uid;
                                        final name = user.displayName;
                                        final uemail = user.email;
                                        Map<String, dynamic> thisuser = {
                                          "fullname": _fullname,
                                          "number": _newnumber,
                                          "email": uemail,
                                        };

                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(uid)
                                            .update(thisuser);
                                      }

                                      inputData();
                                      Navigator.of(context).pop();
                                    },
                                    color: Colors.redAccent[700],
                                    textColor: Colors.white,
                                    minWidth: MediaQuery.of(context).size.width,
                                    height: 0,
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        top: 10,
                                        right: 20,
                                        bottom: 10),
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
                                        left: 20,
                                        top: 10,
                                        right: 20,
                                        bottom: 10),
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
                        ],
                      ),
                    );
              }
            },
          ),
        ),
      ),
    );
  }
}
