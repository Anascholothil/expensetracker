class ExpenseModel {
  final String id;
  final String item;
  final double price;
  final String type;

  ExpenseModel({
    required this.id,
    required this.item,
    required this.price,
    required this.type,
  });

  ExpenseModel copyWith({
    String? id,
    String? item,
    double? price,
    String? type,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      item: item ?? this.item,
      price: price ?? this.price,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item': item,
      'price': price,
      'type': type,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] as String,
      item: map['item'] as String,
      price: (map['price'] as num).toDouble(),
      type: map['type'] as String,
    );
  }
}
