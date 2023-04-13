import 'dart:async';

import 'package:chat_gpt/colors.dart';
import 'package:flutter/material.dart';

import 'homeScreen.dart';

void main() {
  runApp(chatGpt());
}

class chatGpt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homeScreen(),
      theme: ThemeData.light(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: white,
          appBarTheme: AppBarTheme(backgroundColor: white)),
    );
  }
}
