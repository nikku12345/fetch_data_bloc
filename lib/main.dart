

import 'package:assignment_task/ui/home/list_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home/home_bloc.dart';
import 'bloc/home/home_event.dart';
import 'helper/database_helper.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => HomeBloc(DatabaseHelper())..add(HomeFetchRepositoriesEvent()),
        child: const RepositoryListScreen(),
      ),
    );
  }
}
