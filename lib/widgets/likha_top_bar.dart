import 'package:flutter/material.dart';
import '../screens/profile_screen.dart';

class LikhaTopBar extends StatelessWidget {
  const LikhaTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFCDC0AE), // Beige background
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Text(
            'LIKHA',
            style: TextStyle(
              color: Color(0xFF2E3239), // Dark text
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 3,
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.black12, // Softer for beige bg
                borderRadius: BorderRadius.circular(20),
              ),
              child: const TextField(
                style: TextStyle(color: Color(0xFF2E3239)),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.black45),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Color(0xFF2E3239)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: const CircleAvatar(
              backgroundColor: Colors.black26,
              child: Icon(Icons.person, color: Color(0xFF2E3239)),
            ),
          ),
        ],
      ),
    );
  }
}
