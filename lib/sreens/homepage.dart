import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hobby/sreens/bottom.dart'; // Assurez-vous que ce chemin est correct.
import 'package:iconsax/iconsax.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String userEmail =
      ''; // Déclarez userEmail ici pour récupérer l'email de l'utilisateur.

  @override
  void initState() {
    super.initState();
    _getUserEmail(); // Appel de la fonction pour récupérer l'email dès que l'écran est initialisé
  }

  // Fonction pour obtenir l'email de l'utilisateur connecté
  void _getUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? ''; // Récupérer l'email de l'utilisateur
      });
    } else {
      setState(() {
        userEmail = 'No user logged in'; // Si aucun utilisateur n'est connecté
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/img/LOGO HOBBY.png'),
                  radius: 35,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome back,',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF2E2E2E),
                      ),
                    ),
                    Text(
                      userEmail.isNotEmpty ? userEmail : 'Guest',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(
                  Iconsax.search_normal_1,
                  color: Colors.black,
                  size: 30,
                ),
              ],
            ),
            // Affichage de la page sélectionnée ou d'autres widgets ici
          ],
        ),
      ),
      bottomNavigationBar: const Bottom(),
    );
  }
}
