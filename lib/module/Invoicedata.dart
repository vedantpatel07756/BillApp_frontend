class Invoice {
  final int id;
  final int partyId;
  final String invoiceDate;
  final String totalAmount;
  final String status;
  final String itemId;
  final String quantity;
  final String unitPrice;

  Invoice({
    required this.id,
    required this.partyId,
    required this.invoiceDate,
    required this.totalAmount,
    required this.status,
    required this.itemId,
    required this.quantity,
    required this.unitPrice,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      partyId: json['party_id'],
      invoiceDate: json['invoice_date'],
      totalAmount: json['total_amount'],
      status: json['status'],
      itemId: json['item_id'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'],
    );
  }
}