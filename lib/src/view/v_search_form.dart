import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restaurant_search_app_v1/style.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

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
  StreamSubscription<DataConnectionStatus> listener;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listener.cancel();
  }

  checkInternet() async {
    // Simple check to see if we have internet
    print("The statement 'this machine is connected to the Internet' is: ");
    print(await DataConnectionChecker().hasConnection);
    // returns a bool

    // We can also get an enum instead of a bool
    print("Current status: ${await DataConnectionChecker().connectionStatus}");
    // prints either DataConnectionStatus.connected
    // or DataConnectionStatus.disconnected

    // This returns the last results from the last call
    // to either hasConnection or connectionStatus
    print("Last results: ${DataConnectionChecker().lastTryResults}");

    // actively listen for status updates
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          print('Data connection is available.');
          break;
        case DataConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          break;
      }
    });

    return await DataConnectionChecker().connectionStatus;
  }

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
                onPressed: () async {
                  final isValid = _formKey.currentState.validate();

                  if (isValid) {
                    // TODO Searching
                    setState(() {
                      _autoValidateMode = AutovalidateMode.disabled;
                    });

                    DataConnectionStatus status = await checkInternet();

                    if (status == DataConnectionStatus.connected) {
                      widget.onSearch(_search);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("No Internet"),
                          content: Text("Check your Connection"),
                        ),
                      );
                    }

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
