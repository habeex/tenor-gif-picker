import 'package:tenor_picker/src/model/client/tag.dart';

class TenorCategories {
  final String locale;
  final List<Tag> tags;

  TenorCategories({this.locale, this.tags});

  factory TenorCategories.fromJson(Map<String, dynamic> json) => TenorCategories(
      locale: json["locale"],
      tags: (json["tags"] as List).map((e) => e == null ? null : Tag.fromJson(e as Map<String, dynamic>)));
}
