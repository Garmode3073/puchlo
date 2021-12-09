import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:puchlo/globals.dart' as g;
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class OtpScreen extends StatefulWidget {
  bool _isInit = true;
  final contact;

  OtpScreen({Key key, this.contact}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String phoneNo;
  String smsOTP;
  String otpgot;
  String verificationId;
  String errorMessage = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer _timer;

  //this is method is used to initialize data
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load data only once after screen load
    if (widget._isInit) {
      generateOtp(widget.contact);
      widget._isInit = false;
    }
  }

  //dispose controllers
  @override
  void dispose() {
    super.dispose();
  }

  //build method for UI
  @override
  Widget build(BuildContext context) {
    //Getting screen height width
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xff95c3ff),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  const Text(
                    'Verification',
                    style: TextStyle(fontSize: 28, color: Colors.black),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Text(
                    'Enter A 6 digit number that was sent to ${widget.contact}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: screenWidth * 0.025),
                          child: PinEntryTextField(
                            fields: 6,
                            onSubmit: (text) {
                              smsOTP = text as String;
                            },
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.04,
                        ),
                        GestureDetector(
                          onTap: () async {
                            verifyOtp();
                            // var y = await dbHelper.register(d.User.reg(
                            //     widget.contact.toString().substring(4),
                            //     g.getRandomString(10),
                            //     0));
                            // setState(() {
                            //   g.isload = false;
                            // });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            height: 45,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.deepPurple[400],
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(36),
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.deepPurpleAccent.withOpacity(0.2),
                                    Colors.deepPurpleAccent.withOpacity(0.8),
                                  ]),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Verify',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Method for generate otp from firebase
  Future<void> generateOtp(String contact) async {
    // setState(() {
    //   g.isload = true;
    // });
    // http.Response v =
    //     await http.post(g.urlotp, body: {'mobile': '+91$contact'});
    // otpgot = v.body;
    // print(otpgot);
    // setState(() {
    //   g.isload = true;
    // });
  }

  //Method for verify otp entered by user
  Future<void> verifyOtp() async {
    // if (smsOTP == null || smsOTP == '') {
    //   showAlertDialog(context, 'please enter 6 digit otp');
    //   return;
    // }
    // try {
    //   Navigator.pop(context);
    // } catch (e) {
    //   setState(() {
    //     g.isload = false;
    //   });
    // }
  }

  //Basic alert dialogue for alert errors and confirmations
  void showAlertDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
