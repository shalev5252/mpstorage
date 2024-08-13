import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'classes/Equipment_counter.dart';
import 'design_features.dart';

class EquipSumPage extends StatefulWidget {
  const EquipSumPage({super.key});

  @override
  State<EquipSumPage> createState() => _EquipSumPageState();
}

class _EquipSumPageState extends State<EquipSumPage> {
  List<Equipment_summary> items = [];
  int? sortColumnIndex;
  bool isAscending = false;
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchEquipmentSummaries();
  }

  void _fetchEquipmentSummaries() async {
    final firestore = FirebaseFirestore.instance;
    try {
      final querySnapshot = await firestore.collection('equipment').get();
      final summaries = querySnapshot.docs.map((doc) {
        return Equipment_summary.fromDocument(doc.data(), doc.id);
      }).toList();
      setState(() {
        items = summaries;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching equipment summaries: $e';
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
              tag: "equipment state",
              child: Center(child: Text('מציבת ציוד', style: labelTextStyle))),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColorStyle),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(color: textColorStyle),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            sortColumnIndex: sortColumnIndex,
                            sortAscending: isAscending,
                            headingRowColor: MaterialStateColor.resolveWith(
                              (states) {
                                return buttonsAppbarColors;
                              },
                            ),
                            border: TableBorder.symmetric(
                                inside: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                outside:
                                    BorderSide(color: Colors.black, width: 2)),
                            columns: [
                              DataColumn(
                                  label:
                                      Text("במחסן", style: userMenuTextStyle),
                                  onSort: sortTable),
                              DataColumn(
                                  label: Text("בחוץ", style: userMenuTextStyle),
                                  onSort: sortTable),
                              DataColumn(
                                  label:
                                      Text("סך הכל", style: userMenuTextStyle),
                                  onSort: sortTable),
                              DataColumn(
                                  label: Text("ציוד", style: userMenuTextStyle),
                                  onSort: sortTable),
                            ],
                            rows: items.asMap().entries.map((entry) {
                              Equipment_summary item = entry.value;
                              return DataRow(
                                onLongPress: () =>
                                    _showAlertDialog(context, item),
                                cells: [
                                  DataCell(Text(
                                      item.current_quantity.toString(),
                                      style: tableTextStyle)),
                                  DataCell(Text(
                                      (item.quantity_total -
                                              item.current_quantity)
                                          .toString(),
                                      style: tableTextStyle)),
                                  DataCell(Text(item.quantity_total.toString(),
                                      style: tableTextStyle)),
                                  DataCell(
                                      Text(item.name, style: tableTextStyle)),
                                ],
                              );
                            }).toList(),
                            dividerThickness: 4,
                          ),
                        ),
                      ],
                    ),
                  ));
  }

  Future<List<Widget>> equipmentToTextWidgets(Map<String, dynamic> equipment) async {
    List<Widget> textWidgets = [];

    for (var entry in equipment.entries) {
      String userId = entry.key;
      dynamic quantity = entry.value;

      // Fetch the first name of the user based on the userId
      String firstName = await fetchUserFirstName(userId);

      // Create a Text widget with the first name and quantity
      textWidgets.add(Text('$firstName: $quantity' , style: tableTextStyle));
      textWidgets.add(SizedBox(height: 10));

    }

    return textWidgets;
  }
  Future<String> fetchUserFirstName(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('loaners').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data()?['first_name'] +" "+ userDoc.data()?['last_name'] ?? 'Unknown';
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return 'Unknown';
  }

  void _showAlertDialog(BuildContext context, Equipment_summary item) async {

    List<Widget> firstNames;
    if (item.equipment != null) {
      firstNames = await equipmentToTextWidgets(item.equipment!);
    }
    else{
      firstNames = [Text('אין חתימות', style: tableTextStyle)];
    }
    showDialog (
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(item.name, style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ))),
          alignment: Alignment.center,
          content: Column(children:
            firstNames,
          ),

          actions: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
        ])
          ],
        );
      },
    );
  }

  void sortTable(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
      if (columnIndex == 1) {
        items.sort((a, b) => (a.quantity_total - a.current_quantity)
            .compareTo(b.quantity_total - b.current_quantity));
      } else if (columnIndex == 0) {
        items.sort((a, b) => a.current_quantity.compareTo(b.current_quantity));
      } else if (columnIndex == 2) {
        items.sort((a, b) => a.quantity_total.compareTo(b.quantity_total));
      } else if (columnIndex == 3) {
        items.sort((a, b) => a.name.compareTo(b.name));
      }
      if (!ascending) {
        items = items.reversed.toList();
      }
    });
  }
}
