import 'package:flutter/material.dart';

class Restaurant {
  final String id;
  final String locality;
  final String name;
  final String address;
  final String rating;
  final String reviews;
  final String thumbnail;

  Restaurant._({
    this.id,
    this.name,
    this.address,
    this.locality,
    this.rating,
    this.reviews,
    this.thumbnail,
  });

  factory Restaurant(Map json) => Restaurant._(
        id: json['restaurant']['id'],
        name: json['restaurant']['name'],
        address: json['restaurant']['location']['address'],
        locality: json['restaurant']['location']['locality'],
        rating:
            json['restaurant']['user_rating']['aggregate_rating']?.toString(),
        reviews: json['restaurant']['all_reviews_count']?.toString(),
        thumbnail:
            json['restaurant']['featured_image'] ?? json['restaurant']['thumb'],
      );
}
