import 'dart:ffi';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class Task {
//   String name;
//   int count;
//   double progress;

//   Task({required this.name, required this.count, this.progress = 0});
// }
class Task {
  Task({required this.name, required this.count, this.progress = 0});

  Task.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String;
    count = json['count'] as int;
    progress = json['progress'] as double;
  }
  late String name;
  late int count;
  late double progress;

  // String name;
  // int count;
  // double progress;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'count': count,
      'progress': progress,
    };
  }
}

class FuturisticTextInputScreen extends StatefulWidget {
  @override
  _FuturisticTextInputScreenState createState() =>
      _FuturisticTextInputScreenState();
}

class _FuturisticTextInputScreenState extends State<FuturisticTextInputScreen> {
  String _inputText = '';
  double _progressValue = 0;
  TextEditingController _trackNameController = TextEditingController();
  TextEditingController _countController = TextEditingController();
  List<Task> _taskList = [];

  @override
  void initState() {
    super.initState();
    _loadTaskList(); // Load the task list when the widget is created.
  }

  // Load the task list from shared preferences.
  // void _loadTaskList() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> taskListJson = prefs.getStringList('task_list') ?? [];
  //   setState(() {
  //     _taskList =
  //         taskListJson.map((taskJson) => Task.fromJson(taskJson)).toList();
  //   });
  // }
  void _loadTaskList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskListJson = prefs.getStringList('task_list') ?? [];
    setState(() {
      _taskList = taskListJson.map((taskJson) {
        // Convert the taskJson string to a Map<String, dynamic> using jsonDecode
        Map<String, dynamic> taskMap =
            jsonDecode(taskJson) as Map<String, dynamic>;
        return Task.fromJson(taskMap);
      }).toList();
    });
  }

  // Save the task list to shared preferences.
  // void _saveTaskList() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> taskListJson =
  //       _taskList.map((task) => task.toJson()).cast<String>().toList();
  //   prefs.setStringList('task_list', taskListJson);
  // }
  void _saveTaskList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskListJson =
        _taskList.map((task) => jsonEncode(task.toJson())).toList();
    prefs.setStringList('task_list', taskListJson);
  }

  void _incrementProgress(int index) {
    setState(() {
      if (_taskList[index].progress < _taskList[index].count) {
        _taskList[index].progress += 1;
        _saveTaskList(); // Save the updated task list when progress is incremented.
      }
    });
  }

  void _addTask() {
    String taskName = _trackNameController.text;
    int taskCount = int.tryParse(_countController.text) ?? 0;

    if (taskName.isNotEmpty && taskCount > 0) {
      setState(() {
        _taskList.add(Task(name: taskName, count: taskCount));
        _trackNameController.clear();
        _countController.clear();
        _saveTaskList(); // Save the updated task list when a new task is added.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, Santhosh'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
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
              'You have ${_taskList.length} tasks in your list.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _taskList.length,
                itemBuilder: (context, index) {
                  return _buildTaskWidget(index);
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showPopUp,
              child: Text('Task Popup'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskWidget(int index) {
    Task task = _taskList[index];
    return Card(
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${task.name}( ${task.progress} / ${task.count})',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => _removeTask(index),
                  child: Icon(Icons.delete),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    10.0), // Set the desired border radius here
                color: Colors.grey[300],
              ),
              height: MediaQuery.of(context).size.height * 0.07,
              child: LinearProgressIndicator(
                value: task.progress / task.count,
                backgroundColor: Colors
                    .transparent, // Set the background color of the progress bar to transparent
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 238, 127, 119)),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _incrementProgress(index),
              child: Text('Increment Progress'),
            ),
          ],
        ),
      ),
    );
  }

  void _removeTask(int index) {
    setState(() {
      _taskList.removeAt(index);
    });
  }

  void _showPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Input Task and Count'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _trackNameController,
                decoration: InputDecoration(
                  labelText: 'Task Name',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _countController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Count',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _addTask();
              },
              child: Text('Add Task'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class ProgressBar extends StatelessWidget {
  ProgressBar({required this.task, required this.onPlusPressed});
  final Task task;
  final VoidCallback onPlusPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Task Name: ${task.name}',
              style: TextStyle(fontSize: 18),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: onPlusPressed,
            ),
          ],
        ),
        SizedBox(height: 10),
        LinearProgressIndicator(
          value: task.progress,
          minHeight: MediaQuery.of(context).size.height * 0.03,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        SizedBox(height: 10),
        Text(
          'Progress Count: ${task.progress}',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: onPlusPressed,
          child: Text('Increment Progress'),
        ),
      ],
    );
  }
}
