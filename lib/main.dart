import 'package:flutter/material.dart';
import 'package:mastering_tests/config/dependencies.dart';
import 'package:mastering_tests/routing/router.dart';
import 'package:provider/provider.dart';


void main() {
  runApp( MultiProvider(providers: providers, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Spline Sans',
        useMaterial3: true,
      ),
      routerConfig: router(),
      debugShowCheckedModeBanner: false,
    );
  }
}