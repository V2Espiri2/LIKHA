import 'package:flutter/material.dart';
import '../widgets/likha_top_bar.dart';
import '../util/image_helper.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({super.key});

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  String sortBy = 'Name';
  Map<String, dynamic>? expandedArtist;
  int? tappedIndex;
  bool showExpanded = false;

  final List<Map<String, dynamic>> allArtists = [
    {
      "name": "Juan Dela Cruz",
      "image": "assets/artist.jpg",
      "bio": "Vibrant street artist exploring Filipino urban identity.",
      "popularity": "90",
      "followed": false,
    },
    {
      "name": "Maria Santos",
      "image": "assets/artist.jpg",
      "bio": "Portrait and realism specialist from Batangas.",
      "popularity": "75",
      "followed": false,
    },
    {
      "name": "Alex Rivera",
      "image": "assets/artist.jpg",
      "bio": "Experimental painter with surrealist themes.",
      "popularity": "88",
      "followed": false,
    },
    {
      "name": "Liza Gomez",
      "image": "assets/artist.jpg",
      "bio": "Mixed-media artist known for layered textures.",
      "popularity": "85",
      "followed": false,
    },
    {
      "name": "Carlos Ramos",
      "image": "assets/artist.jpg",
      "bio": "Sculptor merging tradition and modernism.",
      "popularity": "70",
      "followed": false,
    },
    {
      "name": "Ella Navarro",
      "image": "assets/artist.jpg",
      "bio": "Watercolorist inspired by Philippine landscapes.",
      "popularity": "82",
      "followed": false,
    },
    {
      "name": "Danilo Cruz",
      "image": "assets/artist.jpg",
      "bio": "Graffiti artist with bold color statements.",
      "popularity": "78",
      "followed": false,
    },
    {
      "name": "Ana Mendoza",
      "image": "assets/artist.jpg",
      "bio": "Digital art specialist with animated exhibits.",
      "popularity": "80",
      "followed": false,
    },
  ];

  void _expandArtist(int index) {
    setState(() {
      tappedIndex = index;
      expandedArtist = allArtists[index];
      showExpanded = true;
    });
  }

  void _closeExpanded() {
    setState(() {
      showExpanded = false;
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          tappedIndex = null;
          expandedArtist = null;
        });
      });
    });
  }

  void _toggleFollow(int index) {
    setState(() {
      allArtists[index]["followed"] = !allArtists[index]["followed"];
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sorted = [...allArtists];
    if (sortBy == 'Name') {
      sorted.sort((a, b) => a["name"].compareTo(b["name"]));
    } else {
      sorted.sort((a, b) =>
          int.parse(b["popularity"]).compareTo(int.parse(a["popularity"])));
    }

    const double topPadding = 90;
    const double bottomPadding = 80;

    return Scaffold(
      backgroundColor: const Color(0xFF2E3239),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const LikhaTopBar(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropdownButton<String>(
                        value: sortBy,
                        dropdownColor: const Color(0xFF2E3239),
                        style: const TextStyle(color: Colors.white),
                        items: ['Name', 'Popularity']
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text("Sort by $e"),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            sortBy = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: sorted.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        final artist = sorted[index];
                        final realIndex = allArtists.indexOf(artist);

                        return GestureDetector(
                          onTap: () => _expandArtist(realIndex),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                children: [
                                  buildSafeImage(artist["image"]),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      color: Colors.black,
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      child: Text(
                                        artist["name"],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (expandedArtist != null)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeExpanded,
                child: Stack(
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: showExpanded ? 1.0 : 0.0,
                      child: Container(color: Colors.black.withOpacity(0.3)),
                    ),
                    Positioned(
                      top: topPadding,
                      left: 16,
                      right: 16,
                      bottom: bottomPadding,
                      child: GestureDetector(
                        onTap: () {},
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 300),
                          scale: showExpanded ? 1.0 : 0.9,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: showExpanded ? 1.0 : 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF3A3F47),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: buildSafeImage(expandedArtist!["image"]),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        expandedArtist!["name"],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        expandedArtist!["bio"],
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                          height: 1.4,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 12),
                                      const Divider(color: Colors.white30),
                                      const SizedBox(height: 6),
                                      const Text(
                                        "Artworks by this artist:",
                                        style: TextStyle(color: Colors.white, fontSize: 14),
                                      ),
                                      const SizedBox(height: 6),
                                      const Text(
                                        "- Artwork 1\n- Artwork 2\n- Artwork 3",
                                        style: TextStyle(color: Colors.white70, fontSize: 12),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton.icon(
                                        icon: Icon(
                                          expandedArtist!["followed"] ? Icons.check : Icons.person_add,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          expandedArtist!["followed"] ? "Following" : "Follow",
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey[700],
                                        ),
                                        onPressed: () => _toggleFollow(tappedIndex!),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: const Icon(Icons.close, color: Colors.white),
                                      onPressed: _closeExpanded,
                                    ),
                                  ),
                                ],
                              ),
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
}
