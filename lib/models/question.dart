class Question {
  String id;
  String question;
  String username;
  String category;
  int answers;
  int likes;
  int dislikes;

  Question.fromMap(Map map) {
    this.id = map["id"];
    this.question = map["question"];
    this.username = map["username"];
    this.answers = map["answers"];
    this.category = map["category"];
    this.likes = map["likes"];
    this.dislikes = map["dislikes"];
  }
}
