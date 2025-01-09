import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hobby/firebase_options.dart';

import 'sreens/timepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hobby App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      ),
      debugShowCheckedModeBanner: false,
      home: const Timepage(), // Définir Firstpage comme la page suivante
    );
  }
}
