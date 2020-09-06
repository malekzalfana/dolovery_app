import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dolovery_app/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
                  padding:
                      EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
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
