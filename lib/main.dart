import 'dart:convert';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:io';

// void main() {
//   runApp(MyApp());
// }

// class NavigatorKey {
//   static final GlobalKey<NavigatorState> navigatorKey =
//       GlobalKey<NavigatorState>();
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => MyAppState(),
//       child: MaterialApp(
//         title: 'Namer App',
//         navigatorKey: NavigatorKey.navigatorKey,
//         theme: ThemeData(
//           useMaterial3: true,
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
//         ),
//         home: MyHomePage(),
//       ),
//     );
//   }
// }

// class MyAppState extends ChangeNotifier {
//   var current = WordPair.random();
//   void getNext() {
//     current = WordPair.random();
//     notifyListeners();
//   }

//   var favorites = <WordPair>[];

//   void toggleFavorite() {
//     if (favorites.contains(current)) {
//       favorites.remove(current);
//     } else {
//       favorites.add(current);
//     }
//     notifyListeners();
//   }
// }

// // ...
//

// class MyHomePage extends StatefulWidget {
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   var selectedIndex = 0; // ← Add this property.

//   @override
//   Widget build(BuildContext context) {
//     Widget page;
//     switch (selectedIndex) {
//       case 0:
//         page = GeneratorPage();
//         break;
//       case 1:
//         page = FavoritesPage();
//         break;
//       default:
//         throw UnimplementedError('no widget for $selectedIndex');
//     }
//     return LayoutBuilder(builder: (context, constraints) {
//       return Scaffold(
//         body: Row(
//           children: [
//             SafeArea(
//               child: NavigationRail(
//                 extended: constraints.maxWidth >= 600, // ← Here.
//                 destinations: [
//                   NavigationRailDestination(
//                     icon: Icon(Icons.home),
//                     label: Text('Home'),
//                   ),
//                   NavigationRailDestination(
//                     icon: Icon(Icons.favorite),
//                     label: Text('Favorites'),
//                   ),
//                 ],
//                 selectedIndex: selectedIndex, // ← Change to this.
//                 onDestinationSelected: (value) {
//                   setState(() {
//                     selectedIndex = value;
//                   });
//                 },
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 color: Theme.of(context).colorScheme.primaryContainer,
//                 child: page,
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }

// class GeneratorPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     var pair = appState.current;

//     IconData icon;
//     if (appState.favorites.contains(pair)) {
//       icon = Icons.favorite;
//     } else {
//       icon = Icons.favorite_border;
//     }

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           BigCard(pair: pair),
//           SizedBox(height: 10),
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: () {
//                   appState.toggleFavorite();
//                 },
//                 icon: Icon(icon),
//                 label: Text('Like'),
//               ),
//               SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   appState.getNext();
//                 },
//                 child: Text('Next'),
//               ),
//               SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   _uploadCSV(context);
//                 },
//                 child: Text('Upload CSV'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _uploadCSV(BuildContext context) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['csv'],
//     );

//     if (result != null && result.files.isNotEmpty) {
//       PlatformFile file = result.files.first;

//       if (file.extension == 'csv') {
//         String csvFilePath = file.path!;

//         // Use the csvFilePath for further processing, such as reading the CSV file contents.
//         // You can use the csv package to parse the CSV file.
//         List<List<dynamic>> csvData = await File(csvFilePath)
//             .openRead()
//             .transform(utf8.decoder)
//             .transform(CsvToListConverter())
//             .toList();

//         if (csvData.isNotEmpty) {
//           displayCSVData(csvData);
//         }
//       }
//     }
//   }

//   void displayCSVData(List<List<dynamic>> csvData) {
//     List<String> headers = csvData[0].map((cell) => cell.toString()).toList();
//     List<List<String>> rows = [];
//     for (int i = 1; i < csvData.length; i++) {
//       List<String> row = csvData[i].map((cell) => cell.toString()).toList();
//       rows.add(row);
//     }

//     showDialog(
//       context: NavigatorKey.navigatorKey.currentState!.overlay!.context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('CSV Data'),
//           content: SingleChildScrollView(
//             child: DataTable(
//               columns: headers
//                   .map((header) => DataColumn(label: Text(header)))
//                   .toList(),
//               rows: rows
//                   .map((row) => DataRow(
//                       cells: row.map((cell) => DataCell(Text(cell))).toList()))
//                   .toList(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// // ...
// class BigCard extends StatelessWidget {
//   const BigCard({
//     super.key,
//     required this.pair,
//   });

//   final WordPair pair;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context); // ← Add this.
//     final style = theme.textTheme.displayMedium!.copyWith(
//       color: theme.colorScheme.onPrimary,
//     );
//     return Card(
//       color: theme.colorScheme.primary, // ← And also this.

//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Text(pair.asLowerCase, style: style),
//       ),
//     );
//   }
// }

// // ...

// class FavoritesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();

//     if (appState.favorites.isEmpty) {
//       return Center(
//         child: Text('No favorites yet.'),
//       );
//     }

//     return ListView(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: Text('You have '
//               '${appState.favorites.length} favorites:'),
//         ),
//         for (var pair in appState.favorites)
//           ListTile(
//             leading: Icon(Icons.favorite),
//             title: Text(pair.asLowerCase),
//           ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:async' show Future;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:file_picker/file_picker.dart';

class CSVScreen extends StatefulWidget {
  @override
  _CSVScreenState createState() => _CSVScreenState();
}

class _CSVScreenState extends State<CSVScreen> {
  List<List<dynamic>> data = [];

  Future<void> loadCSV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      Uint8List bytes = await result.files.first.bytes!;
      String csvData = String.fromCharCodes(bytes);
      List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData);
      setState(() {
        data = csvTable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSV Data'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: loadCSV,
              child: Text('Upload CSV'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(data[index].join(', ')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CSVScreen(),
  ));
}
