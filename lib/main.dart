import 'package:flutter/material.dart';
import 'package:kadosh/pages/catalogue_page.dart';

void main() => runApp(
      MaterialApp(
        routes: {
          "/": (context) => const CataloguePage(),
        },
      ),
    );
