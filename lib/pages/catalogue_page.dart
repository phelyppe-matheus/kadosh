import 'dart:math';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:kadosh/modules/catalogue/entities/post.dart';

class CataloguePageArgs {
  final Post post;
  int indexOnFocus;

  CataloguePageArgs(this.post, [this.indexOnFocus = -1]);
}

class CataloguePage extends StatefulWidget {
  const CataloguePage({Key? key}) : super(key: key);

  static const routeName = '/catalogue';

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  CataloguePageArgs? _args;

  @override
  Widget build(BuildContext context) {
    _args ??= ModalRoute.of(context)!.settings.arguments as CataloguePageArgs;

    return Scaffold(
      appBar: AppBar(
        title: Text(_args!.post.title),
        backgroundColor: const Color(0xFFFEBCF7),
      ),
      body: Column(
        children: [
          _postTitle(_args!.post),
          _onFocusImage(_args!.post, _args!.indexOnFocus),
          _imageRows(_args!.post),
        ],
      ),
    );
  }

  Widget _onFocusImage(Post post, int onFocus) {
    if (onFocus > -1) {
      return Expanded(
        flex: 2,
        child: OutlinedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.zero,
            ),
          ),
          onPressed: () => setState(() {
            _args!.indexOnFocus = -1;
          }),
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: FancyShimmerImage(imageUrl: post.imageUrlList[onFocus]),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _imageRows(Post post) {
    return Expanded(
      flex: 3,
      child: ListView.builder(
        itemCount: post.imageUrlList.length ~/ 3,
        itemBuilder: (context, rowIndex) => AspectRatio(
          aspectRatio: 3 / 1,
          child: Row(
            children: List<Expanded>.generate(
              min(3, post.imageUrlList.length - rowIndex * 3),
              (colIndex) {
                int index = rowIndex * 3 + colIndex;
                return Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(4),
                      ),
                    ),
                    onPressed: () =>
                        setState(() => _args!.indexOnFocus = index),
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: FancyShimmerImage(
                        imageUrl: post.imageUrlList[index],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  _postTitle(Post post) {
    return Text(post.title);
  }
}
