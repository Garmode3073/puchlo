import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:puchlo/models/answer.dart';
import 'package:puchlo/models/question.dart';
import 'package:puchlo/models/replies.dart';
import 'package:puchlo/models/user.dart';
import 'package:puchlo/globals.dart' as g;

class DatabaseServices {
  String users = "users";

  //current user
  Future<UserinApp> currentUser(uid) async {
    Map data = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) => value.data());
    g.userinApp = UserinApp.fromMap(data);
    return g.userinApp;
  }

  //addphoto
  Future addFile(filepath) async {
    await FirebaseFirestore.instance
        .collection("docs")
        .doc(filepath)
        .set({"docid": filepath});
  }

  //photo exists
  Future<List> isfileexist(id) async {
    return await FirebaseFirestore.instance
        .collection("docs")
        .where("docid", isEqualTo: id)
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
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
              'phoneNumber': value.data()["phoneNumber"],
              'password': value.data()["password"],
              'bio': value.data()["bio"],
              'date': value.data()["date"],
              'month': value.data()["month"],
              'year': value.data()["year"],
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
      'password': user.password,
      'bio': user.bio,
      'date': user.date,
      'month': user.month,
      'year': user.year,
    });
  }

  //add bio
  Future addbio(userid, bio) async {
    await FirebaseFirestore.instance
        .collection(users)
        .doc(userid)
        .update({'bio': bio});
  }

  //add dob
  Future adddob(userid, date, month, year) async {
    await FirebaseFirestore.instance
        .collection(users)
        .doc(userid)
        .update({'date': date, 'month': month, 'year': year});
  }

  //add phone
  Future addphone(userid, phoneNumber) async {
    await FirebaseFirestore.instance
        .collection(users)
        .doc(userid)
        .update({'phoneNumber': phoneNumber});
  }

  //add question
  Future addQuestion(Question question) async {
    String id = g.getRandomString(20);
    await FirebaseFirestore.instance.collection("Questions").doc(id).set({
      'answers': question.answers,
      'id': id,
      'category': question.category,
      'datetime': DateTime.now(),
      'ld': question.likes - question.dislikes,
      'dislikes': question.dislikes,
      'likes': question.likes,
      'question': question.question,
      'username': question.username,
    });
  }

  //get all questions
  Future getQuestions(filt) async {
    return await FirebaseFirestore.instance
        .collection("Questions")
        .orderBy(filt, descending: true)
        .get()
        .then((value) => value.docs
            .map(
              (e) => Question.fromMap(e.data()),
            )
            .toList());
  }

  //get category questions
  Future getCatQuestions(String cat, String filt) async {
    return await FirebaseFirestore.instance
        .collection("Questions")
        .where('category', isEqualTo: cat)
        .orderBy(filt, descending: true)
        .get()
        .then((value) => value.docs
            .map(
              (e) => Question.fromMap(e.data()),
            )
            .toList());
  }

  //add answer
  Future addAnswer(Answer answer, int ans) async {
    String id = g.getRandomString(20);
    await FirebaseFirestore.instance
        .collection("Questions")
        .doc(answer.questionid)
        .update({"answers": ans});
    await FirebaseFirestore.instance.collection("Answers").doc(id).set({
      'replies': answer.replies,
      'id': id,
      'questionid': answer.questionid,
      'datetime': DateTime.now(),
      'ld': answer.likes - answer.dislikes,
      'dislikes': answer.dislikes,
      'likes': answer.likes,
      'answer': answer.answer,
      'username': answer.username,
    });
  }

  //get answers
  Future getAnswers(String questionid, String filt) async {
    return await FirebaseFirestore.instance
        .collection("Answers")
        .where("questionid", isEqualTo: questionid)
        .orderBy(filt, descending: true)
        .get()
        .then((value) =>
            value.docs.map((e) => Answer.fromMap(e.data())).toList());
  }

  //add replies
  Future addReply(Reply reply, int rep) async {
    String id = g.getRandomString(20);
    await FirebaseFirestore.instance
        .collection("Answers")
        .doc(reply.answerid)
        .update({"replies": rep});
    await FirebaseFirestore.instance.collection("Replies").doc(id).set({
      'id': id,
      'questionid': reply.questionid,
      'datetime': DateTime.now(),
      'ld': reply.likes - reply.dislikes,
      'answerid': reply.answerid,
      'dislikes': reply.dislikes,
      'likes': reply.likes,
      'reply': reply.reply,
      'username': reply.username,
    });
  }

  //get replies
  Future getReplies(String answerid, String filt) async {
    return await FirebaseFirestore.instance
        .collection("Replies")
        .where("answerid", isEqualTo: answerid)
        .orderBy(filt, descending: true)
        .get()
        .then(
            (value) => value.docs.map((e) => Reply.fromMap(e.data())).toList());
  }

  //like
  Future like(String queryid, String collection, String username, int likes,
      int ld) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(queryid)
        .update({'likes': likes, 'ld': ld});
    await FirebaseFirestore.instance
        .collection("Likes")
        .doc()
        .set({"queryid": queryid, "username": username}).then((value) {});
  }

  //dislike
  Future dislike(String queryid, String collection, String username,
      int dislikes, int ld) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(queryid)
        .update({'dislikes': dislikes, 'ld': ld});
    await FirebaseFirestore.instance
        .collection("Dislikes")
        .doc()
        .set({"queryid": queryid, "username": username});
  }

  //unlike
  Future unlike(String queryid, String collection, String username, int likes,
      int ld) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(queryid)
        .update({'likes': likes, 'ld': ld});
    await FirebaseFirestore.instance
        .collection("Likes")
        .where("queryid", isEqualTo: queryid)
        .where("username", isEqualTo: username)
        .get()
        .then((value) => value.docs.forEach((element) {
              FirebaseFirestore.instance
                  .collection("Likes")
                  .doc(element.id)
                  .delete();
            }));
  }

  //undislike
  Future undislike(String queryid, String collection, String username,
      int dislikes, int ld) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(queryid)
        .update({'dislikes': dislikes, 'ld': ld});
    await FirebaseFirestore.instance
        .collection("Dislikes")
        .where("queryid", isEqualTo: queryid)
        .where("username", isEqualTo: username)
        .get()
        .then((value) => value.docs.forEach((element) {
              FirebaseFirestore.instance
                  .collection("Dislikes")
                  .doc(element.id)
                  .delete();
            }));
  }

  Future isLikedby(String username, String queryid) async {
    var v = await FirebaseFirestore.instance
        .collection("Likes")
        .where("username", isEqualTo: username)
        .where("queryid", isEqualTo: queryid)
        .get();
    return v.docs.isNotEmpty;
  }

  Future isdislikedby(String username, String queryid) async {
    var v = await FirebaseFirestore.instance
        .collection("Dislikes")
        .where("username", isEqualTo: username)
        .where("queryid", isEqualTo: queryid)
        .get();
    return v.docs.isNotEmpty;
  }
}
