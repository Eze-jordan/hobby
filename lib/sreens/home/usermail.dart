import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hobby/sreens/activite/community.dart';
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

  // Fonction pour compter le nombre de publications pour chaque hobby
  Future<int> countPostsForHobby(String hobby) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('selectedHobby', isEqualTo: hobby)
        .get();
    return snapshot.docs.length;
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
                    const Text(
                      'Welcome back,',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF000000),
                      ),
                    ),
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
                        ))),
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
                        ))),
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
                          ))),
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

                // Regroupement des publications par hobby
                Map<String, List<QueryDocumentSnapshot>> hobbyGroups = {};

                for (var post in posts) {
                  String hobby = post['selectedHobby'];
                  if (!hobbyGroups.containsKey(hobby)) {
                    hobbyGroups[hobby] = [];
                  }
                  hobbyGroups[hobby]!.add(post);
                }

                return Expanded(
                  child: ListView(
                    children: hobbyGroups.entries.map((entry) {
                      String hobby = entry.key;
                      List<QueryDocumentSnapshot> hobbyPosts = entry.value;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '$hobby Community',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                // Affichage du nombre de publications pour chaque hobby
                                FutureBuilder<int>(
                                  future: countPostsForHobby(hobby),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }
                                    if (snapshot.hasError) {
                                      return const Text('Erreur');
                                    }
                                    final postCount = snapshot.data ?? 0;
                                    return Text(
                                      '$postCount activités',
                                      style: const TextStyle(fontSize: 18),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Affichage des publications de ce hobby dans un Row
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: hobbyPosts.map((post) {
                                  return Card(
                                    elevation: 5,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          // Récupérer les informations de la publication
                                          String postTitle =
                                              post['postTitle'] ??
                                                  'Titre de la publication';
                                          String postContent = post[
                                                  'postContent'] ??
                                              'Description de la publication';
                                          String postUrl =
                                              post['postUrl'] ?? '';
                                          String postId =
                                              post.id; // ID de la publication

                                          // Naviguer vers la page Community et passer les informations
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => Community(
                                                postTitle: postTitle,
                                                postContent: postContent,
                                                postUrl: postUrl,
                                                postId:
                                                    postId, // Passer l'ID de la publication
                                              ),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Affichage de l'URL de l'image avec des bords arrondis
                                            post['postUrl'] != null
                                                ? Stack(children: [
                                                    Container(
                                                      width: 310,
                                                      height: 200,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20), // Arrondi des coins
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Colors.grey,
                                                            blurRadius: 5,
                                                          ),
                                                        ], // Ombre (optionnelle)
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        child: Image.network(
                                                          post['postUrl'],
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 10,
                                                      right: 10,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          // Supprimer la publication
                                                        },
                                                        child: Container(
                                                          width: 50,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: const Color(
                                                                0xAFBFBCBC),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons.person,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                '5',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ])
                                                : const Text('Aucune image'),
                                            const SizedBox(height: 10),
                                            Text(
                                              post['postTitle'] ??
                                                  'Titre de la publication',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              post['postContent'] ??
                                                  'Description de la publication',
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
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
