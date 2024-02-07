import 'dart:developer';
import 'package:api_todo_app/model/todo_model.dart';
import 'package:api_todo_app/service/todo_service.dart';
import 'package:flutter/material.dart';

class TodoProvider extends ChangeNotifier {
  TextEditingController titleAddController = TextEditingController();
  TextEditingController descriptionAddController = TextEditingController();
  TodoService todoservice = TodoService();
  List<TodoModel> todoList = [];
  bool isLoading = false;

  Future<void> fetchTodo() async {
    isLoading = true;
    notifyListeners();
    try {
      todoList = await todoservice.fetchTodo();
      notifyListeners();
    } catch (error) {
      log('Error on fetching Todo : $error');
      rethrow;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addTodo() async {
    try {
      await todoservice.addTodo(TodoModel(
          title: titleAddController.text,
          description: descriptionAddController.text));
      notifyListeners();
      titleAddController.clear();
      descriptionAddController.clear();
      await fetchTodo();
    } catch (error) {
      log('Error got while adding Todo :$error');
    }
  }

  Future<void> updateTodo(title, description, String id) async {
    try {
      await todoservice.updateTodo(
          TodoModel(title: title, description: description), id);
      await fetchTodo();
    } catch (error) {
      log('Error while updating :$error');
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await todoservice.deleteTodo(id);
      await fetchTodo();
      notifyListeners();
    } catch (error) {
      log('Error while deleting Todo : $error');
      rethrow;
    }
  }
}
