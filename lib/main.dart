import 'package:flutter/material.dart';
import 'package:mastering_tests/ui/sign_in/widget/signin_screen.dart';
import 'package:mastering_tests/ui/signup/widget/signup_screen.dart';
import 'package:mastering_tests/ui/tasks/widgets/components/delete_confirmation_dialog.dart';
import 'package:mastering_tests/ui/tasks/widgets/components/edit_task.dart';
import 'package:mastering_tests/ui/tasks/widgets/components/empty_state_screen.dart';
import 'package:mastering_tests/ui/tasks/widgets/todo_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Spline Sans',
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}