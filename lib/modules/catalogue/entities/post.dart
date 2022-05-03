// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Post {
  final DateTime date;
  final String title;
  List<String> imageUrlList;

  Post(this.date, this.title, this.imageUrlList);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date.toString(),
      'title': title,
      'imageUrlList': imageUrlList,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    print(map);
    return Post(
      DateTime.parse(map['date']),
      map['title'] as String,
      List<String>.from(
        (map['imageUrlList'] as List<dynamic>),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) =>
      Post.fromMap(json.decode(source) as Map<String, dynamic>);
}
