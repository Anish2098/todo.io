import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/todo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key,}) : super(key: key);

  @override
  State<SplashScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SplashScreen> {

@override
  void initState() {
   Timer(Duration(seconds: 8), ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ToDoScreen())));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText('Welcome to ToDo App'),
              ],
              isRepeatingAnimation: true,
            ),
          ),
        ),
      ),
    );
  }
}
