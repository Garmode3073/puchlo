import 'dart:async';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:puchlo/components/card.dart';
import 'package:puchlo/globals.dart' as g;
import 'package:puchlo/models/question.dart';
import 'package:puchlo/models/user.dart';
import 'package:puchlo/screens/loading.dart';
import 'package:puchlo/screens/profile.dart';
import 'package:puchlo/services/auth.dart';
import 'package:puchlo/services/dbservices.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String cat = 'All';
  List<Question> questions = [];
  TextEditingController question = TextEditingController(text: '');
  Timer t;
  String filt = "ld";
  String url;
  bool exists;

  @override
  void initState() {
    t = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        getData();

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

        getquest();
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    t.cancel();
  }

  Future getData() async {
    UserinApp user = await DatabaseServices().currentUser(g.userinApp.uid);
    g.userinApp = user;
  }

  Future getquest() async {
    questions = cat == "All"
        ? await DatabaseServices().getQuestions(filt)
        : await DatabaseServices().getCatQuestions(cat, filt);
  }

  @override
  Widget build(BuildContext context) {
    g.width = MediaQuery.of(context).size.width;
    g.height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        primary: true,
        title: Row(
          children: [
            Text(
              'Questions',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            Expanded(child: Container()),
            FloatingActionButton(
                backgroundColor: Colors.transparent,
                heroTag: filt == "ld" ? Text("Most asked") : Text("Latest"),
                elevation: 0,
                child: Icon(
                  filt == "ld"
                      ? FontAwesomeIcons.peopleArrows
                      : FontAwesomeIcons.calendar,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    filt == "ld" ? filt = "datetime" : filt = "ld";
                  });
                }),
          ],
        ),
        backgroundColor:
            Colors.deepPurple.withOpacity(0.7).withBlue(255).withRed(50),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blueAccent.withOpacity(0.8),
                      Colors.blueAccent.withOpacity(0.2),
                    ]),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(url != null
                    ? url
                    : 'https://st.depositphotos.com/1779253/5140/v/950/depositphotos_51405259-stock-illustration-male-avatar-profile-picture-use.jpg'),
              ),
              accountName: Text(
                g.userinApp.name == null ? "" : g.userinApp.name,
                style: TextStyle(color: Colors.deepPurple, fontSize: 20),
              ),
              accountEmail: Text(
                g.userinApp.email != null
                    ? g.userinApp.email
                    : g.userinApp.phoneNumber == null
                        ? ""
                        : g.userinApp.phoneNumber,
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
            ListTile(
              tileColor: Colors.blueAccent.withOpacity(0.35),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    PageTransition(
                        child: Profilepage(
                          user: g.userinApp,
                        ),
                        type: PageTransitionType.fade));
              },
              title: Text(
                "My Profile",
                style: TextStyle(
                  fontFamily: 'Lucida Fax',
                  fontSize: 18,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            Expanded(child: Container()),
            ListTile(
              tileColor: Colors.blueAccent.withOpacity(0.35),
              onTap: () async {
                AuthServices auth = AuthServices();
                await auth.signOut();
                g.userinApp = null;
              },
              title: Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'Lucida Fax',
                  fontSize: 18,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ],
        ),
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
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: g.height * 0.015,
              ),
              Container(
                width: g.width,
                height: g.height * 0.07,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List<Widget>.generate(
                    g.categories.length,
                    (i) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              cat = g.categories[i];
                            });
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(g.categories[i]),
                            ),
                          ),
                        ),
                        decoration: cat == g.categories[i]
                            ? BoxDecoration(
                                border: Border.all(
                                  color: Colors.deepPurple.withOpacity(0.2),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(7),
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.deepPurpleAccent.withOpacity(0.2),
                                      Colors.deepPurpleAccent.withOpacity(0.4),
                                    ]),
                              )
                            : BoxDecoration(
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(7),
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.05),
                                    ]),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: g.height * 0.015,
              ),
              Expanded(
                child: ListView(
                  children: List<Widget>.generate(
                    questions.length,
                    (i) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: QueryTileCard(
                        query: {
                          "cat": questions[i].category,
                          "username": questions[i].username,
                          "query": questions[i].question,
                          "likes": questions[i].likes,
                          "dislikes": questions[i].dislikes,
                          "type": "Questions",
                          "queryid": questions[i].id,
                          "ld": questions[i].ld,
                          "datetime": questions[i].datetime,
                        },
                        surfable: false,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                String category = "Politics";
                return StatefulBuilder(builder: (context, setState) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 6.0,
                      sigmaY: 6.0,
                    ),
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          width: 1.0,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      backgroundColor: Colors.white.withOpacity(0.25),
                      elevation: 17,
                      title: Text(
                        '',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      content: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: question,
                              cursorColor: Colors.white,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.35),
                                  fontSize: 18,
                                ),
                                hintText: 'Add a question',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Color(0xff4000ff).withOpacity(0.55),
                              ),
                            ),
                            SizedBox(
                              height: g.height * 0.035,
                            ),
                            DropdownButton<String>(
                              isExpanded: true,
                              value: category,
                              elevation: 16,
                              hint: Text('Class'),
                              onChanged: (String newValue) {
                                setState(() {
                                  category = newValue;
                                });
                              },
                              items: g.categories2
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () async {
                              if (question.text != '') {
                                await DatabaseServices()
                                    .addQuestion(Question.fromMap({
                                  'username': g.userinApp.name,
                                  'question': question.text.trim(),
                                  'answers': 0,
                                  'category': category,
                                  'likes': 0,
                                  'dislikes': 0,
                                  'ld': 0,
                                  'datetime': DateTime.now(),
                                }));
                                print('done');
                                question.clear();
                                setState(() {});
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              'Add',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ))
                      ],
                    ),
                  );
                });
              });
        },
        backgroundColor:
            Colors.deepPurple.withOpacity(0.7).withBlue(255).withRed(50),
        child: Icon(Icons.add),
      ),
    );
  }
}
