import 'package:flutter/material.dart';
import 'package:restaurant_search_app_v1/src/app_restaurant_search.dart';

import 'package:restaurant_search_app_v1/style.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() async {
  await DotEnv.load(fileName: '.env');
  runApp(RestaurantSearchApp());
}
