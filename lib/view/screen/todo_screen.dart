import 'package:flutter/material.dart';
import 'package:flutter_web_todo_app/model/todo_response.dart';
import 'package:get/get.dart';
import '../controller/todo_controller.dart';
import 'widget/animated_todo_card.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  void showAddEditDialog({Todo? todo}) {
    final controller = Get.find<TodoController>();
    final titleController = TextEditingController(text: todo?.title ?? '');
    final descController = TextEditingController(text: todo?.description ?? '');

    Get.dialog(
      AlertDialog(
        backgroundColor: Get.theme.cardColor.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(todo == null ? 'New Todo' : 'Edit Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(hintText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isEmpty) return;

              if (todo == null) {
                controller.addTodo(title, descController.text.trim());
              } else {
                controller.updateTodo(todo, title, descController.text.trim());
              }
            },
            child: Text(todo == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TodoController controller = Get.put(TodoController());

    final width = MediaQuery.of(context).size.width;
    int crossAxisCount = 1;
    if (width >= 1200) {
      crossAxisCount = 4;
    } else if (width >= 900) {
      crossAxisCount = 3;
    } else if (width >= 600) {
      crossAxisCount = 2;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'My Todos',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: Get.isDarkMode
                ? [Colors.blueGrey.shade900, Colors.black]
                : [Colors.indigo.shade100, Colors.white],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.todos.isEmpty) {
            return const Center(
              child: Text(
                'No todos yet. Add one!',
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.all(width > 600 ? 32 : 16).copyWith(top: 120),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 1.4,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: controller.todos.length,
            itemBuilder: (context, index) {
              final todo = controller.todos[index];
              return AnimatedTodoCard(
                todo: todo,
                onEdit: () => showAddEditDialog(todo: todo),
                onDelete: () => controller.deleteTodo(todo.id),
              );
            },
          );
        }),
      ),
      floatingActionButton: width > 600
          ? FloatingActionButton.extended(
              onPressed: () => showAddEditDialog(),
              label: const Text(
                'Add Todo',
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              backgroundColor: Colors.indigo,
            )
          : FloatingActionButton(
              onPressed: () => showAddEditDialog(),
              backgroundColor: Colors.indigo,
              child: const Icon(Icons.add),
            ),
    );
  }
}
