import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hobby/sreens/bottom.dart';
import 'package:hobby/sreens/profile.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _titleController =
      TextEditingController(); // Titre de la publication
  final TextEditingController _contentController =
      TextEditingController(); // Contenu de la publication
  final TextEditingController _urlController =
      TextEditingController(); // URL de l'image
  String _selectedHobby = ''; // Hobby sélectionné
  String userEmail = ''; // Variable pour stocker l'email de l'utilisateur
  List<String> userHobbies = []; // Liste des hobbies de l'utilisateur

  // Fonction pour récupérer l'email de l'utilisateur connecté
  void _getUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ??
            'Guest'; // Si l'email n'est pas disponible, afficher 'Guest'
      });
    }
  }

  // Fonction pour récupérer les hobbies de l'utilisateur depuis Firebase
  Future<void> _getUserHobbies() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        var doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          setState(() {
            userHobbies = List<String>.from(doc['selectedHobbies']);
          });
        }
      } catch (e) {
        print("Erreur lors de la récupération des hobbies : $e");
      }
    } else {
      print("Utilisateur non authentifié");
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserEmail(); // Récupérer l'email de l'utilisateur
    _getUserHobbies(); // Récupérer les hobbies au démarrage
  }

  // Fonction pour enregistrer la publication dans Firebase
  void savePostToFirebase() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('posts').add({
          'userId': user.uid,
          'postTitle': _titleController.text,
          'selectedHobby': _selectedHobby,
          'postContent': _contentController.text,
          'postUrl': _urlController.text,
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Publication créée avec succès!')),
        );

        // Réinitialiser les contrôleurs après la publication
        _titleController.clear();
        _contentController.clear();
        _urlController.clear();

        // Retourner à la page d'accueil
        Navigator.pop(context); // Fermer la page actuelle (CreatePostPage)
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Bottom(),
                    ),
                  );
                },
                child: const Icon(Icons.arrow_back, color: Colors.black)),
            const SizedBox(height: 20),
            // Affichage de l'email de l'utilisateur
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Profile(),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/img/LOGO HOBBY.png'),
                    radius: 30,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userEmail, // Affichage de l'email de l'utilisateur
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Votre publication:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Champ de texte pour le titre de la publication
            TextField(
              maxLines: 1,
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Nom de la publication',
                hintText: 'Entrez le nom de la publication',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Champ de texte pour le contenu de la publication
            TextField(
              maxLines: 4,
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Contenu de la publication',
                hintText: 'Entrez le contenu de la publication',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choisir un hobby:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Dropdown pour les hobbies
            DropdownButton<String>(
              value: _selectedHobby.isEmpty ? null : _selectedHobby,
              hint: const Text('Sélectionner un hobby'),
              items: userHobbies.map((hobby) {
                return DropdownMenuItem<String>(
                  value: hobby,
                  child: Text(hobby),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedHobby = value!; // Mettre à jour le hobby sélectionné
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Ajouter une URL pour l\'image:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                hintText: 'Entrez une URL pour l\'image',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: savePostToFirebase,
              child: const Text('Publier'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
