import 'package:flutter/material.dart';
import 'package:restaurant_search_app_v1/src/app_restaurant_search.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:provider/provider.dart';
import 'package:restaurant_search_app_v1/src/app_state.dart';
import 'package:restaurant_search_app_v1/src/api.dart';

/*void main() async {
  await DotEnv.load(fileName: '.env');
  runApp(RestaurantSearchApp());
}*/

void main() async {
  await DotEnv.load(fileName: '.env');

  final api = ZomatoAPI(DotEnv.env['ZOMATO_API_KEY']);
  await api.loadCategories();
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => api,
        ),
        Provider(
          create: (context) => AppState(),
        ),
      ],
      child: RestaurantSearchApp(),
    ),
  );
}
