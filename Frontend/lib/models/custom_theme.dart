import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTheme
{
  // Can use ThemeData.from constructor also.

  ThemeData lightTheme()
  {
    return ThemeData
      (
      brightness: Brightness.light,
      canvasColor: const Color.fromRGBO(255, 255, 255, 1.0),
      cardTheme: CardTheme
        (
        color: const Color.fromRGBO(240, 240, 240, 1),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      colorScheme: ColorScheme.fromSeed
        (
        seedColor: const Color.fromRGBO(107, 66, 165, 1),
        primary: const Color.fromRGBO(107, 66, 165, 1),
        brightness: Brightness.light
      ),
      scaffoldBackgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBarTheme: const AppBarTheme
        (
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        elevation: 0,
        iconTheme: IconThemeData(color: Color.fromRGBO(107, 66, 165, 1)),
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)
      ),
      listTileTheme: const ListTileThemeData
        (
        iconColor: Color.fromRGBO(107, 66, 165, 1),
        contentPadding: EdgeInsets.all(15),
        style: ListTileStyle.list
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData
        (
        foregroundColor: Color.fromRGBO(255, 255, 255, 1),
        backgroundColor: Color.fromRGBO(107, 66, 165, 1),
        iconSize: 30
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData
        (
        elevation: 0,
        backgroundColor: Color.fromRGBO(240, 240, 240, 1),
        selectedItemColor: Color.fromRGBO(107, 66, 165, 1),
        showSelectedLabels: false,
        showUnselectedLabels: false
      ),
      dialogTheme: DialogTheme
        (
        backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
      )
    );
  }

  ThemeData darkTheme()
  {
    return ThemeData
      (
      brightness: Brightness.dark,
      canvasColor: const Color.fromRGBO(0, 0, 0, 1),
      cardTheme: CardTheme
        (
        color: const Color.fromRGBO(27, 26, 26, 1),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      colorScheme: ColorScheme.fromSeed
        (
        seedColor: const Color.fromRGBO(181, 133, 251, 1),
        primary: const Color.fromRGBO(181, 133, 251, 1),
        brightness: Brightness.dark
      ),
      scaffoldBackgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      appBarTheme: const AppBarTheme
        (
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Color.fromRGBO(0, 0, 0, 1),
        elevation: 0,
        iconTheme: IconThemeData(color: Color.fromRGBO(181, 133, 251, 1)),
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
      ),
      listTileTheme: const ListTileThemeData
        (
        iconColor: Color.fromRGBO(181, 133, 251, 1),
        contentPadding: EdgeInsets.all(15),
        style: ListTileStyle.list
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData
        (
        foregroundColor: Color.fromRGBO(0, 0, 0, 1),
        backgroundColor: Color.fromRGBO(181, 133, 251, 1),
        iconSize: 30
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData
        (
        elevation: 0,
        backgroundColor: Color.fromRGBO(27, 26, 26, 1),
        selectedItemColor: Color.fromRGBO(181, 133, 251, 1),
        showSelectedLabels: true,
        showUnselectedLabels: false
      ),
      dialogTheme: DialogTheme
        (
          backgroundColor: const Color.fromRGBO(27, 26, 26, 1),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
      ),
    );
  }
}