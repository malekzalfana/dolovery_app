import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dolovery_app/screens/setup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dolovery_app/screens/profile.dart';

class SignInFunctions {}

void testfunction(State profileMainScreen) {
  profileMainScreen.setState(() {
    print("testesdedede");
  });
}

// void _onLoading(context) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return Dialog(
//         child: new Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             new CircularProgressIndicator(),
//             new Text("Loading"),
//           ],
//         ),
//       );
//     },
//   );
//   new Future.delayed(new Duration(seconds: 3), () {
//     Navigator.pop(context); //pop dialog
//     // _login();
//   });
// }

// bool newuser = true;
// Future setupVerification() async {
//   print("USER BEING WATCHED");
//   final FirebaseUser user = await FirebaseAuth.instance.currentUser();
//   final uid = user.uid;
//   final name = user.displayName;
//   final uemail = user.email;
//   // print("USERNAME")
//   var usercollection =
//       await Firestore.instance.collection("users").document(uid).get();

//   if (usercollection.exists) {
//     newuser = false;
//   }
//   // return newuser = false;
// }

// void runsetupVerification() {
//   setupVerification().then((value) => null);
// }

// void signOut() {
//   FirebaseAuth.instance.signOut().then((onValue) {
//     print("JUST LOGGED OUT");
//   });
// }

// Future<void> _googleSignUp(context) async {
//   try {
//     print("started signing in");
//     final GoogleSignIn _googleSignIn = GoogleSignIn(
//       scopes: ['email'],
//     );
//     final FirebaseAuth _auth = FirebaseAuth.instance;

//     final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//     final GoogleSignInAuthentication googleAuth =
//         await googleUser.authentication;

//     final AuthCredential credential = GoogleAuthProvider.getCredential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     final FirebaseUser user =
//         (await _auth.signInWithCredential(credential)).user;
//     // _onLoading();
//     // var docRef = db.collection("cities").doc("SF");
//     print("signed in " + user.uid);

//     // used before user.uid
//     bool notsetup;
//     double welcomeheight;
//     final newUser =
//         await Firestore.instance.collection("users").document(user.uid).get();
//     if (newUser.exists) {
//       print('USER EXISTSSSSSSSSSSSSSSSSSSSSSSS');
//       notsetup = false;
//       welcomeheight = 350;
//     } else {
//       print('NOTTTTTTTTTT EXISTSSSSSSSSSSSSSSSSSSSSSSS');
//       notsetup = true;
//       welcomeheight = 400;
//     }
//     Navigator.of(context).pop();

//     _welcomePopUp(context, user.displayName, notsetup, welcomeheight);
//     setState(() {
//       _readtosignin = true;
//     });
//     if (!newUser.exists) {
//       print("user exists");
//     }
//     // } else {
//     //   Firestore.instance.collection("users").add({
//     //     "name": "john",
//     //     "age": 50,
//     //     "email": "example@example.com",
//     //     "address": {"street": "street 24", "city": "new york"}
//     //   }).then((value) {
//     //     print(value.documentID);
//     //   });
//     // }

//     // if (Firestore.instance.collection("users").document(user.uid).get() != null) {

//     // Scaffold.of(context).showSnackBar(snackBar);
//     // }

//     return user;
//   } catch (e) {
//     print(">>>>>>>>>>>>>");
//     if (e.message ==
//         "An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.") {
//       print("cateched");
//     }
//   }
// }

// Future<void> signUpWithFacebook(context) async {
//   try {
//     var facebookLogin = new FacebookLogin();
//     var result = await facebookLogin.logIn(['email']);

//     if (result.status == FacebookLoginStatus.loggedIn) {
//       final AuthCredential credential = FacebookAuthProvider.getCredential(
//         accessToken: result.accessToken.token,
//       );
//       final FirebaseUser user =
//           (await FirebaseAuth.instance.signInWithCredential(credential)).user;
//       print('signed in ' + user.displayName);
//       bool notsetup;
//       double welcomeheight;
//       final newUser =
//           await Firestore.instance.collection("users").document(user.uid).get();
//       if (newUser.exists) {
//         print('USER EXISTSSSSSSSSSSSSSSSSSSSSSSS');
//         notsetup = false;
//         welcomeheight = 350;
//       } else {
//         print('NOTTTTTTTTTT EXISTSSSSSSSSSSSSSSSSSSSSSSS');
//         notsetup = true;
//         welcomeheight = 400;
//       }
//       Navigator.of(context).pop();

//       _welcomePopUp(context, user.displayName, notsetup, welcomeheight);
//       setState(() {
//         _readtosignin = true;
//       });
//       return user;
//     }
//   } catch (e) {
//     if (e.message ==
//         "An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.") {
//       showError(
//           "An account already exists with the same email address, try using Google to sign in.");
//     }
//     setState(() {
//       showerrortextbool = true;
//     });
//   }
// }

