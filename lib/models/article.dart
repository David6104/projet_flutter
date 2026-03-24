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

  // CORRECTION : Renommé en fromJson et adapté pour lire à la fois depuis l'API et depuis SharedPreferences
  factory Article.fromJson(Map<String, dynamic> m) {
    return Article(
      id: m['id'] as int,
      title: m['title'] as String,
      description: m['description'] as String,
      price: (m['price'] as num).toDouble(),
      category: m['category'] is Map<String, dynamic>
          ? (m['category']['name'] ?? '').toString()
          : m['category']?.toString() ?? 'Inconnue',
      // Gère le format API (liste "images") et le format Local (string "image")
      image: m['image'] ??
          (m['images'] is List && (m['images'] as List).isNotEmpty
              ? (m['images'] as List).first.toString()
              : ''),
    );
  }

  // CORRECTION : Ajout de la méthode toMap() indispensable pour SharedPreferences
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
