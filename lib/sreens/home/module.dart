import 'package:flutter/material.dart';

class Module extends StatelessWidget {
  const Module({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            height: 40,
            width: 90,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40), color: Colors.black),
            child: const Center(
                child: Text(
              'For you',
              style: TextStyle(color: Colors.white),
            )),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            height: 40,
            width: 90,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40), color: Colors.black),
            child: const Center(
                child: Text(
              'For you',
              style: TextStyle(color: Colors.white),
            )),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            height: 40,
            width: 90,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40), color: Colors.black),
            child: const Center(
                child: Text(
              'For you',
              style: TextStyle(color: Colors.white),
            )),
          ),
        ],
      ),
    );
  }
}
