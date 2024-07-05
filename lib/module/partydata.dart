class PartyData {
  final int id;
  final String name;
  final String contactNumber;
  final String gstNumber;
  final String panNumber;
  final String type;
  final int balance;
  final String task;

  PartyData({
    required this.id,
    required this.name,
    required this.contactNumber,
    required this.gstNumber,
    required this.panNumber,
    required this.type,
    required this.balance,
    required this.task,
  });

  

  factory PartyData.fromJson(Map<String, dynamic> json) {
    return PartyData(
      id: json['id'],
      name: json['name'],
      contactNumber: json['contact_number'],
      gstNumber: json['gst_number'],
      panNumber: json['pan_number'],
      type: json['type'],
      balance: json['balance'],
      task: json['task'],
    );
  }
}
