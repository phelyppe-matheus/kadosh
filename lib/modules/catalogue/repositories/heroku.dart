import 'package:http/http.dart' as http;

import 'package:kadosh/modules/catalogue/entities/heroku_catalogue.dart';
import 'package:kadosh/modules/catalogue/entities/post.dart';
import 'package:kadosh/modules/catalogue/errors/errors.dart';
import 'package:kadosh/modules/catalogue/repositories/repositories.dart';

class HerokuRepository implements Repository {
  final String uri = "https://kadosh-json.herokuapp.com";
  // final String uri = "https://localhost:5000";
  final int _limit;
  int? _page;

  HerokuRepository(this._limit);

  @override
  Future<List<Post>> getPosts() async {
    var url = "$uri?page=$_page&limit=$_limit";
    final source = await http.get(Uri.parse(url));

    if (source.statusCode == 200) {
      HerokuCatalogue catalogue = HerokuCatalogue.fromJson(source.body)
        ..uri =
            "https://raw.githubusercontent.com/phelyppe-matheus/kadosh_json/master/";

      return catalogue.posts;
    } else {
      throw FailedGithubCatch();
    }
  }

  @override
  set page(page) => _page = page;
}
