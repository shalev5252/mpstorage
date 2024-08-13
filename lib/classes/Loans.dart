import 'package:cloud_firestore/cloud_firestore.dart';

class Loan {
  String date;
  String loanerId;
  String loanerName;
  String logistics;
  Map<String, int>? products;

  Loan(this.date, this.loanerId, this.loanerName, this.logistics, this.products);

  factory Loan.fromDocumentSnapshot(DocumentSnapshot doc, String loanerName) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Loan(
      doc.id,
      data['loaner'],
      loanerName,
      data['logistic'],
      Map<String, int>.from(data['items']),
    );
  }
}

Future<List<Loan>> getLast50Loans() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('loans')
        .orderBy('created_at', descending: true)
        .limit(50)
        .get();
    List<Loan> loans = [];
    for (var doc in querySnapshot.docs) {
      String loanerId = doc['loaner'];
      DocumentSnapshot loanerSnapshot = await FirebaseFirestore.instance
          .collection('loaners')
          .doc(loanerId)
          .get();
      String loanerName = loanerSnapshot.exists ? (loanerSnapshot['first_name'] as String) + " " + (loanerSnapshot['last_name'] as String)  : 'Unknown';
      loans.add(Loan.fromDocumentSnapshot(doc, loanerName));
    }
    return loans;
  } catch (e) {
    print('Error fetching loans: $e');
    return [];
  }
}