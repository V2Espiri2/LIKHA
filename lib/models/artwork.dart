class Artwork {
  final String title;
  final String imagePath;
  final String artistName;
  final String description;
  final String category;
  bool liked;
  bool followed;

  Artwork({
    required this.title,
    required this.imagePath,
    required this.artistName,
    required this.description,
    required this.category,
    this.liked = false,
    this.followed = false,
  });
}
