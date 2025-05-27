import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:moonspace/helper/extensions/color.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/helper/stream/cached_stream.dart';
import 'package:moonspace/helper/stream/functions.dart';

class Sherlock extends StatefulWidget {
  const Sherlock({
    super.key,
  });

  @override
  State<Sherlock> createState() => _SherlockState();
}

class _SherlockState extends State<Sherlock> {
  late final StreamController<List<String>> data;
  late final StreamController<String> oldtext;
  late final SearchController searchController;
  late final StreamController<String> debounce;
  late final CachedStreamable<Set<String>> searchHistory;

  // Add this variable to track the last text value
  String _lastText = '';

  @override
  void initState() {
    searchController = SearchController();
    data = StreamController.broadcast();
    oldtext = StreamController.broadcast();
    searchHistory = CachedStreamable({});
    debounce = createDebounceFunc<String>(400, fetch);

    // print('Init');

    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    data.close();
    oldtext.close();
    searchHistory.close();
    debounce.close();

    // print('Dispose');

    super.dispose();
  }

  void fetch(String v) async {
    if (searchController.text != _lastText) {
      oldtext.add('');
      await 2.sec.delay();
      data.add(
        List.generate(100, (index) => math.Random().nextInt(200).toString()),
      );
      _lastText = searchController.text;
      oldtext.add(searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      searchController: searchController,
      isFullScreen: true,
      viewHintText: 'Hint',
      barHintText: 'Hint',
      viewConstraints: const BoxConstraints(maxHeight: 200),
      viewTrailing: [
        IconButton(
          onPressed: () async {
            Set<String> s = (searchHistory.value).toSet();
            s.add(searchController.text);
            searchHistory.value = s;
            debounce.add(searchController.text);
          },
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () async {
            searchController.text = '';
            debounce.add('');
          },
          icon: const Icon(Icons.cancel),
        ),
      ],
      suggestionsBuilder: (context, controller) {
        debounce.add(controller.text);

        return [
          SherlockBox(
            oldtext: oldtext,
            controller: searchController,
            searchHistory: searchHistory,
            data: data,
            debounce: debounce,
          ),
        ];
      },
    );
  }
}

class SherlockBox extends StatelessWidget {
  const SherlockBox({
    super.key,
    required this.oldtext,
    required this.searchHistory,
    required this.controller,
    required this.data,
    required this.debounce,
  });

  final StreamController<String> oldtext;
  final CachedStreamable<Set<String>> searchHistory;
  final TextEditingController controller;
  final StreamController<List<String>> data;
  final StreamController<String> debounce;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.mq.w,
      height: context.mq.h - 100,
      child: Column(
        children: [
          //
          StreamBuilder(
            stream: oldtext.stream,
            builder: (context, snapshot) {
              // return Text('${controller.text} : ${snapshot.data}');
              if (controller.text != snapshot.data) {
                return LinearProgressIndicator(
                  minHeight: 2,
                  color: HexColor.random(),
                );
              }
              return const SizedBox(height: 2);
            },
          ),

          //
          Container(
            width: context.mq.w,
            padding: const EdgeInsets.all(4),
            child: StreamBuilder(
              stream: searchHistory.stream,
              builder: (context, snapshot) {
                return Wrap(
                  runSpacing: 2,
                  spacing: 2,
                  children: snapshot.data
                          ?.map(
                            (e) => ChoiceChip(
                              selected: controller.text == e,
                              label: Text(e),
                              onSelected: (value) {
                                controller.text = e;
                                controller.selection = TextSelection.collapsed(
                                  offset: e.length,
                                );
                                debounce.add(controller.text);
                              },
                            ),
                          )
                          .toList() ??
                      [],
                );
              },
            ),
          ),

          StreamBuilder(
            stream: data.stream,
            builder: (context, snapshot) {
              return Expanded(
                // child: ListView.builder(
                //   clipBehavior: Clip.antiAlias,
                //   itemCount: snapshot.data?.length,
                //   itemBuilder: (con, index) => Card(
                //     child: ListTile(
                //       tileColor: HexColor.random(),
                //       title: Text(snapshot.data?[index] ?? ''),
                //       onTap: () {},
                //     ),
                //   ),
                // ),
                child: GridView.count(
                  crossAxisCount: 2,
                  children: [
                    Container(
                      color: Colors.blue,
                    ),
                    Container(
                      color: Colors.red,
                    ),
                    Container(
                      color: Colors.green,
                    ),
                    Container(
                      color: Colors.yellow,
                    ),
                    Container(
                      color: Colors.blue,
                    ),
                    Container(
                      color: Colors.red,
                    ),
                    Container(
                      color: Colors.green,
                    ),
                    Container(
                      color: Colors.yellow,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
