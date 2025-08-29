import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:witchy_diary/appstate.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.filter});
  final Function filter;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> _tagFilters = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var entries = appState.entries.where((m) => widget.filter(m)).toList();

    if (entries.isEmpty) {
      return Center(child: Text('No notes yet.'));
    }

    return ListView(
      children: [
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
                      label: Text(tag),
                      selected: _tagFilters.contains(tag),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _tagFilters.add(tag);
                          } else {
                            _tagFilters.remove(tag);
                          }
                          if (_tagFilters.isNotEmpty) {
                            entries = entries
                                .where(
                                  (m) => _tagFilters.any(
                                    (element) => m.tags.contains(element),
                                  ),
                                )
                                .toList();
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
