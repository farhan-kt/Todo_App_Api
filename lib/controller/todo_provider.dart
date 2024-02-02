import 'dart:developer';
import 'package:api_todo_app/model/todo_model.dart';
import 'package:api_todo_app/service/todo_service.dart';
import 'package:flutter/material.dart';

class TodoProvider extends ChangeNotifier {
  TextEditingController titleAddController = TextEditingController();
  TextEditingController descriptionAddController = TextEditingController();
  TodoService todoservice = TodoService();
  List<TodoModel> todoList = [];

  Future<void> fetchTodo() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      todoList = await todoservice.fetchTodo();
      notifyListeners();
    } catch (error) {
      log('Error on fetching Todo : $error');
      rethrow;
    }
  }

  Future<void> addTodo() async {
    try {
      await todoservice.addTodo(TodoModel(
          title: titleAddController.text,
          description: descriptionAddController.text));
      notifyListeners();
    } catch (error) {
      log('Error got while adding Todo :$error');
    }
  }

  updateTodo(title, description, String id) async {
    try {
      await todoservice.updateTodo(
          TodoModel(title: title, description: description), id);
      fetchTodo();
    } catch (error) {
      log('Error while updating :$error');
    }
  }

  deleteTodo(String id) async {
    try {
      await todoservice.deleteTodo(id);
      notifyListeners();
    } catch (error) {
      log('Error while deleting Todo : $error');
      throw error;
    }
  }
}
