class User {
  final String id;
  final String fullName;
  final String email;
  final String userRole;
  User({this.id, this.fullName, this.email, this.userRole});
  User.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        email = data['email'],
        userRole = data['userRole'];
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'userRole': userRole,
    };
  }
}
// import 'package:cloud_firestore/cloud_firestore.dart';

// class User {
//   final String id;
//   final String username;
//   final String email;
//   final String photoUrl;
//   final String displayName;
//   final String bio;

//   User({
//     this.id,
//     this.username,
//     this.email,
//     this.photoUrl,
//     this.displayName,
//     this.bio,
//   });

//   factory User.fromDocument(DocumentSnapshot doc) {
//     return User(
//       id: doc['id'],
//       email: doc['email'],
//       username: doc['username'],
//       photoUrl: doc['photoUrl'],
//       displayName: doc['displayName'],
//       bio: doc['bio'],
//     );
//   }
// }
