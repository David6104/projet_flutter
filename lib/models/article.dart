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

  factory Article.fromJson(Map<String, dynamic> json) {
    // 1. Gestion robuste Catégorie (L'API Platzi renvoie un objet)
    String parsedCategory = 'Non classé';
    if (json['category'] != null) {
      if (json['category'] is String) {
        parsedCategory = json['category'];
      } else if (json['category'] is Map) {
        parsedCategory = json['category']['name'] ?? 'Non classé';
      }
    }

    // 2. Gestion robuste Prix
    double parsedPrice = 0.0;
    if (json['price'] != null) {
      if (json['price'] is num) {
        parsedPrice = (json['price'] as num).toDouble();
      } else if (json['price'] is String) {
        parsedPrice = double.tryParse(json['price']) ?? 0.0;
      }
    }

    // 3. Gestion Image (L'API Platzi renvoie un tableau avec parfois des guillemets en trop)
    String parsedImage = '';
    if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      parsedImage =
          json['images'][0].toString().replaceAll(RegExp(r'[\[\]"]'), '');
    } else if (json['image'] != null) {
      parsedImage = json['image'];
    }

    return Article(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Sans titre',
      description: json['description'] ?? '',
      price: parsedPrice,
      category: parsedCategory,
      image: parsedImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'categoryId': 1, // L'API Platzi exige un ID de catégorie
      'images': [image],
    };
  }
}
