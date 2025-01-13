import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<String> selectedHobbies =
      []; // Liste pour stocker les sélections de l'utilisateur
  List<String> allHobbies = [
    'Cars',
    'Music',
    'Running',
    'Traveling',
    'Reading',
    'Swimming',
    'Cycling',
    'Writing',
    'Art',
    'Animals',
    'Cooking',
    'Photo'
  ]; // Liste de tous les hobbies possibles

  @override
  void initState() {
    super.initState();
    _getUserSelections(); // Appeler la fonction pour récupérer les sélections
  }

  // Fonction pour récupérer les sélections de l'utilisateur depuis Firestore
  Future<void> _getUserSelections() async {
    try {
      // Obtenir l'utilisateur actuel
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Récupérer les sélections depuis Firestore (par exemple, les hobbies)
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists && userDoc['selectedHobbies'] != null) {
          setState(() {
            selectedHobbies = List<String>.from(
                userDoc['selectedHobbies']); // Mettre à jour la liste
          });
        }
      }
    } catch (e) {
      print("Erreur lors de la récupération des sélections: $e");
    }
  }

  // Fonction pour ajouter un hobby à la liste et Firestore
  Future<void> _addHobby(String hobby) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          selectedHobbies.add(hobby); // Ajouter le hobby à la liste locale
        });

        // Mettre à jour les hobbies dans Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'selectedHobbies': selectedHobbies,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hobby ajouté: $hobby')),
        );
      }
    } catch (e) {
      print("Erreur lors de l'ajout du hobby: $e");
    }
  }

  // Afficher la boîte de dialogue pour ajouter un hobby
  void _showAddHobbyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select a Hobby'),
          content: SingleChildScrollView(
            child: Column(
              children: allHobbies.map((hobby) {
                return ListTile(
                  title: Text(hobby),
                  onTap: () {
                    _addHobby(hobby); // Ajouter le hobby sélectionné
                    Navigator.pop(context); // Fermer la boîte de dialogue
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // Fonction pour supprimer un hobby de la liste et Firestore
  Future<void> _removeHobby(String hobby) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          selectedHobbies.remove(hobby); // Retirer le hobby de la liste locale
        });

        // Mettre à jour les hobbies dans Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'selectedHobbies': selectedHobbies,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hobby supprimé de la liste')),
        );
      }
    } catch (e) {
      print("Erreur lors de la suppression du hobby: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
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
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFE4E1E1),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Search',
                      prefixIcon: const Icon(Iconsax.search_normal),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Card(),
                      ),
                    );
                  },
                  child: const Text(
                    'Neighbors',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000)),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Groups',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD2D0D0)),
                ),
                const SizedBox(width: 10),
                Text(
                  'Staff',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD2D0D0)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                GestureDetector(
                  onTap:
                      _showAddHobbyDialog, // Afficher la boîte de dialogue pour ajouter un hobby
                  child: Container(
                    width: 70,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFCAF5E9),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 9, left: 10),
                      child: const Text('+ Add',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000000))),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Affichage des sélections de l'utilisateur avec une croix pour chaque hobby
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: selectedHobbies.map((item) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              // Afficher le hobby
                              Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              // Icone de suppression (croix)
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                onPressed: () =>
                                    _removeHobby(item), // Supprimer le hobby
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
