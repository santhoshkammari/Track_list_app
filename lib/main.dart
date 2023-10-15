import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components_san/favorites.dart';
import 'components_san/generate_page.dart';
import 'components_san/walletmain.dart';
import 'components/progress_bar/progress_bar.dart';

void main() {
  runApp(const MyApp());
}

class NavigatorKey {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        navigatorKey: NavigatorKey.navigatorKey,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  WordPair current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  List<WordPair> favorites = <WordPair>[];
  List transactions = [];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  void addTransaction(value) {
    transactions.add(value);
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        // page = ProgressBared(
        //   trackName: 'sample',
        //   progressValue: 10,
        //   onIncrement: () {},
        // );
        page = FuturisticTextInputScreen();

      case 1:
        page = FavoritesPage();

      case 2:
        page = WalletMain();
      case 3:
        page = GeneratorPage();

      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      // ignore: use_colored_box
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.art_track),
              label: 'Progress',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'list',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.thumb_down_off_alt_rounded),
              label: 'List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: selectedIndex,
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          selectedItemColor: Colors.deepOrange, // Set the selected item color
          unselectedItemColor: Colors.grey, // Set the unselected item color
          backgroundColor:
              Color.fromARGB(255, 251, 250, 247), // Set the background color
          elevation: 10, // Set the shadow elevation
          type: BottomNavigationBarType.fixed),
    );
  }
}
