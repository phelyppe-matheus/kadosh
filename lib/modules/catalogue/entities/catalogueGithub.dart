import 'dart:convert';

import 'package:kadosh/modules/catalogue/entities/catalogue.dart';
import 'package:kadosh/modules/catalogue/entities/post.dart';

class CatalogueGithub implements Catalogue {
  List<Post> _posts;
  String? _uri;

  CatalogueGithub(this._posts);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'posts': _posts.map((x) => x.toMap()).toList(),
    };
  }

  factory CatalogueGithub.fromMap(List<dynamic> map) {
    return CatalogueGithub(
      List<Post>.from(
        (map).map<Post>(
          (x) => Post.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CatalogueGithub.fromJson(String source) =>
      CatalogueGithub.fromMap(json.decode(source) as List<dynamic>);

  set uri(String uri) => _uri = uri;

  get posts => _posts;
}
