import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskLoggingPage extends StatefulWidget {
  const TaskLoggingPage({super.key});

  @override
  _TaskLoggingPageState createState() => _TaskLoggingPageState();
}

class _TaskLoggingPageState extends State<TaskLoggingPage> {
  final List<TextEditingController> _taskControllers = List.generate(
    5,
    (index) => TextEditingController(),
  );
  final List<String> _priorities = List.filled(5, 'Low');
  final List<bool> _taskCompleted = List.filled(5, false);

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 5; i++) {
      _taskControllers[i].text = prefs.getString('task$i') ?? '';
      _priorities[i] = prefs.getString('priority$i') ?? 'Low';
      _taskCompleted[i] = prefs.getBool('completed$i') ?? false;
    }
    setState(() {});
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 5; i++) {
      prefs.setString('task$i', _taskControllers[i].text);
      prefs.setString('priority$i', _priorities[i]);
      prefs.setBool('completed$i', _taskCompleted[i]);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tasks saved successfully!')),
    );
  }

  // Log the tasks and save them
  void _logTasks() {
    _saveTasks();
    Navigator.pushNamed(context, '/session2_evaluation');
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Task Logging',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4D6C6C),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Daily Routine Log:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Make a list of activities that you have to complete in the next three days.',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            Table(
              border: TableBorder.all(color: Colors.white.withOpacity(0.3)),
              columnWidths: {
                0: FlexColumnWidth(screenWidth > 600 ? 2 : 1),
                1: FlexColumnWidth(screenWidth > 600 ? 1 : 0.5),
                2: FlexColumnWidth(screenWidth > 600 ? 1 : 0.5),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[800]),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Task',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Priority',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Completed',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                for (int i = 0; i < 5; i++)
                  TableRow(
                    decoration: BoxDecoration(
                      color: i.isEven ? Colors.grey[700] : Colors.grey[800],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _taskControllers[i],
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Task ${i + 1}',
                            hintStyle: const TextStyle(color: Colors.white60),
                            filled: true,
                            fillColor: Colors.grey[850],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.3)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
                          value: _priorities[i],
                          onChanged: (String? newValue) {
                            setState(() {
                              _priorities[i] = newValue!;
                            });
                          },
                          dropdownColor: Colors.grey[850],
                          style: const TextStyle(color: Colors.white),
                          items: <String>['High', 'Medium', 'Low']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Checkbox(
                          value: _taskCompleted[i],
                          onChanged: (bool? value) {
                            setState(() {
                              _taskCompleted[i] = value!;
                            });
                          },
                          checkColor: Colors.white,
                          activeColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logTasks,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB17A6E),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Log Tasks',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
