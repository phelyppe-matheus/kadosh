import 'dart:convert';

import 'package:kadosh/modules/catalogue/entities/post.dart';

class Catalogue {
  List<Post> _posts;
  String? _uri;

  Catalogue(this._posts);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'posts': _posts.map((x) => x.toMap()).toList(),
    };
  }

  factory Catalogue.fromMap(List<dynamic> map) {
    return Catalogue(
      List<Post>.from(
        (map).map<Post>(
          (x) => Post.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Catalogue.fromJson(String source) =>
      Catalogue.fromMap(json.decode(source) as List<dynamic>);

  set uri(String uri) => _uri = uri;

  get posts => _uri != null
      ? List.generate(
          _posts.length,
          (index) => _posts[index]
            ..imageUrlList = _posts[index]
                .imageUrlList
                .map<String>((e) => _uri! + e)
                .toList())
      : _posts;
}
