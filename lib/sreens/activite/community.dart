import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Community extends StatefulWidget {
  final String postTitle;
  final String postContent;
  final String postUrl;
  final String postId;

  const Community({
    super.key,
    required this.postTitle,
    required this.postContent,
    required this.postUrl,
    required this.postId,
  });

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  TextEditingController _commentController = TextEditingController();
  bool isJoined =
      false; // Variable pour savoir si l'utilisateur a déjà rejoint la publication

  @override
  void initState() {
    super.initState();
    checkIfJoined(); // Vérifier si l'utilisateur a déjà rejoint la publication à l'initialisation
  }

  // Fonction pour vérifier si l'utilisateur a déjà rejoint la publication
  Future<void> checkIfJoined() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .get();

      List<dynamic> joinedUsers = snapshot['joinedUsers'] ?? [];
      setState(() {
        isJoined = joinedUsers.contains(user
            .email); // Vérifier si l'email de l'utilisateur est déjà dans la liste
      });
    }
  }

  // Fonction pour envoyer un commentaire
  Future<void> sendComment() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('comments').add({
          'postId': widget.postId,
          'userEmail': user.email,
          'comment': _commentController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        _commentController.clear(); // Réinitialiser le champ de commentaire
      } catch (e) {
        print("Erreur lors de l'ajout du commentaire: $e");
      }
    }
  }

  // Fonction pour rejoindre la publication
  Future<void> joinPost() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Ajouter l'email de l'utilisateur à la liste 'joinedUsers' de la publication
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .update({
          'joinedUsers': FieldValue.arrayUnion([user.email]),
        });

        // Mettre à jour l'état et afficher un message de confirmation
        setState(() {
          isJoined = true; // Met à jour l'état pour désactiver le bouton
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Vous avez rejoint cette publication !")),
        );
      } catch (e) {
        print("Erreur lors de l'ajout à la publication: $e");
      }
    }
  }

  // Fonction pour récupérer les commentaires de Firestore
  Stream<QuerySnapshot> getComments() {
    return FirebaseFirestore.instance
        .collection('comments')
        .where('postId', isEqualTo: widget.postId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    String userEmail =
        FirebaseAuth.instance.currentUser?.email ?? 'Utilisateur non connecté';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.postTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)],
              ),
              child: widget.postUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.postUrl,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Center(child: Text('Aucune image disponible')),
            ),
            const SizedBox(height: 20),
            Text(
              userEmail,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              widget.postContent,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1.5),
            const SizedBox(height: 20),

            // Affichage des commentaires
            StreamBuilder<QuerySnapshot>(
              stream: getComments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                      child:
                          Text('Erreur lors du chargement des commentaires'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('Aucun commentaire disponible.'));
                }

                final comments = snapshot.data!.docs;
                return Expanded(
                  child: ListView(
                    children: comments.map((comment) {
                      return ListTile(
                        title: Text(comment['userEmail']),
                        subtitle: Text(comment['comment']),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // Row contenant le bouton pour ajouter un commentaire et rejoindre la publication
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Afficher un dialog pour ajouter un commentaire
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Ajouter un commentaire"),
                      content: TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                            hintText: "Écrivez votre commentaire ici"),
                        maxLines: 2,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Fermer le dialog
                          },
                          child: const Text("Annuler"),
                        ),
                        TextButton(
                          onPressed: () {
                            sendComment(); // Envoyer le commentaire
                            Navigator.pop(context); // Fermer le dialog
                          },
                          child: const Text("Envoyer"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                width: 90,
                height: 70,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
                ),
                child: Icon(
                  Iconsax.message,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: isJoined
                  ? null
                  : joinPost, // Empêche de rejoindre si déjà fait
              child: Container(
                width: 150,
                height: 70,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: isJoined
                      ? Colors.grey
                      : Colors.black, // Grise si déjà rejoint
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
                ),
                child: Center(
                  child: Text(
                    isJoined ? 'Joined' : 'Join now',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
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
