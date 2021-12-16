import 'dart:async';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:puchlo/globals.dart' as g;
import 'package:puchlo/screens/answers.dart';
import 'package:puchlo/screens/replies.dart';
import 'package:puchlo/services/dbservices.dart';

class QueryTileCard extends StatefulWidget {
  const QueryTileCard({Key key, this.query, this.parent, this.surfable})
      : super(key: key);
  final Map query;
  final Map parent;
  final bool surfable;

  @override
  _QueryTileCardState createState() => _QueryTileCardState();
}

class _QueryTileCardState extends State<QueryTileCard> {
  Timer t;
  bool liked = false;
  bool disliked = false;
  @override
  void initState() {
    t = Timer.periodic(Duration(milliseconds: 500), (timer) {
      getLike().then((value) {
        setState(() {});
      });
    });

    super.initState();
  }

  Future getLike() async {
    try {
      var v = await DatabaseServices()
          .isLikedby(g.userinApp.name, widget.query['queryid']);
      var u = await DatabaseServices()
          .isdislikedby(g.userinApp.name, widget.query['queryid']);
      liked = v;
      disliked = u;
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    t.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.deepPurple.withOpacity(0.2),
      onTap: () async {
        if (widget.surfable) {
        } else if (widget.query["type"] == "Questions") {
          Navigator.push(
              context,
              PageTransition(
                  child: AnswerPage(
                    question: widget.query,
                  ),
                  type: PageTransitionType.fade));
        } else if (widget.query["type"] == "Answers") {
          Navigator.push(
              context,
              PageTransition(
                  child: RepliesScreeen(
                    question: widget.parent,
                    answer: widget.query,
                  ),
                  type: PageTransitionType.fade));
        }
      },
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.query['username'],
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.query['query'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                Row(
                  children: [
                    IconButton(
                        icon: liked
                            ? Icon(
                                Icons.thumb_up,
                                color: Colors.white,
                              )
                            : Icon(Icons.thumb_up_outlined),
                        onPressed: () async {
                          if (liked) {
                            setState(() {
                              widget.query['likes']--;
                              widget.query['ld']--;
                              liked = false;
                            });
                            DatabaseServices().unlike(
                              widget.query['queryid'],
                              widget.query['type'],
                              g.userinApp.name,
                              widget.query['likes'],
                              widget.query['ld'],
                            );
                          } else {
                            setState(() {
                              liked = true;
                              widget.query['likes']++;
                              widget.query['ld'] += 2;
                            });
                            if (disliked) {
                              setState(() {
                                widget.query['dislikes']--;
                                disliked = false;
                              });
                              DatabaseServices().undislike(
                                widget.query['queryid'],
                                widget.query['type'],
                                g.userinApp.name,
                                widget.query['dislikes'],
                                widget.query['ld'],
                              );
                            }
                            DatabaseServices().like(
                              widget.query['queryid'],
                              widget.query['type'],
                              g.userinApp.name,
                              widget.query['likes'],
                              widget.query['ld'],
                            );
                          }
                          setState(() {});
                        }),
                    Text(widget.query["likes"].toString()),
                  ],
                ),
                Expanded(child: Container()),
                Row(
                  children: [
                    IconButton(
                        icon: disliked
                            ? Icon(
                                Icons.thumb_down,
                                color: Colors.white,
                              )
                            : Icon(Icons.thumb_down_outlined),
                        onPressed: () {
                          if (disliked) {
                            setState(() {
                              widget.query['dislikes']--;
                              widget.query['ld']++;
                              disliked = false;
                            });
                            DatabaseServices().undislike(
                              widget.query['queryid'],
                              widget.query['type'],
                              g.userinApp.name,
                              widget.query['dislikes'],
                              widget.query['ld'],
                            );
                          } else {
                            setState(() {
                              disliked = true;
                              widget.query['dislikes']++;
                              widget.query['ld'] -= 2;
                            });
                            if (liked) {
                              setState(() {
                                widget.query['likes']--;
                                disliked = false;
                              });

                              DatabaseServices().unlike(
                                widget.query['queryid'],
                                widget.query['type'],
                                g.userinApp.name,
                                widget.query['likes'],
                                widget.query['ld'],
                              );
                            }
                            DatabaseServices().dislike(
                              widget.query['queryid'],
                              widget.query['type'],
                              g.userinApp.name,
                              widget.query['dislikes'],
                              widget.query['ld'],
                            );
                          }
                          setState(() {});
                        }),
                    Text(widget.query["dislikes"].toString()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
