import 'package:flutter/material.dart';
import '../widgets/likha_top_bar.dart';
import '../util/image_helper.dart';
import '../data/artwork_data.dart';
import '../models/artwork.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String selectedCategory = 'All';
  String sortBy = 'Title';
  Artwork? expandedArtwork;
  int? tappedIndex;
  bool showExpanded = false;

  List<Artwork> get allArtworks => ArtworkData.artworks;

  void _expandArtwork(int index) {
    setState(() {
      tappedIndex = index;
      expandedArtwork = allArtworks[index];
      showExpanded = true;
    });
  }

  void _closeExpanded() {
    setState(() {
      showExpanded = false;
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          tappedIndex = null;
          expandedArtwork = null;
        });
      });
    });
  }

  void _toggleLike(int index) {
    setState(() {
      allArtworks[index].liked = !allArtworks[index].liked;
    });
  }

  void _toggleFollow(int index) {
    setState(() {
      allArtworks[index].followed = !allArtworks[index].followed;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Artwork> filtered = allArtworks.where((art) {
      if (selectedCategory == 'All') return true;
      return art.category == selectedCategory;
    }).toList();

    if (sortBy == 'Title') {
      filtered.sort((a, b) => a.title.compareTo(b.title));
    }

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        value: selectedCategory,
                        dropdownColor: const Color(0xFF2E3239),
                        style: const TextStyle(color: Colors.white),
                        items: ['All', 'Landscape', 'Portrait', 'Street', 'Sculpture', 'Watercolor', 'Digital']
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                        },
                      ),
                      DropdownButton<String>(
                        value: sortBy,
                        dropdownColor: const Color(0xFF2E3239),
                        style: const TextStyle(color: Colors.white),
                        items: ['Title']
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
                      itemCount: filtered.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        final art = filtered[index];
                        final realIndex = allArtworks.indexOf(art);

                        return GestureDetector(
                          onTap: () => _expandArtwork(realIndex),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                children: [
                                  buildSafeImage(art.imagePath),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      color: Colors.black,
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              art.title,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              art.liked ? Icons.favorite : Icons.favorite_border,
                                              color: Colors.redAccent,
                                              size: 16,
                                            ),
                                            onPressed: () => _toggleLike(realIndex),
                                          ),
                                        ],
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
          if (expandedArtwork != null)
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
                      top: 90,
                      left: 16,
                      right: 16,
                      bottom: 80,
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
                                          child: buildSafeImage(expandedArtwork!.imagePath),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        expandedArtwork!.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "by ${expandedArtwork!.artistName}",
                                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        expandedArtwork!.description,
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
                                              expandedArtwork!.liked ? Icons.favorite : Icons.favorite_border,
                                              color: Colors.redAccent,
                                            ),
                                            onPressed: () => _toggleLike(tappedIndex!),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton.icon(
                                            icon: Icon(
                                              expandedArtwork!.followed ? Icons.check : Icons.person_add,
                                              color: Colors.white,
                                            ),
                                            label: Text(
                                              expandedArtwork!.followed ? "Following" : "Follow",
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
