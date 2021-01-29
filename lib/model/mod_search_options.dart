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
}
