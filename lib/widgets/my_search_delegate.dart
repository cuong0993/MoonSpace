import 'package:flutter/material.dart';

class MySearchDelegate extends SearchDelegate {
  List<String> searchRes = [
    'Earth',
    'Sun',
    'Saturn',
    'Mercury',
    'Moon',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          }
          query = '';
        },
      ),
      IconButton(
        icon: const Icon(Icons.translate),
        onPressed: () {},
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(child: Text(query));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> res = searchRes.where((e) {
      return e.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 300,
            width: 300,
            color: Colors.red,
          ),
        ),
        Expanded(
          flex: 1,
          child: ListView.builder(
            itemBuilder: (context, i) {
              return ListTile(
                title: Text(res[i]),
                onTap: () {
                  query = res[i];

                  showResults(context);
                },
              );
            },
            itemCount: res.length,
          ),
        ),
      ],
    );
  }
}
