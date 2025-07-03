import 'package:bloc/bloc.dart';
import 'package:to_do_app_bloc/bloc/todo_event.dart';
import 'package:to_do_app_bloc/bloc/todo_state.dart';

class TOdoBloc extends Bloc<TodoEvent ,TodoState>{
  TOdoBloc(): super(TodoState(todos:[])){
    on<AddTodo>((event,emit) {
      final updateTodos = List<String>.from(state.todos)
        ..add(event.task);
      emit(state.copyWith(todos: updateTodos));
    });

    on<EditTodo>((event,emit) {
      final updateTodos = List<String>.from(state.todos);
      updateTodos[event.index] =event.updateTask;
      emit(state.copyWith(todos: updateTodos));
    });

    on<DeleteTodo>((event,emit) {
      final updateTodos = List<String>.from(state.todos)..removeAt(event.index);

      emit(state.copyWith(todos: updateTodos));
    });

  }
  }
