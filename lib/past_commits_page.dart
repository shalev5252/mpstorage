import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'design_features.dart';
import 'classes/Loans.dart';

class PastCommitPage extends StatefulWidget {
  const PastCommitPage({super.key});

  @override
  State<PastCommitPage> createState() => _PastCommitPageState();
}

class _PastCommitPageState extends State<PastCommitPage> {
  List<Loan> loans = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initializeFirebaseAndFetchLoans();
  }
  Future<void> _initializeFirebaseAndFetchLoans() async {
    try {
      await Firebase.initializeApp();
      print('Firebase initialized');
      List<Loan> fetchedLoans = await getLast50Loans();
      setState(() {
        loans = fetchedLoans;
        _loading = false;
      });
      print('Loans fetched: ${loans.length}');
    } catch (e) {
      print('Error initializing Firebase or fetching loans: $e');
      setState(() {
        _loading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: buttonsAppbarColors,
        title: Hero(
            tag: "past commits",
            child: Center(
                child: Text('החתמות עבר', style: labelTextStyle))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColorStyle),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(color: textColorStyle),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: loans.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Center(child: Text('${loans[index].date}',style: tableTextStyle)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: buttonsAppbarColors,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                      Column(
                        children: [
                          Text('${loans[index].loanerName} (${loans[index].loanerId})', style: userMenuTextStyle),
                          Text('${loans[index].logistics}', style: userMenuTextStyle),
                          Text('${loans[index].products.toString()}', style: userMenuTextStyle),
                        ],
                      )
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}