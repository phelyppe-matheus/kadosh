import 'package:http/http.dart' as http;

import 'package:kadosh/modules/catalogue/entities/catalogue.dart';
import 'package:kadosh/modules/catalogue/entities/post.dart';
import 'package:kadosh/modules/catalogue/errors/errors.dart';
import 'package:kadosh/modules/catalogue/repositories/repositories.dart';

class JsonServerRepository implements Repository {
  final String uri = "http://localhost:3000";
  final int _limit;
  int? _page;

  JsonServerRepository(this._limit, [this._page]);

  @override
  Future<List<Post>> getPosts() async {
    var url = "$uri/catalogue?_page=$_page&_limit=$_limit";
    final source = await http.get(Uri.parse(url));

    if (source.statusCode == 200) {
      Catalogue catalogue = Catalogue.fromJson(source.body)..uri = uri;

      return catalogue.posts;
    } else {
      throw FailedGithubCatch();
    }
  }

  @override
  set page(page) => _page = page;
}
