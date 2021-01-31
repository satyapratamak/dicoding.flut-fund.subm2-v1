import 'package:flutter/material.dart';
import 'package:restaurant_search_app_v1/src/model/mod_restaurant.dart';
//import 'package:restaurant_search_app_v1/src/model/mod_restaurant.dart';
import 'package:restaurant_search_app_v1/style.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final Restaurant restaurant;

  RestaurantDetailScreen(this.restaurant);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurant Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              restaurant.thumbnail != null && restaurant.thumbnail.isNotEmpty
                  ? Image.network(
                      restaurant.thumbnail,
                    )
                  : Container(
                      height: 100,
                      width: 100,
                      color: color_black_choclate,
                      child: Icon(
                        Icons.restaurant,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  restaurant.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: color_black_choclate,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
