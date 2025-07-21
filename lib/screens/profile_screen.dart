import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/artwork_data.dart';
import '../data/artist_data.dart';
import '../models/artwork.dart';
import '../models/artist.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final Color beige = const Color(0xFFD6B68A);
  final String currentUser = "You";

  Artwork? expandedArtwork;
  Artist? expandedArtist;
  bool showExpanded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  List<Artwork> get myArtworks =>
      ArtworkData.artworks.where((art) => art.artistName == currentUser).toList();

  List<Artwork> get likedArtworks =>
      ArtworkData.artworks.where((art) => art.liked).toList();

  List<Artist> get followedArtists =>
      ArtistData.artists.where((artist) => artist.followed).toList();

  void _expandArtwork(Artwork art) {
    setState(() {
      expandedArtwork = art;
      showExpanded = true;
    });
  }

  void _expandArtist(Artist artist) {
    setState(() {
      expandedArtist = artist;
      showExpanded = true;
    });
  }

  void _closeExpanded() {
    setState(() {
      showExpanded = false;
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          expandedArtwork = null;
          expandedArtist = null;
        });
      });
    });
  }

  void _showFollowingModal() {
    final artists = followedArtists;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2E3239),
      builder: (_) {
        return artists.isEmpty
            ? SizedBox(
                height: 120,
                child: Center(
                  child: Text("You're not following any artists.", style: TextStyle(color: beige)),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: artists.map((artist) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _expandArtist(artist);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(artist.image),
                            onBackgroundImageError: (_, __) {},
                            backgroundColor: Colors.grey[700],
                            child: Image.asset(
                              artist.image,
                              errorBuilder: (_, __, ___) => const Icon(Icons.person, color: Colors.white),
                            ),
                          ),
                          title: Text(artist.name, style: TextStyle(color: beige)),
                          subtitle: Text(artist.bio, style: const TextStyle(color: Colors.white70)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E3239),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: beige),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const CircleAvatar(
                radius: 36,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, size: 36, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(currentUser,
                  style: TextStyle(color: beige, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              const Text(
                'Digital Illustrator | Street Artist',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    icon: Icon(Icons.edit, color: beige, size: 16),
                    label: Text("Edit Profile", style: TextStyle(color: beige)),
                    style: OutlinedButton.styleFrom(side: BorderSide(color: beige)),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    icon: Icon(Icons.people, color: beige, size: 16),
                    label: Text("Following", style: TextStyle(color: beige)),
                    style: OutlinedButton.styleFrom(side: BorderSide(color: beige)),
                    onPressed: _showFollowingModal,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TabBar(
                controller: _tabController,
                indicatorColor: beige,
                labelColor: beige,
                unselectedLabelColor: Colors.white70,
                tabs: const [
                  Tab(icon: Icon(Icons.palette), text: "My Art"),
                  Tab(icon: Icon(Icons.favorite), text: "Liked"),
                  Tab(icon: Icon(Icons.bar_chart), text: "Analytics"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildArtworkGrid(myArtworks),
                    _buildArtworkGrid(likedArtworks),
                    _buildAnalyticsTab(),
                  ],
                ),
              ),
            ],
          ),
          if (expandedArtwork != null) _buildExpandedArtwork(),
          if (expandedArtist != null) _buildExpandedArtist(),
        ],
      ),
    );
  }

  Widget _buildArtworkGrid(List<Artwork> artworks) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: artworks.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final art = artworks[index];
        return GestureDetector(
          onTap: () => _expandArtwork(art),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Image.asset(
                    art.imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.broken_image, color: Colors.white30, size: 48),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        art.title,
                        style: const TextStyle(color: Colors.white),
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
    );
  }

  Widget _buildExpandedArtwork() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: _closeExpanded,
        child: Stack(
          children: [
            Container(color: Colors.black.withOpacity(0.3)),
            Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3F47),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        expandedArtwork!.imagePath,
                        fit: BoxFit.cover,
                        height: 180,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported, size: 80, color: Colors.white30),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      expandedArtwork!.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      expandedArtwork!.description,
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: _closeExpanded,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedArtist() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: _closeExpanded,
        child: Stack(
          children: [
            Container(color: Colors.black.withOpacity(0.3)),
            Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3F47),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        expandedArtist!.image,
                        fit: BoxFit.cover,
                        height: 180,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.person, size: 80, color: Colors.white30),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      expandedArtist!.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      expandedArtist!.bio,
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: _closeExpanded,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    final List<String> labels = ['Views', 'Likes', 'Shares'];
    final List<int> values = [1250, 435, 72];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Engagement Analytics",
              style: TextStyle(color: beige, fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 1400,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, _) {
                      return Text(value.toInt().toString(),
                          style: const TextStyle(color: Colors.white70, fontSize: 10));
                    }, interval: 200),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, _) {
                      return Text(labels[value.toInt()],
                          style: const TextStyle(color: Colors.white, fontSize: 12));
                    }),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(3, (i) {
                  return BarChartGroupData(x: i, barRods: [
                    BarChartRodData(
                      toY: values[i].toDouble(),
                      color: beige,
                      width: 20,
                      borderRadius: BorderRadius.circular(4),
                    )
                  ]);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
