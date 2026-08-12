import 'dart:async';

import 'package:flutter/material.dart';

import '../models/task.dart';
import '../widgets/empty_state.dart';
import '../widgets/task_tile.dart';

enum TaskFilter { all, active, completed }

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<Task> _tasks = [];

  final TextEditingController _taskController = TextEditingController();
  final FocusNode _taskFocusNode = FocusNode();

  TaskFilter _selectedFilter = TaskFilter.all;

  // Used to control the delete SnackBar timer.
  int _deleteMessageId = 0;

  @override
  void dispose() {
    _taskController.dispose();
    _taskFocusNode.dispose();
    super.dispose();
  }

  int get _completedCount {
    return _tasks.where((task) => task.isCompleted).length;
  }

  int get _remainingCount {
    return _tasks.where((task) => !task.isCompleted).length;
  }

  List<Task> get _filteredTasks {
    switch (_selectedFilter) {
      case TaskFilter.active:
        return _tasks.where((task) => !task.isCompleted).toList();

      case TaskFilter.completed:
        return _tasks.where((task) => task.isCompleted).toList();

      case TaskFilter.all:
        return List.from(_tasks);
    }
  }

  void _addTask() {
    final title = _taskController.text.trim();

    if (title.isEmpty) {
      _showMessage('Please enter a task first.');
      _taskFocusNode.requestFocus();
      return;
    }

    setState(() {
      _tasks.insert(
        0,
        Task(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: title,
        ),
      );

      _taskController.clear();
    });

    _taskFocusNode.requestFocus();
  }

  void _toggleTask(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
  }

  void _deleteTask(Task task) {
    final index = _tasks.indexOf(task);

    setState(() {
      _tasks.remove(task);
    });

    // Create a unique ID for this delete message.
    final messageId = ++_deleteMessageId;

    // Close any currently visible SnackBar first.
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Show delete message.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task deleted'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            // Stop the current delete timer.
            _deleteMessageId++;

            setState(() {
              _tasks.insert(index.clamp(0, _tasks.length), task);
            });
          },
        ),
      ),
    );

    // Manually close the SnackBar after exactly 5 seconds.
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;

      // Only close if this is still the active delete message.
      if (messageId == _deleteMessageId) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });
  }

  void _clearCompleted() {
    final completedTasks = _tasks.where((task) => task.isCompleted).toList();

    if (completedTasks.isEmpty) {
      return;
    }

    setState(() {
      _tasks.removeWhere((task) => task.isCompleted);
    });

    _showMessage('Completed tasks cleared.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showAddTaskSheet() {
    _taskFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filteredTasks;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildInputSection(),
            _buildStats(),
            _buildFilterBar(),
            Expanded(
              child: filteredTasks.isEmpty
                  ? EmptyState(onAddTask: _showAddTaskSheet)
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];

                        return TaskTile(
                          key: ValueKey(task.id),
                          task: task,
                          onToggle: () => _toggleTask(task),
                          onDelete: () => _deleteTask(task),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _tasks.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _showAddTaskSheet,
              backgroundColor: const Color(0xFF5B5FEF),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'New Task',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            )
          : null,
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5B5FEF), Color(0xFF7478F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'TaskFlow',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Focus',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            'Stay organized.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _remainingCount == 0 && _tasks.isNotEmpty
                ? 'Great job! Everything is completed.'
                : 'Turn your plans into progress.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.78),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _taskController,
              focusNode: _taskFocusNode,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _addTask(),
              decoration: InputDecoration(
                hintText: 'What needs to be done?',
                hintStyle: const TextStyle(color: Color(0xFF9A9DAB)),
                prefixIcon: const Icon(
                  Icons.edit_note_rounded,
                  color: Color(0xFF777B8A),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE7E8EF)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE7E8EF)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF5B5FEF),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: const Color(0xFF5B5FEF),
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: _addTask,
              borderRadius: BorderRadius.circular(16),
              child: const SizedBox(
                height: 56,
                width: 56,
                child: Icon(Icons.add_rounded, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: _statCard(
              icon: Icons.list_alt_rounded,
              value: _tasks.length.toString(),
              label: 'Total',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _statCard(
              icon: Icons.pending_actions_rounded,
              value: _remainingCount.toString(),
              label: 'Pending',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _statCard(
              icon: Icons.task_alt_rounded,
              value: _completedCount.toString(),
              label: 'Done',
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDEEF4)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF5B5FEF)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF20222C),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF858896),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      child: Row(
        children: [
          _filterButton(title: 'All', filter: TaskFilter.all),
          const SizedBox(width: 8),
          _filterButton(title: 'Active', filter: TaskFilter.active),
          const SizedBox(width: 8),
          _filterButton(title: 'Completed', filter: TaskFilter.completed),
          const Spacer(),
          if (_completedCount > 0)
            TextButton(
              onPressed: _clearCompleted,
              child: const Text(
                'Clear done',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF5B5FEF),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _filterButton({required String title, required TaskFilter filter}) {
    final isSelected = _selectedFilter == filter;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5B5FEF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF5B5FEF)
                : const Color(0xFFE4E5EC),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : const Color(0xFF777B8A),
          ),
        ),
      ),
    );
  }
}
