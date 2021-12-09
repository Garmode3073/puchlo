import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:puchlo/models/user.dart';

class DatabaseServices {
  String users = "users";

  //current user
  Future<UserinApp> currentUser(uid) async {
    Map data = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) => value.data());
    return UserinApp.fromMap(data);
  }

  //get user
  Future<UserinApp> getUser(email, pass) async {
    Map data = await FirebaseFirestore.instance
        .collection(users)
        .where("email", isEqualTo: email)
        .where("password", isEqualTo: pass)
        .get()
        .then((value) => value.docs[0])
        .then((value) => {
              'uid': value.id,
              'name': value.data()["name"],
              'email': value.data()["email"],
              'phone': value.data()["phoneNumber"],
              'password': value.data()["password"]
            });
    return UserinApp.fromMap(data);
  }

  //add user
  Future addUserInfo(UserinApp user) async {
    await FirebaseFirestore.instance.collection(users).doc(user.uid).set({
      'uid': user.uid,
      'name': user.name,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'password': user.password
    });
  }
}
