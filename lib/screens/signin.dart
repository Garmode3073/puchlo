import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:puchlo/components/line.dart';
import 'package:puchlo/globals.dart' as g;
import 'package:puchlo/models/user.dart';
import 'package:puchlo/screens/register.dart';
import 'package:puchlo/services/dbservices.dart';
import 'package:string_validator/string_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool ispass = true;
  TextEditingController email = TextEditingController(text: '');
  TextEditingController pass = TextEditingController(text: '');
  final _fkey = GlobalKey<FormState>();
  String verificationID;
  String smsCode = "";

  //verify phone no
  Future phoneVerify(phone) async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (vID) {
      this.verificationID = vID;
    };

    final PhoneCodeSent smsCodeSent = (String verID, [int forceCodeResend]) {
      this.verificationID = verID;
      print(verID);
      smsDialog(context).then((value) {
        print('signed in');
      });
    };

    final PhoneVerificationCompleted verSuccess =
        (PhoneAuthCredential cred) async {
      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(cred);
      print("user.user.uid");
      Navigator.pop(context);
    };
    final PhoneVerificationFailed verFailed = (FirebaseAuthException exc) {
      print(exc.message + 'hello there');
    };

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+91 ' + phone,
          verificationCompleted: verSuccess,
          verificationFailed: verFailed,
          codeSent: smsCodeSent,
          codeAutoRetrievalTimeout: autoRetrieve,
          timeout: const Duration(seconds: 120));
    } catch (e) {
      setState(() {
        print(e.toString());
      });
    }
  }

  Future<bool> smsDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter Verification Code'),
            content: TextField(
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: g.width * 0.05, vertical: g.height * 0.01),
            actions: <Widget>[
              RawMaterialButton(
                  onPressed: () {
                    var c = FirebaseAuth.instance.currentUser;
                    if (c != null) {
                      Navigator.pop(context);
                      FirebaseAuth.instance.signOut();
                      signIn();
                    } else {
                      Navigator.pop(context);
                      signIn();
                    }
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(color: Colors.blue),
                  ))
            ],
          );
        });
  }

  signIn() {
    var v = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: smsCode);
    FirebaseAuth.instance.signInWithCredential(v).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    g.height = MediaQuery.of(context).size.height;
    g.width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Center(
          child: Container(
            height: g.height,
            width: g.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.8),
                  ]),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: g.width * 0.1,
                right: g.width * 0.1,
                top: g.height * 0.2,
              ),
              child: Form(
                key: _fkey,
                child: ListView(
                  children: [
                    TextFormField(
                      validator: (email) {
                        if (email.isEmpty) {
                          return "Email Address cannot be empty";
                        } else if (!isEmail(email)) {
                          return "Invalid Email Address";
                        }
                        return null;
                      },
                      controller: email,
                      style: TextStyle(
                        fontFamily: 'Lucida Fax',
                        fontSize: 22,
                        color: Colors.black,
                      ),
                      maxLength: 36,
                      decoration: InputDecoration(
                        counterText: '',
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        contentPadding: EdgeInsets.only(
                            left: g.width * 0.045,
                            right: g.width * 0.045,
                            top: g.height * 0.005,
                            bottom: g.height * 0.005),
                        filled: true,
                        fillColor: const Color(0xe3ffffff),
                        hintText: 'Email-ID',
                        hintStyle: TextStyle(
                          fontFamily: 'Lucida Fax',
                          fontSize: 22,
                          color: Color(0xff707070),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: g.height * 0.025,
                    ),
                    TextFormField(
                      validator: (password) {
                        if (password.isEmpty) {
                          return "Password field cannot be empty";
                        } else if (password.length < 8) {
                          return "Password Must be of length 8 or more";
                        } else if (isAlphanumeric(password) ||
                            isAlpha(password) ||
                            isNumeric(password)) {
                          return "Password must include special characters with alphabets and numbers";
                        }
                        return null;
                      },
                      controller: pass,
                      style: TextStyle(
                        fontFamily: 'Lucida Fax',
                        fontSize: 22,
                        color: Colors.black,
                      ),
                      maxLength: 36,
                      obscureText: ispass,
                      decoration: InputDecoration(
                        counterText: '',
                        suffix: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: FaIcon(
                            ispass
                                ? FontAwesomeIcons.solidEye
                                : FontAwesomeIcons.solidEyeSlash,
                          ),
                          onPressed: () {
                            setState(() {
                              ispass = !ispass;
                            });
                          },
                        ),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        contentPadding: EdgeInsets.only(
                            left: g.width * 0.045,
                            right: g.width * 0.045,
                            top: g.height * 0.005,
                            bottom: g.height * 0.005),
                        filled: true,
                        fillColor: const Color(0xe3ffffff),
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          fontFamily: 'Lucida Fax',
                          fontSize: 22,
                          color: Color(0xff707070),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: g.height * 0.06,
                    ),
                    Center(
                      child: RawMaterialButton(
                        splashColor: Colors.deepPurpleAccent.withOpacity(0.2),
                        onPressed: () async {
                          if (_fkey.currentState.validate()) {
                            UserinApp user = await DatabaseServices()
                                .getUser(email.text.trim(), pass.text.trim());
                            print(user.toMap());
                            phoneVerify(user.phoneNumber);
                          }
                        },
                        child: Container(
                          width: g.width * 0.6,
                          height: g.height * 0.07,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.deepPurple[400],
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(7),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.deepPurpleAccent.withOpacity(0.2),
                                  Colors.deepPurpleAccent.withOpacity(0.8),
                                ]),
                          ),
                          child: Center(
                              child: Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: 'Lucida Fax',
                              fontSize: 22,
                              color: Colors.deepPurple,
                            ),
                          )),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RawMaterialButton(
                          onPressed: () {},
                          child: Center(
                              child: Text(
                            'Forget Password',
                            style: TextStyle(
                              fontFamily: 'Lucida Fax',
                              fontSize: 14,
                              color: Colors.blueAccent,
                            ),
                          )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: g.height * 0.02,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Line(width: g.width * 0.3),
                          Text('OR'),
                          Line(width: g.width * 0.3),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: g.height * 0.04,
                    ),
                    Center(
                      child: RawMaterialButton(
                        onPressed: () async {
                          // Trigger the authentication flow
                          final GoogleSignInAccount googleUser =
                              await GoogleSignIn().signIn();

                          // Obtain the auth details from the request
                          final GoogleSignInAuthentication googleAuth =
                              await googleUser.authentication;

                          // Create a new credential
                          final GoogleAuthCredential credential =
                              GoogleAuthProvider.credential(
                            accessToken: googleAuth.accessToken,
                            idToken: googleAuth.idToken,
                          );

                          // Once signed in, return the UserCredential
                          var user = await FirebaseAuth.instance
                              .signInWithCredential(credential);
                          var v = await FirebaseFirestore.instance
                              .collection("users")
                              .doc(user.user.uid)
                              .get();
                          if (!v.exists) {
                            await DatabaseServices()
                                .addUserInfo(UserinApp.fromMap({
                              'uid': user.user.uid,
                              'name': user.user.displayName,
                              'email': user.user.email,
                              'password': '******',
                              'phoneNumber': user.user.phoneNumber
                            }));
                          }
                          g.userinApp = UserinApp.fromMap({
                            'uid': user.user.uid,
                            'name': user.user.displayName,
                            'email': user.user.email,
                            'password': '******',
                            'phoneNumber': user.user.phoneNumber
                          });
                        },
                        child: Container(
                          width: g.width * 0.6,
                          height: g.height * 0.07,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.deepPurple[400],
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(7),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.deepPurpleAccent.withOpacity(0.2),
                                  Colors.deepPurpleAccent.withOpacity(0.8),
                                ]),
                          ),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(child: Container()),
                              Container(
                                height: g.height * 0.04,
                                width: g.width * 0.15,
                                child: Image.network(
                                    'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-icon-png-transparent-background-osteopathy-16.png'),
                              ),
                              Text(
                                'Login With Google',
                                style: TextStyle(
                                  fontFamily: 'Lucida Fax',
                                  fontSize: 16,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              Expanded(child: Container())
                            ],
                          )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: g.height * 0.02,
                    ),
                    Center(
                      child: RawMaterialButton(
                        splashColor: Colors.deepPurpleAccent.withOpacity(0.2),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: RegisterPage(),
                              type: PageTransitionType.leftToRightJoined,
                              childCurrent: LoginPage(),
                            ),
                          );
                        },
                        child: Container(
                          width: g.width * 0.6,
                          height: g.height * 0.07,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.deepPurple[400],
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(7),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.deepPurpleAccent.withOpacity(0.2),
                                  Colors.deepPurpleAccent.withOpacity(0.8),
                                ]),
                          ),
                          child: Center(
                              child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontFamily: 'Lucida Fax',
                              fontSize: 22,
                              color: Colors.deepPurple,
                            ),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
