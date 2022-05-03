import 'package:kadosh/modules/catalogue/entities/post.dart';

abstract class Repository {
  
  Future<List<Post>> getPosts();
  set page(page);
}
