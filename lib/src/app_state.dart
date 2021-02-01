import 'package:restaurant_search_app_v1/src/model/mod_search_options.dart';
import 'package:restaurant_search_app_v1/src/api.dart';

class AppState {
  final SearchOptions searchOptions = SearchOptions(
    location: zLocations.first,
    order: zOrder.first,
    sort: zSort.first,
    count: zMaxCount,
  );
}
