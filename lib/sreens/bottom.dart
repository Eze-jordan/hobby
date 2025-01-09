import 'package:flutter/material.dart';
import 'package:hobby/sreens/create.dart';
import 'package:hobby/sreens/searchpage.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> navItems = [
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.add, 'label': 'Add'},
    {'icon': Icons.search, 'label': 'Search'},
    {'icon': Icons.send, 'label': 'Send'},
  ];

  final List<Widget> pages = [
    const Homepage(), // Page principale
    const Create(), // Page pour Create
    const SearchPage(), // Page de recherche
    const SendPage(), // Page d'envoi
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Les pages derrière la nav bar
          IndexedStack(
            index: selectedIndex,
            children: pages,
          ),
          // La nav bar
          Positioned(
            bottom: 16, // Position en bas
            left: 35,
            right: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Conteneur actif
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 60,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        navItems[selectedIndex]['icon'],
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        navItems[selectedIndex]['label'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Icônes restantes
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(navItems.length, (index) {
                      if (index == selectedIndex)
                        return const SizedBox.shrink();

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            navItems[index]['icon'],
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Homepage();
  }
}

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Create();
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Searchpage();
  }
}

class SendPage extends StatelessWidget {
  const SendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Send Page',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
