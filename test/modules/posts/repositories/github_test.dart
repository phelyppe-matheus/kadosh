import 'package:flutter_test/flutter_test.dart';
import 'package:kadosh/modules/catalogue/entities/post.dart';
import 'package:kadosh/modules/catalogue/repositories/github.dart';
import 'package:kadosh/modules/catalogue/repositories/repositories.dart';

void main() {
  Repository repository = GithubPostsRepository(1);

  test("Must Return a list of posts", () async {
    expect(await repository.getPosts(), isA<List<Post>>());
  });

  test("Must return at least one catalogue from github", () async {
    expect((await repository.getPosts()).length, greaterThan(0));
  });
}
