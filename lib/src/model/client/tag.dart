class Tag {
  final String searchterm;
  final String path;
  final String image;
  final String name;

  Tag({this.searchterm, this.path, this.image, this.name});

  factory Tag.fromJson(Map<String, dynamic> json) =>
      Tag(searchterm: json["searchterm"], path: json["path"], image: json["image"], name: json["name"]);
}
