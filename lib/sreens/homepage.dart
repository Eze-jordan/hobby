import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hobby/sreens/bottom.dart';
import 'package:iconsax/iconsax.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String userEmail = '';
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const CreatePage(),
    const SearchPage(),
    const ChatPage(),
  ];

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  // Fonction pour obtenir l'email de l'utilisateur connecté
  void _getUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? '';
      });
    } else {
      setState(() {
        userEmail = 'No user logged in';
      });
    }
  }

  // Fonction pour gérer la navigation entre les pages

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
              const SizedBox(height: 20),
              // Display the selected page
              Expanded(
                child: _pages[_selectedIndex],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Bottom());
  }
}

// Placeholder pages for the navigation items
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home Page',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Create Page',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Search Page',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Chat Page',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
