import 'package:flutter/material.dart';
import 'package:restaurant_search_app_v1/model/mod_restaurant.dart';
import 'package:restaurant_search_app_v1/style.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:dio/dio.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant_search_app_v1/view/v_restaurant_detail.dart';

void main() async {
  await DotEnv.load(fileName: '.env');
  runApp(RestaurantSearchApp());
}

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
      home: SearchPage(title: 'Restaurant App'),
    );
  }
}

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.title}) : super(key: key);

  final String title;

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://developers.zomato.com/api/v2.1/search',
      headers: {
        'user-key': DotEnv.env['ZOMATO_API_KEY'],
      },
    ),
  );

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query;

  Future<List> searchRestaurants(String query) async {
    final response = await widget.dio.get(
      '',
      queryParameters: {
        'q': query,
        //'sort': 'rating',
        //'order': 'desc',
      },
    );
    print(response);

    return response.data['restaurants'];
  }

  @override
  Widget build(BuildContext context) {
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchFilters(),
                ),
              );
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
                    future: searchRestaurants(query),
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

class SearchForm extends StatefulWidget {
  SearchForm({this.onSearch});

  //final void Functon(String search) onSearch;
  final void Function(String search) onSearch;
  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();
  var _autoValidateMode = AutovalidateMode.disabled;
  var _search;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        autovalidateMode: _autoValidateMode,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                ),
                hintText: 'Enter Restaurant, Food, etc..',
                border: OutlineInputBorder(),
                filled: true,
                errorStyle: TextStyle(fontSize: 18),
              ),
              onChanged: (value) {
                _search = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter a search term..";
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              child: RawMaterialButton(
                onPressed: () {
                  final isValid = _formKey.currentState.validate();

                  if (isValid) {
                    // TODO Searching
                    setState(() {
                      _autoValidateMode = AutovalidateMode.disabled;
                    });
                    widget.onSearch(_search);
                    //Colapses keypad
                    FocusManager.instance.primaryFocus.unfocus();
                  } else {
                    // TODO set autovalidate = true
                    setState(() {
                      _autoValidateMode = AutovalidateMode.always;
                    });
                  }
                },
                fillColor: color_tart_orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "SEARCH",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchFilters extends StatefulWidget {
  @override
  _SearchFiltersState createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter your search'),
        backgroundColor: color_tart_orange,
      ),
      body: Text(
        'Filter your search',
      ),
    );
  }
}
