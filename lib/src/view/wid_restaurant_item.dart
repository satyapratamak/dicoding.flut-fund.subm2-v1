import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant_search_app_v1/src/model/mod_restaurant.dart';

import 'package:restaurant_search_app_v1/src/view/v_restaurant_detail.dart';

import 'package:restaurant_search_app_v1/style.dart';

class RestaurantItem extends StatelessWidget {
  final Restaurant restaurant;
  RestaurantItem(this.restaurant);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            //final snackBar = SnackBar(content: Text(restaurant.name));
            //Scaffold.of(context).showSnackBar(snackBar);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RestaurantDetailScreen(restaurant)),
            );
          },
          child: Row(
            children: [
              restaurant.thumbnail != null && restaurant.thumbnail.isNotEmpty
                  ? Ink(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: color_black_choclate,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            restaurant.thumbnail,
                          ),
                        ),
                      ),
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
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: color_orange_red,
                            size: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              restaurant.locality,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      RatingBarIndicator(
                        rating: double.parse(restaurant.rating),
                        itemBuilder: (_, __) {
                          return Icon(
                            Icons.star,
                            color: Colors.amber,
                          );
                        },
                        itemSize: 20,
                      ),
                      Text(
                        restaurant.rating,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
