import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hobby/sreens/bottom.dart';

class Firstpage extends StatefulWidget {
  const Firstpage({super.key});

  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  final List<Map<String, dynamic>> hobbies = [
    {'name': 'Cars', 'icon': Icons.directions_car},
    {'name': 'Music', 'icon': Icons.music_note},
    {'name': 'Running', 'icon': Icons.run_circle},
    {'name': 'Traveling', 'icon': Icons.airplanemode_active},
    {'name': 'Reading', 'icon': Icons.book},
    {'name': 'Swimming', 'icon': Icons.pool},
    {'name': 'Cycling', 'icon': Icons.pedal_bike},
    {'name': 'Writing', 'icon': Icons.create},
    {'name': 'Art', 'icon': Icons.brush},
    {'name': 'Animals', 'icon': Icons.pets},
    {'name': 'Cooking', 'icon': Icons.kitchen},
    {'name': 'Photo', 'icon': Icons.camera_alt},
  ];

  final Set<int> selectedHobbies = <int>{};

  Color generateRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  // Fonction pour enregistrer les hobbies sélectionnés dans Firestore
  void saveHobbiesToFirebase() async {
    try {
      // Obtenir l'ID de l'utilisateur authentifié
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        List selectedHobbyNames = hobbies
            .where((hobby) => selectedHobbies.contains(hobbies.indexOf(hobby)))
            .map((hobby) => hobby['name'])
            .toList();

        // Enregistrer dans Firestore sous l'ID de l'utilisateur
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'selectedHobbies': selectedHobbyNames,
        });

        print("Hobbies enregistrés dans Firebase");
      } else {
        print("Utilisateur non authentifié");
      }
    } catch (e) {
      print("Erreur lors de l'enregistrement dans Firebase: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select hobbies',
              style: TextStyle(fontSize: 45, fontWeight: FontWeight.w900),
            ),
            const Text(
              '& interests',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 30,
                ),
                itemCount: hobbies.length,
                itemBuilder: (context, index) {
                  final hobby = hobbies[index];
                  bool isSelected = selectedHobbies.contains(index);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedHobbies.remove(index);
                        } else {
                          selectedHobbies.add(index);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? generateRandomColor()
                            : const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            hobby['icon'],
                            size: 40,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            hobby['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70, right: 20, top: 20),
              child: GestureDetector(
                onTap: () {
                  if (selectedHobbies.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select at least one hobby.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    saveHobbiesToFirebase(); // Enregistrer dans Firebase
                    // Naviguer vers la deuxième page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Bottom(),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 100,
                  width: 190,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0XFF000000),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30, right: 10),
                            child: const Text(
                              'Start',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
