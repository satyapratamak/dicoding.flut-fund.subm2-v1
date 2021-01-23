import 'package:flutter/material.dart';
import 'package:restaurant_search_app_v1/style.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:dio/dio.dart';

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
  List _restaurants;

  void searchRestaurants(String query) async {
    final response = await widget.dio.get(
      '',
      queryParameters: {
        'q': query,
      },
    );
    print(response);

    setState(() {
      _restaurants = response.data['restaurants'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        backgroundColor: color_tart_orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SearchForm(onSearch: searchRestaurants),
            _restaurants == null
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
                : Expanded(
                    child: ListView(
                      children: _restaurants.map((restaurant) {
                        return ListTile(
                          title: Text(restaurant['restaurant']['name']),
                          subtitle: Text(
                            restaurant['restaurant']['location']['address'],
                          ),
                          trailing: Text(
                              '${restaurant['restaurant']['user_rating']['aggregate_rating']} stars, ${restaurant['restaurant']['all_reviews_count']} reviews'),
                        );
                      }).toList(),
                    ),
                  ),
          ],
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
