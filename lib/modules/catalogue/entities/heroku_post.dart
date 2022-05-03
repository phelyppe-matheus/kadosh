import 'package:kadosh/modules/catalogue/entities/post.dart';

class HerokuPost extends Post {
  HerokuPost(DateTime date, String title, List<String> imageUrlList)
      : super(date, title, imageUrlList);

  factory HerokuPost.fromMap(Map<String, dynamic> map) {
    return HerokuPost(
      DateTime.parse(map['date']),
      map['title'] as String,
      List<String>.from(
        (map['imageUrlPath'] as List<dynamic>),
      ),
    );
  }
}
