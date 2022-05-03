import 'package:flutter/material.dart';
import 'package:kadosh/pages/catalogue_list_page.dart';
import 'package:kadosh/pages/catalogue_page.dart';

void main() => runApp(
      MaterialApp(
        routes: {
          CatalogueListPage.routeName: (context) => const CatalogueListPage(),
          CataloguePage.routeName: (context) => const CataloguePage()
        },
      ),
    );
