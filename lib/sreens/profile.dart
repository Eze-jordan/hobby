import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hobby/sreens/login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Déclare une variable pour stocker les hobbies de l'utilisateur
  List<String> selectedHobbies = [];

  @override
  void initState() {
    super.initState();
    _getUserHobbies(); // Appelle la fonction pour récupérer les hobbies
  }

  // Fonction pour récupérer les hobbies de l'utilisateur depuis Firestore
  Future<void> _getUserHobbies() async {
    try {
      // Récupérer l'utilisateur actuel
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Récupérer les hobbies de l'utilisateur dans Firestore
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && userDoc['selectedHobbies'] != null) {
          setState(() {
            // Stocker les hobbies dans la liste
            selectedHobbies = List<String>.from(userDoc['selectedHobbies']);
          });
        }
      }
    } catch (e) {
      print("Erreur lors de la récupération des hobbies: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer l'utilisateur actuel
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Profile")),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              // Image de profil
              CircleAvatar(
                radius: 50,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : const AssetImage('assets/img/LOGO HOBBY.png')
                        as ImageProvider,
              ),
              const SizedBox(height: 10),
              Text(
                user?.email ?? 'Email non renseigné',
                style: const TextStyle(fontSize: 20, color: Color(0xFF565656)),
              ),
              const SizedBox(height: 20),

              // Affichage des hobbies sélectionnés
              const Text(
                'Hobbies sélectionnés:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              selectedHobbies.isNotEmpty
                  ? Column(
                      children: selectedHobbies.map((hobby) {
                        return Text(hobby,
                            style: const TextStyle(fontSize: 20));
                      }).toList(),
                    )
                  : const Text('Aucun hobby sélectionné',
                      style: TextStyle(fontSize: 20)),

              const SizedBox(height: 20),
              // Bouton de déconnexion
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
                child: const Text("Se déconnecter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
