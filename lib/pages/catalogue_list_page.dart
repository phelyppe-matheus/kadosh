import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:kadosh/modules/catalogue/entities/post.dart';
import 'package:kadosh/modules/catalogue/repositories/heroku.dart';
import 'package:kadosh/modules/catalogue/repositories/repositories.dart';
import 'package:kadosh/pages/catalogue_page.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class CatalogueListPage extends StatefulWidget {
  const CatalogueListPage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<CatalogueListPage> createState() => _CatalogueListPageState();
}

class _CatalogueListPageState extends State<CatalogueListPage> {
  final int _limit = 2;
  late final Repository repository;
  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 0);

  final double imgBoxSize = 200.0;
  final double imgBoxPadd = 20;

  int _focusedIndex = 0;

  @override
  void initState() {
    repository = HerokuRepository(_limit);
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
        title: const Text("N.A KADOSH"),
        backgroundColor: Colors.pink,
        centerTitle: true,
      ),
      body: _cataloguePageBody,
      floatingActionButton: _floatingActionButton,
    );
  }

  Widget get _floatingActionButton => const Icon(Icons.abc);

  Widget get _cataloguePageBody {
    return _refreshingPostPagination;
  }

  Widget get _refreshingPostPagination {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: _pagedListView(),
    );
  }

  PagedListView<int, Post> _pagedListView() {
    return PagedListView<int, Post>(
      pagingController: _pagingController,
      builderDelegate: _pagedPostBuilder(),
    );
  }

  PagedChildBuilderDelegate<Post> _pagedPostBuilder() {
    return PagedChildBuilderDelegate<Post>(
      animateTransitions: true,
      itemBuilder: (context, post, index) => ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFFFFF)),
        ),
        onPressed: () {
          SnackBar snackBar = SnackBar(
            content: Text('Ce pressionou o post ${post.title}'),
          );

          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(snackBar);

          Navigator.pushNamed(
            context,
            CataloguePage.routeName,
            arguments: CataloguePageArgs(post, _focusedIndex),
          );
        },
        child: _postBuild(post),
      ),
    );
  }

  Widget _postBuild(Post post) {
    return Container(
      transform: Matrix4.translationValues(0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _postImageListBuild(post),
          _postTitleBuild(post),
        ],
      ),
    );
  }

  Widget _postImageListBuild(Post post) {
    return SizedBox(
      height: imgBoxSize + 2 * imgBoxPadd,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              Colors.pinkAccent,
              Colors.white,
            ],
          ),
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(imgBoxSize / 10),
          ),
        ),
        child: ScrollSnapList(
          padding: EdgeInsets.zero,
          onItemFocus: _onItemFocus,
          itemSize: imgBoxSize + 2 * imgBoxPadd,
          itemBuilder: (context, index) => _postImageBuild(index, post),
          itemCount: post.imageUrlList.length,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Widget _postImageBuild(int index, Post post) {
    return Container(
      padding: EdgeInsets.all(imgBoxPadd),
      child: SizedBox(
        width: imgBoxSize,
        child: FancyShimmerImage(
          imageUrl: post.imageUrlList[index],
        ),
      ),
    );
  }

  Widget _postTitleBuild(Post post) {
    const double textPadd = 4;
    const double fontSize = 25;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        textPadd * 2,
        textPadd,
        textPadd * 2,
        textPadd,
      ),
      transform: Matrix4.translationValues(
        40,
        -(imgBoxSize + imgBoxPadd + fontSize * 1.5),
        0,
      ),
      child: Text(
        post.title,
        style: const TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<void> _fetchPage(pageKey) async {
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

  void _onItemFocus(int index) => setState(() => _focusedIndex = index);
}
