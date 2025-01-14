import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hobby/sreens/firstpage.dart';
import 'package:hobby/sreens/login.dart';

class Timepage extends StatefulWidget {
  const Timepage({super.key});

  @override
  State<Timepage> createState() => _TimepageState();
}

class _TimepageState extends State<Timepage> {
  @override
  void initState() {
    super.initState();
    // Naviguer vers la première page après 1 seconde
    Timer(const Duration(seconds: 10), () {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data != null) {
                    return const Firstpage();
                  }
                  return const Login();
                })),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Affichage du logo
            Image.asset(
              'assets/img/LOGO HOBBY.png',
              height: 250,
            ),
            const SizedBox(height: 20),
            // Affichage du deuxième logo
            Image.asset(
              'assets/img/logo2.png',
              height: 250,
            ),
            const SizedBox(height: 20),
            const Text(
              'Bienvenue chez Hobby',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7F7D7D),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Trouvez votre plaisir, chaque jour !',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7F7D7D),
              ),
            ),
            const SizedBox(height: 60),
            // Barre de chargement
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: const LinearProgressIndicator(
                backgroundColor: Color(0xFFDCDCDC),
                color: Color(0xFFA70D0D), // Changer la couleur si nécessaire
              ),
            ),
          ],
        ),
      ),
    );
  }
}
