import 'dart:ui';

class PackingItem {
  final int id;
  final String name;
  final String category;
  final String subCategory;
  final String brand;
  final String variant;
  final int quantity;
  final Color dotColor;
  final String imageUrl;
  final String size;
  final List<String> usedIn;
  final String lastUsed;

  PackingItem({
    required this.id,
    required this.name,
    required this.category,
    required this.subCategory,
    required this.brand,
    required this.variant,
    required this.quantity,
    required this.dotColor,
    required this.imageUrl,
    this.size = '',
    this.usedIn = const [],
    this.lastUsed = '',
  });

  factory PackingItem.fromJson(Map<String, dynamic> json) => PackingItem(
    id: json['id'],
    name: json['name'],
    category: json['category'],
    subCategory: json['subCategory'] ?? '',
    brand: json['brand'],
    variant: json['variant'],
    quantity: json['quantity'],
    dotColor: Color(json['color']),
    imageUrl: json['imageUrl'],
    size: json['size'] ?? '',
    usedIn: List<String>.from(json['usedIn'] ?? []),
    lastUsed: json['lastUsed'] ?? '',
  );
}
