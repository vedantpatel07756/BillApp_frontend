class ItemData {
  final int id;
  final String name;
  final String quantity;
  final String salesPrice;
  final String purchasePrice;
  final String unit;

  ItemData({
    required this.id,
    required this.name,
    required this.quantity,
    required this.salesPrice,
    required this.purchasePrice,
    required this.unit,
  });

  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      salesPrice: json['sales_price'],
      purchasePrice: json['purchase_price'],
      unit:json['unit'],
    );
  }
  
}
