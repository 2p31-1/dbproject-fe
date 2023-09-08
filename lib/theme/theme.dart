import 'package:flutter/material.dart';

class MyTheme{
  static final themeData = ThemeData(
    primarySwatch: Colors.red,
    primaryColor: Colors.white, // 기본 색상을 흰색으로 설정
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white70,),
      bodySmall: TextStyle(color: Colors.white70),
      bodyMedium:  TextStyle(color: Colors.white70),
      titleLarge:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
      titleMedium:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
      titleSmall:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold,)
    ),
    tabBarTheme: const TabBarTheme(
      unselectedLabelColor: Color(0x99ffffff), // 선택되지 않은 탭 아이콘 및 글자 색상
      labelColor: Colors.white, // 선택된 탭 아이콘 및 글자 색상
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Color(0x33ffffff)),
      border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0x10FF5252),
          )
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFF5252),
          )
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    )
  );
}