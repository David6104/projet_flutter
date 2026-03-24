class Article {
  final int id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String image;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
  });

  factory Article.fromMap(Map<String, dynamic> m) {
    return Article(
      id: m['id'] as int,
      title: m['title'] as String,
      description: m['description'] as String,
      price: (m['price'] as num).toDouble(),
      category: m['category'] is Map<String, dynamic>
          ? (m['category']['name'] ?? '').toString()
          : m['category'].toString(),
      image: m['images'] is List && (m['images'] as List).isNotEmpty
          ? (m['images'] as List).first.toString()
          : '',
    );
  }
}
