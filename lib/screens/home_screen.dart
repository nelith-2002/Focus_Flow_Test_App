import 'package:flutter/material.dart';
import 'package:focus_flow_test/core/sdk/sdk_initializer.dart';
import 'package:focus_flow_test/models/task.dart';
import 'package:focus_flow_test/widgets/add_task_dialog.dart';
import 'package:focus_flow_test/widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [
    Task(id: '1', title: 'Plan the day'),
    Task(id: '2', title: 'Complete Flutter SDK test'),
    Task(id: '3', title: 'Review app startup performance'),
  ];

  void _addTask(String title) {
    setState(() {
      _tasks.insert(
        0,
        Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
        ),
      );
    });
  }

  void _toggleTask(String id) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == id);
      task.isCompleted = !task.isCompleted;
    });
  }

  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((t) => t.id == id);
    });
  }

  void _openAddTaskDialog() {
    showDialog(
      context: context,
      builder: (_) => AddTaskDialog(onAddTask: _addTask),
    );
  }

  void _showSdkStartupDialog(String startupText) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('SDK'),
        content: Text(startupText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final startupReport = StartupReportProvider.of(context)?.report;
    final startupText = startupReport == null
        ? 'Startup Time: Measuring...'
        : 'Startup Time: ${startupReport.startupDuration.inMilliseconds} ms';
    final completedCount = _tasks.where((task) => task.isCompleted).length;
    final pendingCount = _tasks.length - completedCount;

    return Scaffold(
      appBar: AppBar(title: const Text('Focus Flow'), centerTitle: true),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton.extended(
                heroTag: 'sdkFab',
                onPressed: () => _showSdkStartupDialog(startupText),
                icon: const Icon(Icons.memory),
                label: const Text('SDK'),
              ),
              FloatingActionButton.extended(
                heroTag: 'addTaskFab',
                onPressed: _openAddTaskDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Today Overview',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text('Total Tasks: ${_tasks.length}'),
                  Text('Completed: $completedCount'),
                  Text('Pending: $pendingCount'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(
                      child: Text(
                        'No tasks yet. Add your first task.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return TaskTile(
                          task: task,
                          onToggle: () => _toggleTask(task.id),
                          onDelete: () => _deleteTask(task.id),
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
