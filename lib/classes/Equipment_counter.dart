
class Equipment_counter {
  String name;
  int quantity;
  bool switch_on;
  Equipment_counter(this.name, this.quantity, this.switch_on);
}

class Equipment_summary {
  String name;
  int quantity_total;
  int current_quantity;
  Map<String,dynamic>? equipment = {};

  Equipment_summary(this.name, this.quantity_total, this.current_quantity, this.equipment);

  factory Equipment_summary.fromDocument(Map<String, dynamic> doc, String docId) {
    return Equipment_summary( docId, doc['quantity'] ?? 0,(doc['current_quantity'] ?? 0),
    doc['loaned'] ?? null);
  }
}