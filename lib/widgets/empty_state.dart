import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onAddTask;

  const EmptyState({
    super.key,
    required this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF0FF),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.task_alt_rounded,
                size: 44,
                color: Color(0xFF5B5FEF),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'All clear!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF171923),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You have no tasks yet.\nAdd your first task and stay organized.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Color(0xFF777B8A),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAddTask,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add your first task'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF5B5FEF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}