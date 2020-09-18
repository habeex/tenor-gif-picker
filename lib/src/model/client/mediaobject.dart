class MediaObject {
  final String preview;
  final String url;
  final List dimensions;
  final int size;

  MediaObject({this.preview, this.url, this.dimensions, this.size});
  factory MediaObject.fromJson(Map<String, dynamic> json) =>
      MediaObject(preview: json["preview"], url: json["url"], dimensions: json["dims"], size: json["size"]);
}
