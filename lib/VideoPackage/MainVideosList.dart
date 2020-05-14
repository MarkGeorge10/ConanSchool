import 'package:flutter/material.dart';
import 'package:conanschool/VideoPackage/VideoModel.dart';

class MainVideosList extends StatefulWidget {
  MainVideosList({Key key}) : super(key: key);

  @override
  _MainVideosListState createState() => _MainVideosListState();
}

class _MainVideosListState extends State<MainVideosList> {
  Future<List<Video>> videos;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
      ),
      body: ListView.builder(itemBuilder: null),
    );
  }
}
