class DonationItem {
  final String imageUrl;
  final String name;
  final String description;
  final String category;
  final String location;

  DonationItem({
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.category,
    required this.location,
  });

  factory DonationItem.fromJson(Map<String, dynamic> json) {
    return DonationItem(
      imageUrl: json['image'] ?? '', // assuming image is a direct URL
      name: json['name'],
      description: json['description'],
      category: json['category'],
      location: json['address'], // using address as location
    );
  }
}
