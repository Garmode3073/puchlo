class Answer {
  String id;
  String answer;
  String username;
  String questionid;
  int replies;
  int likes;
  int dislikes;

  Answer.fromMap(Map map) {
    this.id = map["id"];
    this.answer = map["answer"];
    this.username = map["username"];
    this.replies = map["replies"];
    this.questionid = map["questionid"];
    this.likes = map["likes"];
    this.dislikes = map["dislikes"];
  }
}
