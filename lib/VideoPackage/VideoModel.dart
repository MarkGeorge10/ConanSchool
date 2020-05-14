class Video {
  final String url;
  final String title;
  final String thumbnailUrl;
  final List<dynamic> categoriesIds;

  Video({this.url, this.title, this.thumbnailUrl, this.categoriesIds});

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        url: json['url'],
        title: json['title'],
        thumbnailUrl: json['thumbnail_url'],
        categoriesIds: json['categories_ids'],
      );
}
