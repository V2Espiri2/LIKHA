import 'package:flutter/material.dart';
import 'gallery_screen.dart';
import 'artist_screen.dart';
import '../data/artwork_data.dart';
import '../models/artwork.dart';
import '../widgets/likha_top_bar.dart';
import '../util/image_helper.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedTab = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const GalleryScreen(),
    const ArtistScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF2E3239),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Gallery'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Artists'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Artwork> recommended = ArtworkData.artworks.take(8).toList();

  Artwork? expandedCard;
  bool showExpanded = false;
  int? tappedIndex;

  void _expandCard(int index) {
    setState(() {
      tappedIndex = index;
      expandedCard = recommended[index];
      showExpanded = true;
    });
  }

  void _closeCard() {
    setState(() {
      showExpanded = false;
      Future.delayed(const Duration(milliseconds: 250), () {
        setState(() {
          tappedIndex = null;
          expandedCard = null;
        });
      });
    });
  }

  void _toggleLike(int index) {
    setState(() {
      recommended[index].liked = !recommended[index].liked;
    });
  }

  void _toggleFollow(int index) {
    setState(() {
      recommended[index].followed = !recommended[index].followed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const double topPadding = 90;
    const double bottomPadding = 80;

    return Scaffold(
      backgroundColor: const Color(0xFF2E3239),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LikhaTopBar(),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'FEATURED ARTIST OF THE MONTH',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          height: size.width * 0.6,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: Stack(
                            children: [
                              buildSafeImage("assets/artist.jpg"),
                              _buildLabel("Juan Dela Cruz"),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          height: size.width * 0.6,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: Stack(
                            children: [
                              buildSafeImage("assets/art1.jpg"),
                              _buildLabel("Luzon Lights"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Juan Dela Cruz is a renowned street artist exploring Filipino urban identity.',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Recommended For You',
                    style: TextStyle(
                      color: Color(0xFFCDC0AE),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...recommended.asMap().entries.map((entry) {
                    final index = entry.key;
                    final art = entry.value;
                    return GestureDetector(
                      onTap: () => _expandCard(index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Column(
                          children: [
                            buildSafeImage(art.imagePath, height: 180),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(art.title, style: const TextStyle(color: Colors.white)),
                                  IconButton(
                                    icon: Icon(
                                      art.liked ? Icons.favorite : Icons.favorite_border,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () => _toggleLike(index),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          if (expandedCard != null)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeCard,
                child: Stack(
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: showExpanded ? 1.0 : 0.0,
                      child: Container(color: Colors.black.withOpacity(0.4)),
                    ),
                    Positioned(
                      top: topPadding,
                      left: 16,
                      right: 16,
                      bottom: bottomPadding,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 300),
                        scale: showExpanded ? 1.0 : 0.95,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: showExpanded ? 1.0 : 0.0,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3A3F47),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: buildSafeImage(expandedCard!.imagePath),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      expandedCard!.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "by ${expandedCard!.artistName}",
                                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      expandedCard!.description,
                                      style: const TextStyle(
                                        color: Colors.white60,
                                        fontSize: 13,
                                        height: 1.4,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            expandedCard!.liked ? Icons.favorite : Icons.favorite_border,
                                            color: Colors.redAccent,
                                          ),
                                          onPressed: () => _toggleLike(tappedIndex!),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton.icon(
                                          icon: Icon(
                                            expandedCard!.followed ? Icons.check : Icons.person_add,
                                            color: Colors.white,
                                          ),
                                          label: Text(
                                            expandedCard!.followed ? "Following" : "Follow",
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[700],
                                          ),
                                          onPressed: () => _toggleFollow(tappedIndex!),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: const Icon(Icons.comment, color: Colors.white),
                                          onPressed: () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text("Comment feature coming soon"),
                                                backgroundColor: Colors.black87,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.close, color: Colors.white),
                                    onPressed: _closeCard,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
