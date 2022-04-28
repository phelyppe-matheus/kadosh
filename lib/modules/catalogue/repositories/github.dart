// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:kadosh/modules/catalogue/entities/catalogue.dart';
import 'package:kadosh/modules/catalogue/entities/post.dart';
import 'package:kadosh/modules/catalogue/errors/errors.dart';
import 'package:kadosh/modules/catalogue/repositories/repositories.dart';

class GithubPostsRepository implements Repository {
  final String uri =
      "https://raw.githubusercontent.com/phelyppe-matheus/kadosh_json/master";

  int _page;
  GithubPostsRepository(this._page);

  @override
  Future<List<Post>> getPosts() async {
    var url = "$uri/catalogue.json";
    final source = await http.get(Uri.parse(url));

    if (source.statusCode == 200) {
      Catalogue catalogue = Catalogue.fromJson(source.body);

      return catalogue.posts;
    } else {
      throw FailedGithubCatch();
    }
  }

  @override
  set page(page) => _page = page;
}
