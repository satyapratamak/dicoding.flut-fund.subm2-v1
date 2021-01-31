import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:restaurant_search_app_v1/src/model/mod_category.dart';
import 'package:restaurant_search_app_v1/src/model/mod_search_options.dart';
import 'package:restaurant_search_app_v1/style.dart';

class SearchFilters extends StatefulWidget {
  final locations = ['city', 'subzone', 'zone', 'landmark', 'metro', 'group'];
  final sort = ['cost', 'rating'];
  final order = ['asc', 'desc'];
  final double count = 20; // result of ZOMATO API

  final Function(SearchOptions filters) onSetFilters;

  final Dio dio;

  SearchFilters({this.onSetFilters, this.dio});
  @override
  _SearchFiltersState createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters> {
  List<Category> _categories;
  SearchOptions _searchOptions;
  //List<int> _selectedCategoris = [];

  Future<List<Category>> getCategories() async {
    final response = await widget.dio.get('categories');
    final data = response.data['categories'];
    return data
        .map<Category>((json) => Category(
              json['categories']['id'],
              json['categories']['name'],
            ))
        .toList();
  }

  void initState() {
    super.initState();

    //setState(() {
    _searchOptions = SearchOptions(
      location: widget.locations.first,
      sort: widget.sort.first,
      count: widget.count,
      order: widget.order.first,
    );
    //});

    getCategories().then((categories) {
      setState(() {
        _categories = categories;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter your search'),
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
                  _categories is List<Category>
                      ? Wrap(
                          spacing: 10,
                          children: List<Widget>.generate(_categories.length,
                              (index) {
                            final category = _categories[index];
                            final isSelected =
                                _searchOptions.categories.contains(category.id);
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
                                      ? _searchOptions.categories
                                          .add(category.id)
                                      : _searchOptions.categories
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
                    value: _searchOptions.location,
                    items: widget.locations.map<DropdownMenuItem<String>>(
                      (value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        _searchOptions.location = value;
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
                  for (int idx = 0; idx < widget.order.length; idx++)
                    RadioListTile(
                        title: Text(widget.order[idx]),
                        value: widget.order[idx],
                        groupValue: _searchOptions.order,
                        onChanged: (selection) {
                          setState(() {
                            _searchOptions.order = selection;
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
                    children: widget.sort.map<ChoiceChip>((sort) {
                      return ChoiceChip(
                        label: Text(sort),
                        selected: _searchOptions.sort == sort,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _searchOptions.sort = sort;
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
                    value: _searchOptions.count ?? 5,
                    min: 5,
                    label: _searchOptions.count?.toString(),
                    max: widget.count,
                    divisions: 3,
                    onChanged: (value) {
                      setState(() {
                        _searchOptions.count = value;
                        widget.onSetFilters(_searchOptions);
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
