

import 'dart:convert';
import 'package:flutter_web_todo_app/model/todo_response.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TodoController extends GetxController {
  var todos = <Todo>[].obs;
  var isLoading = true.obs;

  // final String baseUrl = 'http://localhost:5000/todos';
 final String baseUrl = 'https://flutter-todo-backend-b1l3.onrender.com/todos';

  @override
  void onInit() {
    fetchTodos();
    super.onInit();
  }

  Future<void> fetchTodos() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        todos.assignAll(data.map((json) => Todo.fromJson(json)).toList());
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load todos: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> addTodo(String title, String description) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'title': title, 'description': description}),
      );

      if (response.statusCode == 201) {
        final newTodo = Todo.fromJson(json.decode(response.body));
        todos.insert(0, newTodo);
        Get.back(); // Close dialog
        Get.snackbar('Success', 'Todo added!');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add todo');
    }
  }

  Future<void> updateTodo(Todo todo, String newTitle, String newDescription) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${todo.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': newTitle,
          'description': newDescription,
        }),
      );

      if (response.statusCode == 200) {
        final updatedTodo = Todo.fromJson(json.decode(response.body));
        final index = todos.indexWhere((t) => t.id == todo.id);
        if (index != -1) {
          todos[index] = updatedTodo;
          todos.refresh();
        }
        Get.back();
        Get.snackbar('Updated', 'Todo updated successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update todo');
    }
  }
//aafafdasdf
  Future<void> deleteTodo(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200 || response.statusCode == 204) {
        todos.removeWhere((todo) => todo.id == id);
        Get.snackbar('Deleted', 'Todo removed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete todo');
    }
  }
}