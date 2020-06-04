import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conanschool/CategoryPackage/CategoryModel.dart';
import 'package:conanschool/VideoPackage/MainVideosList.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Future<List<Category>> categories;

  @override
  void initState() {
    categories = getCategoriesData();
    super.initState();
  }

  Future<List<Category>> getCategoriesData() async {
    List<Category> videos = [];
    try {
      QuerySnapshot snapshot =
          await Firestore.instance.collection('categories').getDocuments();
      snapshot.documents.forEach((element) {
        videos.add(Category.fromJson(element.data));
      });
    } catch (e) {
      print(e);
    }

    return videos;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: categories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
          List<Category> categories = snapshot.data;
          return ListView.separated(
            itemCount: categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            separatorBuilder: (context, index) => const SizedBox(
              height: 16,
            ),
            itemBuilder: (context, index) => ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            MainVideosList(categoryId: categories[index].id)));
                  },
                  trailing: Image.network(
                    categories[index].thumbnailUrl,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                  title: Text(categories[index].title)),
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
    );
  }
}
