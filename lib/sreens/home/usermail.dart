import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hobby/sreens/createPostPage.dart';

class Usermail extends StatefulWidget {
  const Usermail({super.key});

  @override
  State<Usermail> createState() => _UsermailState();
}

class _UsermailState extends State<Usermail> {
  String userEmail = ''; // Variable pour stocker l'email de l'utilisateur

  // Fonction pour récupérer l'email de l'utilisateur connecté
  void _getUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? 'Guest'; // Si l'email n'est pas disponible
      });
    } else {
      setState(() {
        userEmail = 'No user logged in'; // Si l'utilisateur n'est pas connecté
      });
    }
  }

  // Fonction pour récupérer les publications depuis Firestore
  Stream<QuerySnapshot> getPosts() {
    return FirebaseFirestore.instance.collection('posts').snapshots();
  }

  @override
  void initState() {
    super.initState();
    _getUserEmail(); // Récupérer l'email de l'utilisateur
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
                    Text(
                      userEmail.isNotEmpty
                          ? userEmail
                          : 'Guest', // Affichage de l'email
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black),
                      child: const Center(
                          child: Text(
                        'For you',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      )),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      height: 40,
                      width: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200),
                      child: const Center(
                          child: Text(
                        'Most popular',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      )),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CreatePostPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFCCF4E9)),
                        child: const Center(
                            child: Text(
                          '+ Create',
                          style: TextStyle(
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Utilisation de StreamBuilder pour écouter les publications en temps réel
            StreamBuilder<QuerySnapshot>(
              stream: getPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                      child:
                          Text('Erreur lors du chargement des publications'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('Aucune publication disponible'));
                }

                final posts = snapshot.data!.docs;
                return Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      var post = posts[index];
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Titre de la publication
                              Text(
                                post['postContent'] ??
                                    'Titre de la publication',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Description de la publication
                              Text(
                                post['postDescription'] ??
                                    'Description de la publication',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              // Affichage de l'URL de l'image
                              post['postUrl'] != null
                                  ? Image.network(
                                      post['postUrl'],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                    )
                                  : const Text('Aucune image'),
                              const SizedBox(height: 10),
                              // Affichage du hobby sélectionné
                              Text(
                                'Hobby: ${post['selectedHobby']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
