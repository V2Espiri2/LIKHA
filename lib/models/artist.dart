class Artist {
  final String name;
  final String image;
  final String bio;
  final String popularity;
  bool followed;

  Artist({
    required this.name,
    required this.image,
    required this.bio,
    required this.popularity,
    this.followed = false,
  });
}
