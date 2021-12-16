import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:puchlo/globals.dart' as g;
import 'package:puchlo/models/user.dart';
import 'package:puchlo/services/dbservices.dart';
import 'package:file_picker/file_picker.dart';
import 'package:puchlo/services/storage.dart';
import 'package:string_validator/string_validator.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({Key key, this.user}) : super(key: key);
  final UserinApp user;
  @override
  _ProfilepageState createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  TextEditingController bio = TextEditingController(text: "");
  TextEditingController phone = TextEditingController(text: "");
  TextEditingController date = TextEditingController(text: "");
  TextEditingController month = TextEditingController(text: "");
  TextEditingController year = TextEditingController(text: "");
  final Storage storage = Storage();
  bool isEditBio = false;
  bool isEditPhone = false;
  bool isEditDate = false;
  bool isEditMonth = false;
  bool isEditYear = false;
  String url;
  Timer t;

  @override
  void initState() {
    t = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        DatabaseServices().isfileexist(g.userinApp.uid).then((value) {
          if (value.isNotEmpty) {
            FirebaseStorage.instance
                .ref(g.userinApp.uid)
                .getDownloadURL()
                .then((value) {
              setState(() {
                url = value;
              });
            });
          }
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    t.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          primary: true,
          title: Text(
            'My Profile',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          backgroundColor:
              Colors.deepPurple.withOpacity(0.7).withBlue(255).withRed(50),
        ),
        body: Container(
          height: g.height,
          width: g.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blueAccent.withOpacity(0.8),
                  Colors.blueAccent.withOpacity(0.2),
                ]),
          ),
          child: Stack(
            children: [
              ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: g.width * 0.05, vertical: g.height * 0.05),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: g.width * g.height * 0.00022,
                          backgroundImage: NetworkImage(url != null
                              ? url
                              : 'https://st.depositphotos.com/1779253/5140/v/950/depositphotos_51405259-stock-illustration-male-avatar-profile-picture-use.jpg'),
                        ),
                        SizedBox(
                          height: g.height * 0.025,
                        ),
                        Text(
                          widget.user.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          widget.user.password == "******"
                              ? "Google user: " + widget.user.email
                              : "Phone Authenticated user: " +
                                  widget.user.phoneNumber,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: g.height * 0.045,
                        ),
                        Row(
                          children: [
                            Text(
                              "Phone Number",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        isEditPhone
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: g.width * 0.6,
                                    child: TextField(
                                      controller: phone,
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  IconButton(
                                      icon: FaIcon(FontAwesomeIcons.arrowRight),
                                      onPressed: () async {
                                        if (phone.text.isNotEmpty &&
                                            isNumeric(phone.text.trim()) &&
                                            phone.text.trim().length == 10) {
                                          setState(() {
                                            widget.user.phoneNumber =
                                                phone.text.trim();
                                          });
                                          await DatabaseServices().addphone(
                                              widget.user.uid,
                                              widget.user.phoneNumber);
                                        }
                                        setState(() {
                                          isEditPhone = false;
                                        });
                                      })
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.user.phoneNumber != null
                                      ? widget.user.phoneNumber
                                      : ""),
                                  IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        phone.text =
                                            widget.user.phoneNumber == null
                                                ? ""
                                                : widget.user.phoneNumber;
                                        setState(() {
                                          isEditPhone = true;
                                        });
                                      })
                                ],
                              ),
                        SizedBox(
                          height: g.height * 0.045,
                        ),
                        Row(
                          children: [
                            Text(
                              "My Date of Birth",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: g.height * 0.1,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              isEditDate
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: g.width * 0.2,
                                          child: TextField(
                                            controller: date,
                                            decoration: InputDecoration(
                                                border: InputBorder.none),
                                          ),
                                        ),
                                        IconButton(
                                            icon: FaIcon(
                                                FontAwesomeIcons.arrowRight),
                                            onPressed: () async {
                                              if (date.text.isNotEmpty &&
                                                  isNumeric(date.text.trim()) &&
                                                  date.text.trim().length <=
                                                      2 &&
                                                  int.parse(date.text.trim()) <=
                                                      31) {
                                                setState(() {
                                                  widget.user.date = int.parse(
                                                      date.text.trim());
                                                });
                                                await DatabaseServices().adddob(
                                                    widget.user.uid,
                                                    widget.user.date,
                                                    widget.user.month,
                                                    widget.user.year);
                                              }
                                              setState(() {
                                                isEditDate = false;
                                              });
                                            })
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(widget.user.date != null
                                            ? widget.user.date.toString()
                                            : "DD"),
                                        IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              date.text = widget.user.date !=
                                                      null
                                                  ? widget.user.date.toString()
                                                  : "";
                                              setState(() {
                                                isEditDate = true;
                                              });
                                            })
                                      ],
                                    ),
                              isEditMonth
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: g.width * 0.2,
                                          child: TextField(
                                            controller: month,
                                            decoration: InputDecoration(
                                                border: InputBorder.none),
                                          ),
                                        ),
                                        IconButton(
                                            icon: FaIcon(
                                                FontAwesomeIcons.arrowRight),
                                            onPressed: () async {
                                              if (month.text.isNotEmpty &&
                                                  isNumeric(
                                                      month.text.trim()) &&
                                                  month.text.trim().length <=
                                                      2 &&
                                                  int.parse(
                                                          month.text.trim()) <=
                                                      12) {
                                                setState(() {
                                                  widget.user.month = int.parse(
                                                      month.text.trim());
                                                });
                                                await DatabaseServices().adddob(
                                                    widget.user.uid,
                                                    widget.user.date,
                                                    widget.user.month,
                                                    widget.user.year);
                                              }
                                              setState(() {
                                                isEditMonth = false;
                                              });
                                            })
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(widget.user.month != null
                                            ? widget.user.month.toString()
                                            : "MM"),
                                        IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              phone.text = widget.user.month !=
                                                      null
                                                  ? widget.user.month.toString()
                                                  : "";
                                              setState(() {
                                                isEditMonth = true;
                                              });
                                            })
                                      ],
                                    ),
                              isEditYear
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: g.width * 0.2,
                                          child: TextField(
                                            controller: year,
                                            decoration: InputDecoration(
                                                border: InputBorder.none),
                                          ),
                                        ),
                                        IconButton(
                                            icon: FaIcon(
                                                FontAwesomeIcons.arrowRight),
                                            onPressed: () async {
                                              if (year.text.isNotEmpty &&
                                                  isNumeric(year.text.trim()) &&
                                                  year.text.trim().length ==
                                                      4) {
                                                setState(() {
                                                  widget.user.year = int.parse(
                                                      year.text.trim());
                                                });
                                                await DatabaseServices().adddob(
                                                    widget.user.uid,
                                                    widget.user.date,
                                                    widget.user.month,
                                                    widget.user.year);
                                              }
                                              setState(() {
                                                isEditYear = false;
                                              });
                                            })
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(widget.user.year != null
                                            ? widget.user.year.toString()
                                            : "YYYY"),
                                        IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              year.text = widget.user.year !=
                                                      null
                                                  ? widget.user.year.toString()
                                                  : "";
                                              setState(() {
                                                isEditYear = true;
                                              });
                                            })
                                      ],
                                    ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: g.height * 0.045,
                        ),
                        Row(
                          children: [
                            Text(
                              "My Bio",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        isEditBio
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: g.width * 0.6,
                                    child: TextField(
                                      controller: bio,
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  IconButton(
                                      icon: FaIcon(FontAwesomeIcons.arrowRight),
                                      onPressed: () async {
                                        if (bio.text.isNotEmpty) {
                                          setState(() {
                                            widget.user.bio = bio.text.trim();
                                          });
                                          await DatabaseServices().addbio(
                                              widget.user.uid, widget.user.bio);
                                        }
                                        setState(() {
                                          isEditBio = false;
                                        });
                                      })
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.user.bio != null
                                      ? widget.user.bio
                                      : ""),
                                  IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        bio.text = widget.user.bio;
                                        setState(() {
                                          isEditBio = true;
                                        });
                                      })
                                ],
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: g.width * g.height * 0.00042,
                right: g.width * 0.33,
                child: FloatingActionButton(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      allowCompression: false,
                      allowMultiple: false,
                      allowedExtensions: ["png", "jpg", "jpeg"],
                      type: FileType.custom,
                    );

                    if (result == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("No file selected"),
                        ),
                      );
                      return;
                    }
                    final path = result.files.single.path;
                    final name = widget.user.uid;

                    storage.uploadfile(name, path).then((value) {
                      print("done");
                    });
                    setState(() {});
                  },
                  mini: true,
                  backgroundColor: Colors.deepPurple
                      .withOpacity(0.7)
                      .withBlue(255)
                      .withRed(50),
                  child: Icon(Icons.switch_camera_outlined),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
