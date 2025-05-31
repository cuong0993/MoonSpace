import 'package:flutter/material.dart';
import 'package:moonspace/controller/sync_scroll_controller.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SyncListViewsPage());
  }
}

/// A page with two side-by-side synchronized list views
class SyncListViewsPage extends StatelessWidget {
  const SyncListViewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final syncController = SyncScrollController();

    return Scaffold(
      appBar: AppBar(title: const Text('Synchronized ListViews')),
      body: Row(
        children: [
          // Left ListView
          Expanded(
            child: ListView.builder(
              controller: syncController,
              itemCount: 50,
              itemBuilder: (context, index) => ListTile(
                tileColor: index.isEven ? Colors.grey[200] : null,
                title: Text('Left item $index'),
              ),
            ),
          ),
          // Right ListView
          Expanded(
            child: ListView.builder(
              controller: syncController,
              itemCount: 50,
              itemBuilder: (context, index) => ListTile(
                tileColor: index.isEven ? Colors.grey[100] : null,
                title: Text('Right item $index'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
