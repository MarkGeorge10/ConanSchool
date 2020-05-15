import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conanschool/HomePackage/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;

class ProfilePage extends StatefulWidget {
  File file;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _email, _password;
  bool readOnly = true;

  File _image;

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        //print('Image Path $_image');
      });
    }

    //for upload image in firebaase
    FirebaseStorage _storage =
        FirebaseStorage(storageBucket: 'gs://conan-school.appspot.com');

    Future uploadPic(BuildContext context) async {
      String fileName = path.basename(_image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      setState(() {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Profile Picture is Updated')));
      });
    }

    return Scaffold(
      body: Builder(
        builder: (context) => Container(
            child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Color(0xff476cfb),
                    child: ClipOval(
                      child: new SizedBox(
                        width: 140.0,
                        height: 140.0,
                        child: (_image != null)
                            ? Image.file(
                                _image,
                                fit: BoxFit.fill,
                              )
                            : Image.network(
                                "$_image",
                                fit: BoxFit.fill,
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
              ],
            ),
            _dataUser("User Name", "Samuel Gamil", 10.0),
            _dataUser("E-mail", "samuelgamil693@gmail.com", 10.0),
            _dataUser("Password", "vrbrfbrb", 10.0),
            _dataUser("Phone Number", "+201211840139", 10.0),
            _dataUser("Age", "21", 10.0),
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
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
                RaisedButton(
                  color: Color(0xff476cfb),
                  onPressed: () {
                    uploadPic(context);
                  },
                  elevation: 4.0,
                  splashColor: Colors.blueGrey,
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ],
            ),
            _sizedbox(15.0),
          ],
        )),
      ),
    );
  }

  Widget _dataUser(String title, String text, double _left) {
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
              child: TextFormField(
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
                validator: (val) {},
                onSaved: (val) {},
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
