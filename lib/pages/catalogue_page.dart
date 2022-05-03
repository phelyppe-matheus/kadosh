import 'dart:math';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as CataloguePageArgs;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.post.title),
      ),
      body: Column(
        children: [
          _onFocusImage(args.post, args.indexOnFocus),
          _imageRows(args.post),
        ],
      ),
    );
  }

  Widget _onFocusImage(Post post, int onFocus) {
    if (onFocus > -1) {
      return SizedBox(
        width: double.infinity,
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: ElevatedButton(
            onPressed: () {},
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: FancyShimmerImage(imageUrl: post.imageUrlList[onFocus]),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _imageRows(Post post) {
    return Expanded(child: Container());
  }
}
