class Quiz{
  List<Question>questions = [];
  Quiz.fromJson(Map<String, dynamic> parsedJson)
  {
    List<Question> temp =[];
    for (var i = 0; i < parsedJson['questions'].length; i++) {
        Question question = Question(parsedJson["questions"][i]);
        temp.add(question);
    }

    questions = temp;
  }

}
class Question{
  String q;
  String a;
  String b;
  String c;
  String d;



  Question(question)
  {
      this.q = question["q"];
      this.a = question["a"];
      this.b = question["b"];
      this.c = question["c"];
      this.d = question["d"];
  }


}