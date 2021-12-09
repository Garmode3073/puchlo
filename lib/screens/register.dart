import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:puchlo/components/line.dart';
import 'package:puchlo/globals.dart' as g;
import 'package:puchlo/models/user.dart';
import 'package:puchlo/services/dbservices.dart';
import 'package:string_validator/string_validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool ispass = true;
  bool ispass2 = true;
  TextEditingController name = TextEditingController(text: '');
  TextEditingController phone = TextEditingController(text: '');
  TextEditingController email = TextEditingController(text: '');
  TextEditingController pass = TextEditingController(text: '');
  TextEditingController pass2 = TextEditingController(text: '');
  final _fkey = GlobalKey<FormState>();
  String verificationID;
  String smsCode = "";

  //verify phone no
  Future phoneVerify() async {
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
      Navigator.pop(context);
    };
    final PhoneVerificationFailed verFailed = (FirebaseAuthException exc) {
      print(exc.message + 'hello there');
    };

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+91 ' + phone.text,
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
                  onPressed: () async {
                    var c = FirebaseAuth.instance.currentUser;
                    if (c != null) {
                      Navigator.pop(context);
                      FirebaseAuth.instance.signOut();
                      await signIn();
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      await signIn();
                      Navigator.pop(context);
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

  signIn() async {
    var v = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: smsCode);
    UserCredential userc =
        await FirebaseAuth.instance.signInWithCredential(v).catchError((e) {
      print(e);
    });
    DatabaseServices().addUserInfo(UserinApp.fromMap({
      'uid': userc.user.uid,
      'email': email.text.trim(),
      'password': pass.text.trim(),
      'phoneNumber': phone.text.trim(),
    }));
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
                top: g.height * 0.1,
              ),
              child: Form(
                key: _fkey,
                child: ListView(
                  children: [
                    TextFormField(
                      validator: (name) {
                        if (name.isEmpty) {
                          return "Name cannot be empty";
                        } else if (!isAlpha(name)) {
                          return "Invalid Name";
                        }
                        return null;
                      },
                      controller: name,
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
                        hintText: 'Name',
                        hintStyle: TextStyle(
                          fontFamily: 'Lucida Fax',
                          fontSize: 22,
                          color: Color(0xff707070),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: g.height * 0.02,
                    ),
                    TextFormField(
                      validator: (phone) {
                        if (phone.isEmpty) {
                          return "Mobile Number cannot be empty";
                        } else if (!isNumeric(phone) || phone.length != 10) {
                          return "Invalid Mobile Number";
                        }
                        return null;
                      },
                      controller: phone,
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
                        hintText: 'Mobile Number',
                        hintStyle: TextStyle(
                          fontFamily: 'Lucida Fax',
                          fontSize: 22,
                          color: Color(0xff707070),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: g.height * 0.02,
                    ),
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
                      height: g.height * 0.02,
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
                      height: g.height * 0.02,
                    ),
                    TextFormField(
                      validator: (password) {
                        if (password.isEmpty) {
                          return "Password field cannot be empty";
                        } else if (password != pass.text) {
                          return "Password does not match";
                        }
                        return null;
                      },
                      controller: pass2,
                      style: TextStyle(
                        fontFamily: 'Lucida Fax',
                        fontSize: 22,
                        color: Colors.black,
                      ),
                      maxLength: 36,
                      obscureText: ispass2,
                      decoration: InputDecoration(
                        counterText: '',
                        suffix: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: FaIcon(
                            ispass2
                                ? FontAwesomeIcons.solidEye
                                : FontAwesomeIcons.solidEyeSlash,
                          ),
                          onPressed: () {
                            setState(() {
                              ispass2 = !ispass2;
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
                        hintText: 'Repeat Password',
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
                        onPressed: () {
                          if (_fkey.currentState.validate()) {
                            phoneVerify();
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
                            'Register',
                            style: TextStyle(
                              fontFamily: 'Lucida Fax',
                              fontSize: 22,
                              color: Colors.deepPurple,
                            ),
                          )),
                        ),
                      ),
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
                      height: g.height * 0.02,
                    ),
                    Center(
                      child: RawMaterialButton(
                        splashColor: Colors.deepPurpleAccent.withOpacity(0.2),
                        onPressed: () {},
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
