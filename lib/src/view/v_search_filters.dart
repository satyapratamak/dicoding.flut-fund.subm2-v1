import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:restaurant_search_app_v1/src/app_state.dart';
import 'package:restaurant_search_app_v1/src/api.dart';
import 'package:restaurant_search_app_v1/src/model/mod_category.dart';
import 'package:restaurant_search_app_v1/src/model/mod_search_options.dart';
import 'package:restaurant_search_app_v1/style.dart';

import 'package:provider/provider.dart';

class SearchFilters extends StatefulWidget {
  @override
  _SearchFiltersState createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final api = Provider.of<ZomatoAPI>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter your search '),
        backgroundColor: color_tart_orange,
      ),
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Categories: ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  api.categories is List<Category>
                      ? Wrap(
                          spacing: 10,
                          children: List<Widget>.generate(api.categories.length,
                              (index) {
                            final category = api.categories[index];
                            final isSelected = state.searchOptions.categories
                                .contains(category.id);
                            return FilterChip(
                              label: Text(category.name),
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color,
                                fontWeight: FontWeight.bold,
                              ),
                              selected: isSelected,
                              selectedColor: color_tart_orange,
                              checkmarkColor: Colors.white,
                              onSelected: (bool selected) {
                                setState(() {
                                  selected
                                      ? state.searchOptions.categories
                                          .add(category.id)
                                      : state.searchOptions.categories
                                          .remove(category.id);
                                });
                              },
                            );
                          }),
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Location type:',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: state.searchOptions.location,
                    items: api.locations.map<DropdownMenuItem<String>>(
                      (value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        state.searchOptions.location = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Order by:',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  for (int idx = 0; idx < api.order.length; idx++)
                    RadioListTile(
                        title: Text(api.order[idx]),
                        value: api.order[idx],
                        groupValue: state.searchOptions.order,
                        onChanged: (selection) {
                          setState(() {
                            state.searchOptions.order = selection;
                          });
                        }),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Sort by:',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Wrap(
                    spacing: 10,
                    children: api.sort.map<ChoiceChip>((sort) {
                      return ChoiceChip(
                        label: Text(sort),
                        selected: state.searchOptions.sort == sort,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              state.searchOptions.sort = sort;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Number of result:',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Slider(
                    value: state.searchOptions.count ?? 5,
                    min: 5,
                    label: state.searchOptions.count?.toString(),
                    max: api.count,
                    divisions: 3,
                    onChanged: (value) {
                      setState(() {
                        state.searchOptions.count = value;
                      });
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
