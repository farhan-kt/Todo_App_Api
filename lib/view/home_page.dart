// ignore_for_file: sort_child_properties_last

import 'package:api_todo_app/controller/todo_provider.dart';
import 'package:api_todo_app/view/todo_add.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TodoProvider>(context, listen: false).fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TODO LIST',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
                child: Consumer<TodoProvider>(builder: (context, value, child) {
              return value.todoList.isEmpty
                  ? Center(
                      child: Lottie.asset('assets/Animation - empty list.json',
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.7),
                    )
                  : ListView.builder(
                      itemCount: value.todoList.length,
                      itemBuilder: (context, index) {
                        final data = value.todoList.length - index - 1;
                        final todo = value.todoList[data];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            title: Text(todo.title.toString()),
                            subtitle: Text(todo.description.toString()),
                            trailing: PopupMenuButton(onSelected: (value) {
                              if (value == 'edit') {
                                updateAlertBox(
                                    context,
                                    todo.id,
                                    todo.title.toString(),
                                    todo.description.toString());
                              } else if (value == 'delete') {
                                Provider.of<TodoProvider>(context,
                                        listen: false)
                                    .deleteTodo(todo.id.toString());
                              }
                            }, itemBuilder: (context) {
                              return [
                                const PopupMenuItem(
                                    child: Text('EDIT'), value: 'edit'),
                                const PopupMenuItem(
                                    child: Text('DELETE'), value: 'delete')
                              ];
                            }),
                          ),
                        );
                      });
            }))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTodoScreen()));
        },
        label: const Text(
          'ADD TODO',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  updateAlertBox(
    context,
    id,
    String title,
    String description,
  ) {
    final TextEditingController titleController =
        TextEditingController(text: title);
    final TextEditingController descriptionController =
        TextEditingController(text: description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("EDIT TODO"),
          content: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  String newTitle = titleController.text.trim();
                  String newDescription = descriptionController.text.trim();
                  Provider.of<TodoProvider>(context, listen: false)
                      .updateTodo(newTitle, newDescription, id);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.update),
                label: const Text("UPDATE"),
              ),
            ],
          ),
        );
      },
    );
  }
}