// bool showerrortextbool = false;
// void _welcomePopUp(context, name, bool notsetup, double welcomeheight) {
//   showModalBottomSheet(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       context: context,
//       builder: (BuildContext bc) {
//         return Container(
//           height: welcomeheight,
//           child: Column(
//             children: <Widget>[
//               Align(
//                 alignment: Alignment.topRight,
//                 child: IconButton(
//                     icon: Icon(
//                       Icons.clear,
//                       color: Colors.grey,
//                       size: 30,
//                     ),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                       setState(() {
//                         showerrortextbool = false;
//                       });
//                     }),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 50.0),
//                 child: Image.asset(
//                   'assets/images/doloverywhiteback.png',
//                   // height: 120.0,
//                   width: 120.0,
//                 ),
//               ),
//               Text(
//                 "Welcome",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16.0,
//                   fontFamily: 'Axiforma',
//                   color: Colors.black,
//                 ),
//               ),
//               Text(
//                 name,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontWeight: FontWeight.w800,
//                   fontSize: 28.0,
//                   fontFamily: 'Axiforma',
//                   color: Colors.redAccent[700],
//                 ),
//               ),
//               Visibility(
//                 visible: notsetup,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: MaterialButton(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20.0),
//                         side: BorderSide(color: Colors.red)),
//                     onPressed: () {
//                       Navigator.of(context).push(MaterialPageRoute(
//                           builder: (context) => ProfileScreen()));
//                     },
//                     color: Colors.redAccent[700],
//                     textColor: Colors.white,
//                     minWidth: 0,
//                     height: 0,
//                     // padding: EdgeInsets.zero,
//                     padding: EdgeInsets.only(
//                         left: 20, top: 10, right: 20, bottom: 10),
//                     child: Text(
//                       "Setup your profile",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 13.0,
//                         fontFamily: 'Axiforma',
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       });
// }

// bool _readtosignin = true;
// void _signInPopUp(context) {
//   showModalBottomSheet(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       context: context,
//       builder: (BuildContext bc) {
//         return Container(
//           height: 450,
//           child: Column(
//             children: <Widget>[
//               Align(
//                 alignment: Alignment.topRight,
//                 child: IconButton(
//                     icon: Icon(
//                       Icons.clear,
//                       color: Colors.grey,
//                       size: 30,
//                     ),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     }),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 50.0),
//                 child: Image.asset(
//                   'assets/images/doloverywhiteback.png',
//                   // height: 120.0,
//                   width: 120.0,
//                 ),
//               ),
//               Visibility(
//                 visible: _readtosignin,
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 20.0),
//                   child: GestureDetector(
//                     child: Image.asset('assets/images/fblogin.jpg', width: 300),
//                     onTap: () {
//                       hideSignIn();
//                       signUpWithFacebook();
//                     },
//                   ),
//                 ),
//               ),
//               Visibility(
//                 visible: _readtosignin,
//                 child: GestureDetector(
//                     child: Image.asset('assets/images/glogin.jpg', width: 300),
//                     onTap: () {
//                       _readtosignin = false;
//                       // print("ssssssss");
//                       hideSignIn();
//                       _googleSignUp();
//                     }),
//               ),
//               Visibility(
//                 visible: !_readtosignin,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 13.0),
//                   child: new CircularProgressIndicator(),
//                 ),
//               ),
//               Visibility(
//                   visible: showerrortextbool,
//                   child: Padding(
//                       padding:
//                           const EdgeInsets.only(top: 15.0, left: 20, right: 20),
//                       child: Text(
//                         showerrortext,
//                         style: TextStyle(
//                           fontSize: 12.0,
//                           fontFamily: 'Axiforma',
//                           color: Colors.grey,
//                         ),
//                         textAlign: TextAlign.center,
//                       )))
//             ],
//           ),
//         );
//       });
// }

// void hideSignIn(context) {
//   print("HIDEEEEEEEEEEEEEEEEEEEE");
//   Navigator.pop(context);
//   _signInPopUp(context);
//   setState(() {
//     _readtosignin = false;
//     showerrortextbool = false;
//   });
// }

// String showerrortext = "Error";
// void showError(String text, context) {
//   Navigator.pop(context);
//   _signInPopUp(context);
//   showerrortext = text;
//   new Future.delayed(new Duration(seconds: 3), () {
//     setState(() {
//       showerrortextbool = false;
//     });
//     // _login();
//   });
// }

// Future<void> _signInOut(context) async {
//   if (await FirebaseAuth.instance.currentUser() == null) {
//     _signInPopUp(context);
//   } else {
//     signOut();
//   }
// }
