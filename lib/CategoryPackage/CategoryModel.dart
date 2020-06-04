class Category {
  final String id;
  final String title;
  final String thumbnailUrl;

  Category({this.id, this.title, this.thumbnailUrl});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        title: json['title'],
        thumbnailUrl: json['thumbnail'],
      );
}
