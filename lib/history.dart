import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:witchy_diary/appstate.dart';
import 'package:witchy_diary/home.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.filter});
  final Function filter;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> _tagFilters = [];
  String keywordSearch = "";

  @override
  void initState() {
    super.initState();
  }

  void _onSearchChanged(String text) {
    setState(() => keywordSearch = text);
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var entries = appState.entries.where((m) => widget.filter(m)).toList();

    if (entries.isEmpty) {
      return Center(child: Text('No notes yet.'));
    }
    if (_tagFilters.isNotEmpty) {
      entries = entries
          .where((m) => _tagFilters.any((element) => m.tags.contains(element)))
          .toList();
    }
    if (keywordSearch != "") {
      entries = entries.where((m) => m.text.contains(keywordSearch)).toList();
    }

    return ListView(
      children: [
        // fix fucked up search bar pls
        SearchAnchor(
          builder: (BuildContext context, SearchController searchController) {
            return SearchBar(
              controller: searchController,
              padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onTap: () {
                searchController.openView();
              },
              leading: const Icon(Icons.search),
            );
          },
          viewOnChanged: _onSearchChanged,
          suggestionsBuilder:
              (BuildContext context, SearchController controller) {
                return [
                      ListTile(
                        title: Text('search: $keywordSearch'),
                        onTap: () {
                          setState(() {
                            controller.closeView(keywordSearch);
                          });
                        },
                      ),
                    ] +
                    List<ListTile>.generate(appState.allTags.length, (
                      int index,
                    ) {
                      final String item = appState.allTags[index].text;
                      return ListTile(
                        title: FilterChip(
                          label: Text('#$item'),
                          selected: _tagFilters.contains(item),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _tagFilters.add(item);
                              } else {
                                _tagFilters.remove(item);
                              }
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            _tagFilters.add(item);
                            controller.closeView(item);
                          });
                        },
                      );
                    });
              },
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'You have '
            '${entries.length} notes:',
          ),
        ),
        for (var entry in entries)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            constraints: BoxConstraints(
              minWidth: 100,
              maxWidth: 200,
              minHeight: 50,
              maxHeight: 150,
            ),
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.star),
                      color: entry.isStarred() ? Colors.amber : Colors.blueGrey,
                      onPressed: () => appState.toggleStar(entry),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => HomePage(entry: entry),
                        ),
                      ),
                    ),
                    Text(DateFormat('dd-MM-yyyy – HH:mm').format(entry.date)),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => appState.deleteEntry(entry),
                    ),
                  ],
                ),
                Text(entry.text, overflow: TextOverflow.ellipsis, maxLines: 5),
                Wrap(
                  spacing: 8.0,
                  children: entry.tags.map((tag) {
                    return FilterChip(
                      label: Text('#$tag'),
                      selected: _tagFilters.contains(tag),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _tagFilters.add(tag);
                          } else {
                            _tagFilters.remove(tag);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
