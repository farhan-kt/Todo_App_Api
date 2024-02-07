import 'package:api_todo_app/controller/todo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTodoScreen extends StatelessWidget {
  const AddTodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD TODO',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: todoProvider.titleAddController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: todoProvider.descriptionAddController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 15,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                todoProvider.addTodo();

                Navigator.pop(context);
              },
              child: const Text('SUBMIT'))
        ],
      ),
    );
  }
}
