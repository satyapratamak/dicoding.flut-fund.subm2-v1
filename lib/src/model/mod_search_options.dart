import 'package:flutter/material.dart';

class SearchOptions {
  String location;
  String order;
  String sort;
  double count;
  List<int> categories = [];

  SearchOptions({
    this.location,
    this.order,
    this.sort,
    this.count,
  });

  Map<String, dynamic> toJson() => {
        'entity_type': location,
        'sort': sort,
        'count': count,
        'order': order,
        'category': categories.join(','),
      };
}
