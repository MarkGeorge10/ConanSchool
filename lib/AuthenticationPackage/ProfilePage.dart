import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // get uid
  Future<String> getCurrentUid() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  // get current user
  Future getCurrentUser() async {
    return await _firebaseAuth.currentUser();
  }

  //get dataUser

  bool readOnly = true;

  File _image;
  String fileName;

   Future getImage() async{
     var selectedImage=await ImagePicker.pickImage(source: ImageSource.gallery);
     setState(() {
       _image=selectedImage;
       fileName=path.basename(_image.path);
     });

   }


   Future <String>uploadPic()async{
     StorageReference ref=FirebaseStorage.instance.ref().child(fileName);
     StorageUploadTask uploadTask=ref.putFile(_image);
     var downloadUrl = await(await uploadTask.onComplete ).ref.getDownloadURL();
      var url=downloadUrl.toString();
     print("download url $url");
     setState(() {
       Scaffold.of(context)
           .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
     });

     return url;
   }


 

 

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerAge = TextEditingController();

  updateUserInfo(String ID) {
    Firestore.instance.collection('Profile').document(ID).updateData({
      'name':controllerName.text,
      'email':controllerEmail.text,
      'password':controllerPassword.text,
      'phone':controllerPhone.text,
      'age':controllerAge.text,
      'imageUrl':uploadPic(),
    }).then((value) {
      print('record updated successflly');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('Profile').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Text('Loading');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return new ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _sizedbox(20.0),
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Color(0xff476cfb),
                          child: ClipOval(
                            child: new SizedBox(
                              width: 140.0,
                              height: 140.0,
                              child: (_image!= null)
                                  ? Image.file(
                                      _image,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.network(
                                      document['imageUrl'],fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.camera,
                            size: 30.0,
                          ),
                          onPressed: () {
                            getImage();
                          },
                        ),
                      ),
                      _dataUser("User Name", "  ${document['name']} ", 10.0,
                          controllerName),
                      _dataUser(
                          "E-mail", document['email'], 10.0, controllerEmail),
                      _dataUser("Password", document['password'], 10.0,
                          controllerPassword),
                      _dataUser("Phone Number", document['phone'], 10.0,
                          controllerPhone),
                      _dataUser("Age", document['age'], 10.0, controllerAge),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            color: Color(0xff476cfb),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            elevation: 4.0,
                            splashColor: Colors.blueGrey,
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                          RaisedButton(
                            color: Color(0xff476cfb),
                            onPressed: () {
                              uploadPic;
                              updateUserInfo(getCurrentUid().toString());
                            },
                            elevation: 4.0,
                            splashColor: Colors.blueGrey,
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                      _sizedbox(20.0),
                    ],
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }

  Widget _dataUser(
      String title, String text, double _left, TextEditingController _text) {
    final _formkey = GlobalKey<FormState>();
    return Container(
      padding: EdgeInsets.only(left: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 90.0,
            child: Stack(
              alignment: Alignment.topLeft,
              children: <Widget>[
                Text(title,
                    style: TextStyle(color: Colors.blueGrey, fontSize: 18.0)),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 110,
            padding: EdgeInsets.only(top: 20, left: _left),
            child: Form(
              key: _formkey,
              child: TextFormField(
                controller: controllerName,
                autofocus: true,
                readOnly: readOnly,
                decoration: InputDecoration(
                  hintText: text,
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  suffixIcon: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.pen,
                      ),
                      iconSize: 25.0,
                      color: Color(0xff476cfb),
                      onPressed: () {
                        setState(() {
                          readOnly = false;
                        });
                      }),
                  border: InputBorder.none,
                ),
                cursorColor: Colors.black87,
                maxLines: 1,
                textAlign: TextAlign.left,
                textInputAction: TextInputAction.done,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sizedbox(double _height) {
    return SizedBox(
      height: _height,
    );
  }
}
