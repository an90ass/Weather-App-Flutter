import 'package:flutter/material.dart';
import 'package:weather_app/pages/home_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Weather App',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _search,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter City Name',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_search.text.isEmpty) {
                // Show error box if search is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a city name'),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(_search),
                  ),
                );

                if (result != null && result == 'City not found') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('City not found'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue.shade400,
            ),
            child: const Text(
              'Search',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
