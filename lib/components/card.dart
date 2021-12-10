import 'dart:async';

import 'package:flutter/material.dart';
import 'package:puchlo/globals.dart' as g;
import 'package:puchlo/services/dbservices.dart';

class QueryTileCard extends StatefulWidget {
  const QueryTileCard({Key key, this.query}) : super(key: key);
  final Map query;

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
    var v = await DatabaseServices()
        .isLikedby(widget.query['username'], widget.query['queryid']);
    var u = await DatabaseServices()
        .isdislikedby(widget.query['username'], widget.query['queryid']);
    liked = v;
    disliked = u;
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
                              liked = false;
                            });
                            DatabaseServices().unlike(
                                widget.query['queryid'],
                                widget.query['type'],
                                widget.query['username'],
                                widget.query['likes']);
                          } else {
                            setState(() {
                              liked = true;
                              widget.query['likes']++;
                            });
                            if (disliked) {
                              setState(() {
                                widget.query['dislikes']--;
                                disliked = false;
                              });
                              DatabaseServices().undislike(
                                  widget.query['queryid'],
                                  widget.query['type'],
                                  widget.query['username'],
                                  widget.query['dislikes']);
                            }
                            DatabaseServices().like(
                                widget.query['queryid'],
                                widget.query['type'],
                                widget.query['username'],
                                widget.query['likes']);
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
                              disliked = false;
                            });
                            DatabaseServices().undislike(
                                widget.query['queryid'],
                                widget.query['type'],
                                widget.query['username'],
                                widget.query['dislikes']);
                          } else {
                            setState(() {
                              disliked = true;
                              widget.query['dislikes']++;
                            });
                            if (liked) {
                              setState(() {
                                widget.query['likes']--;
                                disliked = false;
                              });

                              DatabaseServices().unlike(
                                  widget.query['queryid'],
                                  widget.query['type'],
                                  widget.query['username'],
                                  widget.query['likes']);
                            }
                            DatabaseServices().dislike(
                                widget.query['queryid'],
                                widget.query['type'],
                                widget.query['username'],
                                widget.query['dislikes']);
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
