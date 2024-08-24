import 'package:flutter/material.dart';
import 'package:kahoot/create_page.dart';

void main() {
  runApp( MaterialApp(
    home: const Homescreen(),
    theme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
  ));
}