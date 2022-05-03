import 'dart:convert';

import 'package:kadosh/modules/catalogue/entities/catalogue.dart';
import 'package:kadosh/modules/catalogue/entities/heroku_post.dart';

class HerokuCatalogue extends Catalogue {
  HerokuCatalogue(posts) : super(posts);

  factory HerokuCatalogue.fromMap(List<dynamic> map) {
    return HerokuCatalogue(
      List<HerokuPost>.from(
        (map).map<HerokuPost>(
          (x) => HerokuPost.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  factory HerokuCatalogue.fromJson(String source) =>
      HerokuCatalogue.fromMap(json.decode(source) as List<dynamic>);
}
