import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool showExpanded = false;
  Map<String, String>? expandedContent;

  final Color beige = const Color(0xFFD6B68A);

  final List<Map<String, String>> myArtworks = [
    {
      "title": "Sunset Streets",
      "image": "assets/art1.jpg",
      "description": "A street lit up in golden hour hues.",
    },
    {
      "title": "Visayan Calm",
      "image": "assets/art4.jpg",
      "description": "Tranquil ocean and sky scene.",
    },
  ];

  final List<Map<String, String>> likedPosts = [
    {
      "title": "Metro Manila Vibes",
      "image": "assets/art3.jpg",
      "description": "Urban rush and blur painted vividly.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _expandItem(Map<String, String> data) {
    setState(() {
      expandedContent = data;
      showExpanded = true;
    });
  }

  void _closeExpanded() {
    setState(() {
      showExpanded = false;
      Future.delayed(const Duration(milliseconds: 200), () {
        expandedContent = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E3239),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: Stack(
          children: [
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  /// Back Button
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
                  Text(
                    'Your Name',
                    style: TextStyle(color: beige, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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
                        icon: Icon(Icons.edit, size: 16, color: beige),
                        label: Text("Edit Profile", style: TextStyle(color: beige)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: beige),
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.settings, color: beige),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: const Color(0xFF2E3239),
                            builder: (_) => Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Settings', style: TextStyle(color: beige, fontSize: 18)),
                                  Divider(color: beige.withOpacity(0.4)),
                                  ListTile(
                                    title: Text("Dark Mode", style: TextStyle(color: beige)),
                                    trailing: Switch(value: true, onChanged: (_) {}),
                                  ),
                                  ListTile(
                                    title: Text("Logout", style: TextStyle(color: beige)),
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),

                  const SizedBox(height: 12),

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
                        _buildScrollableTab(myArtworks),
                        _buildScrollableTab(likedPosts),
                        _buildAnalytics(),
                      ],
                    ),
                  )
                ],
              ),
            ),

            if (expandedContent != null)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeExpanded,
                  child: Stack(
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: showExpanded ? 1.0 : 0.0,
                        child: Container(color: Colors.black.withOpacity(0.4)),
                      ),
                      Positioned(
                        top: 90,
                        left: 16,
                        right: 16,
                        bottom: 80,
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 300),
                          scale: showExpanded ? 1.0 : 0.95,
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
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: _buildImage(expandedContent!["image"]),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    expandedContent!["title"]!,
                                    style: TextStyle(
                                      color: beige,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    expandedContent!["description"]!,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                    textAlign: TextAlign.center,
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
      ),
    );
  }

  Widget _buildScrollableTab(List<Map<String, String>> items) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100, top: 20),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items.map((item) {
            return GestureDetector(
              onTap: () => _expandItem(item),
              child: Container(
                width: (MediaQuery.of(context).size.width - 52) / 2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      SizedBox(height: 160, child: _buildImage(item["image"])),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          color: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            item["title"]!,
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
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildImage(String? path) {
    if (path == null) {
      return const Icon(Icons.image, color: Colors.white30, size: 60);
    }
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.black12,
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported, color: Colors.white30, size: 60),
      ),
    );
  }

  Widget _buildAnalytics() {
  final List<String> labels = ['Views', 'Likes', 'Shares'];
  final List<int> values = [1250, 435, 72];

  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Engagement Analytics",
            style: TextStyle(color: beige, fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
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
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(color: Colors.white70, fontSize: 10),
                        );
                      },
                      interval: 200,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final index = value.toInt();
                        return Text(
                          labels[index],
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(3, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: values[i].toDouble(),
                        color: beige,
                        width: 20,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "This chart shows your engagement stats: views, likes, and shares.",
            style: const TextStyle(color: Colors.white70, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
}