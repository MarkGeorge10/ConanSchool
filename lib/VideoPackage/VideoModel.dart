class Video {
  final String id;
  final String url;
  final String title;
  final String thumbnailUrl;

  Video({this.id, this.url, this.title, this.thumbnailUrl});

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json['id'],
        url: json['url'],
        title: json['title'],
        thumbnailUrl: json['thumbnailUrl'],
      );
}
