import 'package:flutter/material.dart';
import 'package:restaurant_search_app_v1/src/client.dart';
import 'package:restaurant_search_app_v1/src/view/v_search_page.dart';

class RestaurantSearchApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SearchPage(
        title: 'Restaurant App',
        dio: dio,
      ),
    );
  }
}
