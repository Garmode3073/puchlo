import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:puchlo/models/user.dart';
import 'package:puchlo/services/dbservices.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //stream of user login
  Stream<UserinApp> get userIsIn {
    return _auth.userChanges().map(
          (event) => event == null
              ? null
              : UserinApp.fromMap(
                  {'uid': event.uid, 'phone': event.phoneNumber},
                ),
        );
  }

  //get info of user with id
  Future<UserinApp> getUserWithId(String uid) async {
    UserinApp user = UserinApp.fromMap({uid: uid});
    user = await DatabaseServices().currentUser(uid);
    return user;
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      User user = result.user;
      DatabaseServices().addUserInfo(UserinApp.fromMap({
        'uid': user.uid,
        'email': email.trim(),
        'password': password.trim()
      }));
      return UserinApp.fromMap({
        'uid': user.uid,
        'email': email.trim(),
        'password': password.trim()
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return 'error';
    }
  }
}
