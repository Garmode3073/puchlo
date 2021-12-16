import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:puchlo/components/card.dart';
import 'package:puchlo/globals.dart' as g;
import 'package:puchlo/models/replies.dart';
import 'package:puchlo/services/dbservices.dart';

class RepliesScreeen extends StatefulWidget {
  const RepliesScreeen({Key key, this.question, this.answer}) : super(key: key);
  final Map question;
  final Map answer;

  @override
  _RepliesScreeenState createState() => _RepliesScreeenState();
}

class _RepliesScreeenState extends State<RepliesScreeen> {
  TextEditingController question = TextEditingController(text: '');
  Timer t;
  List<Reply> replies = [];
  String filt = "ld";

  @override
  void initState() {
    t = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
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

  Future getquest() async {
    replies =
        await DatabaseServices().getReplies(widget.answer["queryid"], filt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        primary: true,
        title: Row(
          children: [
            Text(
              'Replies',
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
        child: ListView(
          children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Text(
                    'Question',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: QueryTileCard(
                    query: widget.question,
                    surfable: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Text(
                    'Answer',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: QueryTileCard(
                    query: widget.answer,
                    surfable: true,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                  child: Text(
                    'Replies',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ] +
              List<Widget>.generate(
                replies.length,
                (i) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: QueryTileCard(
                    query: {
                      "username": replies[i].username,
                      "query": replies[i].reply,
                      "likes": replies[i].likes,
                      "dislikes": replies[i].dislikes,
                      "type": "Replies",
                      "queryid": replies[i].id,
                      'ld': 0,
                      'datetime': DateTime.now(),
                    },
                    surfable: true,
                  ),
                ),
              ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    backgroundColor: Colors.white.withOpacity(0.2),
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
                              hintText: 'Add a Reply',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Color(0xff4000ff).withOpacity(0.55),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () async {
                            if (question.text != '') {
                              await DatabaseServices().addReply(
                                  Reply.fromMap({
                                    'username': g.userinApp.name,
                                    'reply': question.text.trim(),
                                    'questionid': widget.question["queryid"],
                                    'answerid': widget.answer["queryid"],
                                    'likes': 0,
                                    'dislikes': 0,
                                    'ld': 0,
                                    'datetime': DateTime.now(),
                                  }),
                                  0);
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
