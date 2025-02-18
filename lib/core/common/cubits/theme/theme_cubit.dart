import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ThemeCubit extends Cubit<ThemeData> {
  final Box box;
  ThemeCubit({required this.box}) : super(ThemeData.light());

  void toggleTheme() {
    if (state == ThemeData.light()) {
      saveTheme(isDark: true);
      emit(ThemeData.dark());
    } else {
      saveTheme(isDark: false);
      emit(ThemeData.light());
    }
  }

  void saveTheme({required bool isDark}) {
    box.write(() {
      box.put('isDark', isDark);
    });
  }

  bool readTheme() {
    bool getTheme = false;
    box.read(() {
      getTheme = box.get('isDark') ?? false;
    });
    return getTheme;
  }
}

