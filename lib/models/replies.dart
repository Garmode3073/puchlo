class Reply {
  String id;
  String reply;
  String username;
  String answerid;
  String questionid;
  int likes;
  int dislikes;

  Reply.fromMap(Map map) {
    this.id = map["id"];
    this.reply = map["reply"];
    this.username = map["username"];
    this.answerid = map["answerid"];
    this.questionid = map["questionid"];
    this.likes = map["likes"];
    this.dislikes = map["dislikes"];
  }
}
