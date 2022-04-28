import 'package:flutter_test/flutter_test.dart';
import 'package:kadosh/modules/catalogue/entities/post.dart';
import 'package:kadosh/modules/catalogue/repositories/json_server.dart';
import 'package:kadosh/modules/catalogue/repositories/repositories.dart';

void main() {
  const page = 1;
  const limit = 1;

  final Repository repository = JsonServerRepository(limit);

  test("Must Return a catalogue", () async {
    repository.page = page;
    expect(await repository.getPosts(), isA<List<Post>>());
  });

  test("Must return at least one catalogue from github", () async {
    repository.page = page;
    expect((await repository.getPosts()).length, lessThanOrEqualTo(limit));
  });

  test("Must return full link", () async {
    repository.page = page;
    expect((await repository.getPosts())[0].imageUrlList[0], contains('http'));
  });
}
