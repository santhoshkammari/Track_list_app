// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../main.dart';

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
//           child: Text('You have ${appState.favorites.length} favorites:'),
//         ),
//         for (var pair in appState.favorites)
//           ListTile(
//             leading: Icon(Icons.favorite),
//             title: Text(pair.asLowerCase),
//           ),
//         for (var trs in appState.transactions)
//           ListTile(
//             leading: Icon(Icons.money),
//             title: Text(trs.toString()),
//           ),
//       ],
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert'; // Add this import to decode JSON data

// class TaskList {
//   final String name;
//   final DateTime timestamp;

//   TaskList(this.name, this.timestamp);

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'timestamp': timestamp.millisecondsSinceEpoch,
//     };
//   }

//   factory TaskList.fromMap(Map<String, dynamic> map) {
//     return TaskList(
//       map['name'],
//       DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
//     );
//   }
// }

// class FavoritesPage extends StatefulWidget {
//   @override
//   _FavoritesPageState createState() => _FavoritesPageState();
// }

// class _FavoritesPageState extends State<FavoritesPage> {
//   TextEditingController _taskListNameController = TextEditingController();
//   List<TaskList> _taskLists = []; // Initialize the list here

//   @override
//   void initState() {
//     super.initState();
//     _loadTaskListsFromCache();
//   }

//   void _loadTaskListsFromCache() async {
//     WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String>? taskListStrings = prefs.getStringList('taskLists');

//     if (taskListStrings != null) {
//       setState(() {
//         _taskLists = taskListStrings
//             .map((taskListString) =>
//                 TaskList.fromMap(json.decode(taskListString)))
//             .toList();
//       });
//     }
//   }

//   void _saveTaskListsToCache() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> taskListStrings =
//         _taskLists.map((taskList) => json.encode(taskList.toMap())).toList();

//     prefs.setStringList('taskLists', taskListStrings);
//   }

//   void _addTaskList() {
//     String taskListName = _taskListNameController.text;
//     if (taskListName.isNotEmpty) {
//       setState(() {
//         _taskLists.add(TaskList(taskListName, DateTime.now()));
//       });

//       _saveTaskListsToCache();
//       _taskListNameController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Task Lists'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _taskListNameController,
//               decoration: InputDecoration(labelText: 'Task List Name'),
//             ),
//             ElevatedButton(
//               onPressed: _addTaskList,
//               child: Text('Add Task List'),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _taskLists.length,
//                 itemBuilder: (context, index) {
//                   TaskList taskList = _taskLists[index];
//                   return ListTile(
//                     title: Text(taskList.name),
//                     subtitle: Text(
//                       'Added on: ${taskList.timestamp.toLocal()}',
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Add this import to decode JSON data

class TaskList {
  final String name;
  final DateTime timestamp;

  TaskList(this.name, this.timestamp);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory TaskList.fromMap(Map<String, dynamic> map) {
    return TaskList(
      map['name'],
      DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }
}

ThemeData lightTheme = ThemeData(
  // primarySwatch: Colors.blue,
  brightness: Brightness.light,
);

ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.indigo,
  brightness: Brightness.dark,
);

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  TextEditingController _taskListNameController = TextEditingController();
  List<TaskList> _taskLists = []; // Initialize the list here
  bool isDarkMode = false; // Initially, set it to false (light mode)

  @override
  void initState() {
    super.initState();
    _loadTaskListsFromCache();
  }

  void _loadTaskListsFromCache() async {
    WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskListStrings = prefs.getStringList('taskLists');

    if (taskListStrings != null) {
      setState(() {
        _taskLists = taskListStrings
            .map((taskListString) =>
                TaskList.fromMap(json.decode(taskListString)))
            .toList();
      });
    }
  }

  void _saveTaskListsToCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskListStrings =
        _taskLists.map((taskList) => json.encode(taskList.toMap())).toList();

    prefs.setStringList('taskLists', taskListStrings);
  }

  void _addTaskList() {
    String taskListName = _taskListNameController.text;
    if (taskListName.isNotEmpty) {
      setState(() {
        _taskLists.add(TaskList(taskListName, DateTime.now()));
      });

      _saveTaskListsToCache();
      _taskListNameController.clear();
    }
  }

  void _handleTaskListNameSubmit(String value) {
    _addTaskList();
  }

  void _deleteTaskList(int index) {
    setState(() {
      _taskLists.removeAt(index);
    });

    _saveTaskListsToCache();
  }

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, Santhosh'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'You have ${_taskLists.length} tasks in your list.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            TextField(
              controller: _taskListNameController,
              decoration: InputDecoration(labelText: 'Task List Name'),
              onSubmitted: (value) {
                _addTaskList();
              }, // Call the handler when submitted
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _taskLists.length,
                itemBuilder: (context, index) {
                  TaskList taskList = _taskLists[index];
                  return ListTile(
                    title: Text(taskList.name),
                    subtitle: Text(
                      'Added on: ${taskList.timestamp.toLocal()}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteTaskList(index),
                    ),
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
