
class Loaner {
  String? first_name;
  String? last_name;
  final String id;
  String? phone_number;
  // final DateTime req_date;

  Loaner(this.id, this.first_name, this.last_name, this.phone_number, /*this.req_date*/ );
  Loaner.withId(this.id);
  String get_id() {
    return id;
  }
  String get_first_name() {
    return first_name!;
  }
  String get_last_name() {
    return last_name!;
  }
  String get_phone_number() {
    return phone_number!;
  }


  factory Loaner.fromDocument(Map<String, dynamic> doc, String docId) {
    return Loaner(docId, doc['first_name'], doc['last_name'],doc['phone_number']);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};

    if (first_name != null && first_name!.isNotEmpty) {
      data['first_name'] = first_name;
    }
    if (last_name != null && last_name!.isNotEmpty) {
      data['last_name'] = last_name;
    }
    if (phone_number != null && phone_number!.isNotEmpty) {
      data['phone_number'] = phone_number;
    }
    return data;
  }

}
