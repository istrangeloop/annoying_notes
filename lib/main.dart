import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:witchy_diary/appstate.dart';
import 'package:witchy_diary/home.dart';
import 'package:witchy_diary/history.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // constructor

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // every widget has a build method that
    // is called when state changes
    // every widget returns a widget tree, which is the description below of the UI
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.green),
        ),
        home: const AppWrapper(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key, required this.title});

  final String title;

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  // type of the widget name needed here

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = HomePage(entry: Entry("", DateTime(0), []));
      case 1:
        page = HistoryPage(filter: (m) => !m.isFuture());
      case 2:
        page = HistoryPage(filter: (m) => m.isFuture());
      case 3:
        page = HistoryPage(filter: (m) => m.isStarred());
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.history),
                      label: Text('History'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.task_alt),
                      label: Text('Future'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.star),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
