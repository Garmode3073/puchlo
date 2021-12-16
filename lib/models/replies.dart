class Reply {
  String id;
  String reply;
  String username;
  String answerid;
  String questionid;
  int likes;
  int dislikes;
  DateTime datetime;
  int ld;

  Reply.fromMap(Map map) {
    this.datetime = map["dateTime"];
    this.ld = map["ld"];
    this.id = map["id"];
    this.reply = map["reply"];
    this.username = map["username"];
    this.answerid = map["answerid"];
    this.questionid = map["questionid"];
    this.likes = map["likes"];
    this.dislikes = map["dislikes"];
  }
}
