import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:conanschool/VideoPackage/VideoModel.dart';

class MainVideosList extends StatefulWidget {
  MainVideosList({Key key, this.categoryId}) : super(key: key);
  final categoryId;

  @override
  _MainVideosListState createState() => _MainVideosListState();
}

class _MainVideosListState extends State<MainVideosList> {
  Future<List<Video>> videos;

  @override
  void initState() {
    videos = getVideosData(widget.categoryId);
    super.initState();
  }

  Future<List<Video>> getVideosData(String categoryId) async {
    List<Video> videos = [];
    List<String> videoIds = [];
    try {
      QuerySnapshot snapshot = await Firestore.instance
          .collection('category-videos')
          .where('categoryId', isEqualTo: categoryId)
          .getDocuments();
      snapshot.documents.forEach((element) {
        videoIds.add(element.data['videoId']);
      });
      QuerySnapshot videosSnapshot = await Firestore.instance
          .collection('videos')
          .where('id', whereIn: videoIds)
          .getDocuments();
      videosSnapshot.documents.forEach((element) {
        videos.add(Video.fromJson(element.data));
      });
    } catch (e) {
      print(e);
    }

    return videos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
      ),
      body: FutureBuilder(
        future: videos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
            List<Video> videos = snapshot.data;
            return ListView.builder(
              itemCount: videos.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemBuilder: (context, index) => Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        videos[index].thumbnailUrl,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(videos[index].title)
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData && snapshot.data.isEmpty) {
            return Center(
              child: Text('No videos found'),
            );
          } else {
            return Center(child: Text('Sorry, Something went wrong!'));
          }
        },
      ),
    );
  }
}
