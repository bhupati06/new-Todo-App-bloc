import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_bloc/bloc/todo_bloc.dart';
import 'package:to_do_app_bloc/bloc/todo_event.dart';
import 'package:to_do_app_bloc/bloc/todo_state.dart';
import 'package:to_do_app_bloc/theme/theme_bloc.dart';
import 'package:to_do_app_bloc/theme/theme_event.dart';
import 'package:to_do_app_bloc/theme/theme_state.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => TOdoBloc()),
      BlocProvider(create: (context) => ThemeBloc()),
    ],
    child: const MyApp(),
  ));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo App bloc',
          theme: themeState.themeData,
          home: TodoPage(),
        );
      },
    );
  }
}


// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Todo App bloc',
//       home: BlocProvider(
//         create: (context) => TOdoBloc(),
//         child: TodoPage(),
//       ),
//     );
//   }
// }

class TodoPage extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text('Todo App bloc'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeBloc>().add(ToggleTheme());
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _textController,

              decoration: InputDecoration(
                  labelText: 'Enter a task',
                  suffixIcon: IconButton(
                    onPressed: () {
                      final task = _textController.text.trim();
                      if (task.isNotEmpty) {
                        context.read<TOdoBloc>().add(AddTodo(task));
                        _textController.clear();
                      }
                    },
                    icon: Icon(Icons.add),
                  )
              ),

            ),
          ),
          Expanded(
              child: BlocBuilder<TOdoBloc, TodoState>(
                builder: (context, state) {
                  return ListView.builder(
                      itemCount: state.todos.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.todos[index]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _editTodoDialog(context,index,state.todos[index]);
                                  }, icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    _deleteTodoDialog(context, index);
                                  }, icon: Icon(Icons.delete)),

                            ],
                          ),

                        );
                      }
                  );
                },
              )
          )
        ],
      ),
    );
  }
  void _editTodoDialog(
      BuildContext parentContext,int index,String currentTask){
    final TextEditingController _editController =TextEditingController(text:currentTask);
    showDialog(context: parentContext ,builder:(BuildContext context){
      return AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(
          controller: _editController,
          decoration: const InputDecoration(
            labelText: 'task',
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            final UpdateTask = _editController.text;
            if(UpdateTask.isNotEmpty){
              parentContext.read<TOdoBloc>().add(EditTodo(index,UpdateTask));
            }
            Navigator.of(context).pop();
          },
              child: const Text('save')),
              TextButton(onPressed:(){
                Navigator.of(context).pop();
              },
                child:const Text('cancel')
          )
        ],
      );
    });
  }
  void _deleteTodoDialog(
      BuildContext parentContext,int index){
    showDialog(
        context: parentContext,
        builder :(BuildContext context){
         return AlertDialog(
        title: const Text('Edit Task'),
        content: const Text('Are sure want to delete the task'),
        actions: [
          TextButton(onPressed: (){
           parentContext.read<TOdoBloc>().add(DeleteTodo(index));
           Navigator.of(context).pop();
            },
              child: const Text('Delete')),
          TextButton(onPressed:(){
            Navigator.of(context).pop();
          },
              child:const Text('cancel')
          )
        ],
      );
        });
  }
}


