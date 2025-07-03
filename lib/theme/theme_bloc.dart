import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  bool isDark = false;

  ThemeBloc()
      : super(ThemeState(themeData: ThemeData.light())) {
    on<ToggleTheme>((event, emit) {
      isDark = !isDark;
      emit(ThemeState(
          themeData: isDark ? ThemeData.dark() : ThemeData.light()));
    });
  }
}
