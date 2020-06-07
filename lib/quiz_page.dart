import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  var radio = [-1, -1, -1, -1];
  int size;
  List<String>values =["0","0","0","0","0"] ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  void _showDialog(int score)
  {
    showDialog(
      context: context,
      builder: (BuildContext)
        {
          return AlertDialog(
            title: score == size ?Text("Congratulation"):Text("Try again"),
            content: score == size ?Text("You have passed the quiz"):Text("PLeas Try Hard"),
            actions: <Widget>[
              new FlatButton(onPressed:()=> Navigator.of(context).pop(), child: Text("OK"))
            ],

          );
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            List <String>answers ;
           Firestore.instance.collection('answers').document('quiz1').collection("ANSWERS").snapshots()
                .listen((data){
                print(data.documents.length);
                int counter = 0;
                for(int i = 0;i<data.documents.length;i++)
                  {
                    if(values[i] == data.documents[i]["answer"])
                        counter++;
                  }
                    _showDialog(counter);

//                print("Good $counter");
            });
          },
          child: Icon(Icons.arrow_forward_ios),
        ),
        appBar: AppBar(
          title: Text("Quiz"),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('quizzes')
                .document('quiz1')
                .collection("questions")
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container(
                padding: EdgeInsets.all(20),
                child: ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      int radios;
                      int counter = 0;
                      size = snapshot.data.documents.length;
                      return (Card(
                        child: ListTile(
                          title: Text("Q${index + 1}: ${snapshot.data
                              .documents[index]['q']}"),
                          subtitle: Column(
                            children: <Widget>[
                              RadioListTile(
                                value: counter + 1,
                                groupValue: radio[index],
                                onChanged: (newValue) {
                                  setState(() {
                                    radio[index] = newValue;
                                    print(radio[index]);
                                    values[index] =  snapshot.data.documents[index]['a'];

                                  });
                                },
                                title: Text(
                                    '${snapshot.data.documents[index]['a']}'),
                              ),
                              RadioListTile(
                                value: counter + 2,
                                groupValue: radio[index],
                                onChanged: (newValue) {
                                  setState(() {
                                    radio[index] = newValue;
                                    print(radio[index]);
                                    values[index] =  snapshot.data.documents[index]['b'];
                                  });
                                },
                                title: Text(
                                    '${snapshot.data.documents[index]['b']}'),
                              ),
                              RadioListTile(
                                value: counter + 3,
                                groupValue: radio[index],
                                onChanged: (newValue) {
                                  setState(() {
                                    radio[index] = newValue;
                                    print(radio[index]);
                                    values[index] =  snapshot.data.documents[index]['c'];
                                  });
                                },
                                title: Text(
                                    '${snapshot.data.documents[index]['c']}'),
                              ),
                              RadioListTile(
                                value: counter + 4,
                                groupValue: radio[index],
                                onChanged: (newValue) {
                                  setState(() {
                                    radio[index] = newValue;
                                    print(radio[index]);
                                    values[index] =  snapshot.data.documents[index]['d'];
                                  });
                                },
                                title: Text(
                                    '${snapshot.data.documents[index]['d']}'),
                              )
                            ],
                          ),
                        ),
                      ));
                    }),
              );
            }));
  }


}
