import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_web_todo_app/model/todo_response.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AnimatedTodoCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AnimatedTodoCard({
    super.key,
    required this.todo,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 100 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.35),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      todo.description,
                      style: const TextStyle(fontSize: 16),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMM dd, yyyy').format(todo.createdAt),
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: onEdit,
                          color: Colors.blue,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: () {
                            Get.dialog(
                              AlertDialog(
                                title: const Text('Delete Todo?'),
                                content: const Text('This action cannot be undone.'),
                                actions: [
                                  TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                      onDelete();
                                    },
                                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}