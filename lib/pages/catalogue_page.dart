import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:kadosh/modules/catalogue/entities/catalogue.dart';
import 'package:kadosh/modules/catalogue/entities/post.dart';
import 'package:kadosh/modules/catalogue/repositories/json_server.dart';
import 'package:kadosh/modules/catalogue/repositories/repositories.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage({Key? key}) : super(key: key);

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  final int _limit = 2;
  late final Repository repository;
  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    repository = JsonServerRepository(_limit);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Something went wrong while fetching a new page.',
            ),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _pagingController.retryLastFailedRequest(),
            ),
          ),
        );
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("N.A Kadosh"),
        ),
        body: RefreshIndicator(
          onRefresh: () => Future.sync(
            () => _pagingController.refresh(),
          ),
          child: PagedListView<int, Post>.separated(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Post>(
              animateTransitions: true,
              itemBuilder: (context, post, index) => TextButton(
                onPressed: () {
                  SnackBar snackBar = SnackBar(
                    content: Text('Ce pressionou o post ${post.title}'),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: ListTile(
                  leading: Text((post.date.toIso8601String()).split('T')[0]),
                  title: Text(post.title),
                ),
              ),
            ),
            separatorBuilder: (context, index) => const Divider(),
          ),
        ));
  }

  Future<void> _fetchPage(pageKey) async {
    print('Get page $pageKey');
    repository.page = pageKey;
    final newItems = await repository.getPosts();
    final isLastPage = newItems.length < _limit;
    if (isLastPage) {
      _pagingController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + newItems.length;
      _pagingController.appendPage(newItems, nextPageKey);
    }
  }
}
