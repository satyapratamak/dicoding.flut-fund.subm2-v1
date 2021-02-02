import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_search_app_v1/src/api.dart';
import 'package:restaurant_search_app_v1/src/app_state.dart';
import 'package:restaurant_search_app_v1/src/model/mod_restaurant.dart';

import 'package:restaurant_search_app_v1/src/view/v_search_filters.dart';
import 'package:restaurant_search_app_v1/src/view/v_search_form.dart';
import 'package:restaurant_search_app_v1/src/view/wid_restaurant_item.dart';
import 'package:restaurant_search_app_v1/style.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query;

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<ZomatoAPI>(context);
    final state = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: color_tart_orange,
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, 'filters');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Icon(
                Icons.tune,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SearchForm(
              onSearch: (q) {
                setState(() {
                  query = q;
                });
              },
            ),
            query == null
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.black12,
                          size: 110,
                        ),
                        Text(
                          'No Results to display',
                          style: TextStyle(
                            color: Colors.black12,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  )
                : FutureBuilder(
                    future: api.searchRestaurants(query, state.searchOptions),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView(
                            children: snapshot.data
                                .map<Widget>(
                                    (json) => RestaurantItem(Restaurant(json)))
                                .toList(),
                          ),
                        );
                      }

                      return Text(
                          'Error retrieving results: ${snapshot.error}');
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
