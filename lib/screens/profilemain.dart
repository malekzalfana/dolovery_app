import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_svg/svg.dart';
// ignore: unused_import
import 'package:country_code_picker/country_code_picker.dart';
import 'package:intl/intl.dart';
// import 'package:dolovery_app/widgets/shopList.dart';

class ProfileMainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

// String finalDate = '';

getCurrentDate() {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yMMMMd');
  final String formatted = formatter.format(now);

  return formatted; // s
}

var this_user;

class FormScreenState extends State<ProfileMainScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name;
  String uid;
  String uemail;
  bool newuser = true;

  Future setupVerification() async {
    print("USER BEING WATCHED");
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    uid = user.uid;
    name = user.displayName;
    uemail = user.email;
    // print("USERNAME")
    this_user =
        await Firestore.instance.collection("users").document(uid).get();

    print(this_user.data['number']);

    if (this_user.exists) {
      newuser = false;
    }
    // return this_user;
  }

  void runsetupVerification() {
    setupVerification().then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    setupVerification();
    // final this_user = setupVerification();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          this_user.data['fullname'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40.0,
                            height: 1.1,
                            fontFamily: 'Axiforma',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  this_user.data['email'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    fontFamily: 'Axiforma',
                    color: Colors.black,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

//   Widget displayUserInformation(BuildContext context, AsyncSnapshot snapshot) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.only(top: 100.0),
//           child: Row(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Center(
//                 child: Text(
//                   snapshot.data.displayName,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 40.0,
//                     height: 1.1,
//                     fontFamily: 'Axiforma',
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Text(
//           snapshot.data.email,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16.0,
//             fontFamily: 'Axiforma',
//             color: Colors.black,
//           ),
//         ),
//       ],
//     );
//   }
// }
