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

  factory Article.fromJson(Map<String, dynamic> m) {
    return Article(
      id: m['id'] as int? ?? 0,
      title: m['title']?.toString() ?? 'Sans titre',
      description: m['description']?.toString() ?? 'Pas de description',
      price: (m['price'] ?? 0).toDouble(),
      // Gère à la fois l'ancien format Platzi et le nouveau format Supabase
      category: m['category'] is Map<String, dynamic>
          ? (m['category']['name'] ?? '').toString()
          : m['category']?.toString() ?? 'Inconnue',
      image: m['image']?.toString() ??
          (m['images'] is List && (m['images'] as List).isNotEmpty
              ? (m['images'] as List).first.toString()
              : ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'image': image,
    };
  }
}
