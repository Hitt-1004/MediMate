import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode>
{
  ThemeMode mode = ThemeMode.system;

  ThemeCubit(): super(ThemeMode.system);

  void toggleTheme()
  {
    if(mode == ThemeMode.system)
    {
      mode = ThemeMode.light;
      emit(mode);
    }
    else if (mode == ThemeMode.light)
    {
      mode = ThemeMode.dark;
      emit(mode);
    }
    else
    {
      mode = ThemeMode.system;
      emit(mode);
    }
  }
}