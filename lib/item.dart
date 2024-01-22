class Item {
  final int id;
  final String name;
  final double price;
  final String currency;
  final String lastSold;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.lastSold,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: _parseDouble(json['price']),
      currency: json['currency'] ?? '',
      lastSold: json['last_sold'] ?? '',
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        print("Error parsing double from string: $e");
      }
    }
    return 0.0; // Default value if parsing fails
  }
}
