import 'package:flutter/material.dart';

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final List<Map<String, dynamic>> activities = [
    {
      'name': 'Activity 1',
      'description': 'Description for Activity 1',
    },
    {}
  ];
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
