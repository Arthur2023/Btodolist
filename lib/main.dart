import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:b_to_do/UI/HomeLoad.dart';


void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "minimalist to do",
      home: MyApp(),
      theme: ThemeData(
        hintColor: Colors.grey,
        primaryColor: Colors.grey,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}
