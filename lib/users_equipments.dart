import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

import 'design_features.dart';

class LoanerEquipmentSummary {
  String loanerId;
  String loanerName;
  Map<String, int> loaned;
  String phone;

  LoanerEquipmentSummary(
      this.loanerId, this.loanerName, this.loaned, this.phone);
}

class UserEquipmentPage extends StatefulWidget {
  const UserEquipmentPage({super.key});

  @override
  State<UserEquipmentPage> createState() => _UserEquipmentPageState();
}

class _UserEquipmentPageState extends State<UserEquipmentPage> {
  List<LoanerEquipmentSummary> items = [];
  List<String> equipmentNames = [];
  bool _loading = true;
  bool _ascendingOrder = true; // State variable to track sorting order

  @override
  void initState() {
    super.initState();
    _fetchEquipmentNames().then((_) => _fetchLoanerData());
  }

  Future<void> _fetchEquipmentNames() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('equipment').get();
      List<String> names = querySnapshot.docs.map((doc) => doc.id).toList();

      // Sort equipment names lexicographically
      names.sort();

      setState(() {
        equipmentNames = names;
      });
    } catch (e) {
      print('Error fetching equipment names: $e');
    }
  }

  Future<void> _fetchLoanerData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('loaners').get();
      List<LoanerEquipmentSummary> summaries = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Map<String, int> loaned = {};
        if (data['equipment'] != null) {
          loaned = (data['equipment'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value as int));
        }
        return LoanerEquipmentSummary(
            doc.id,
            "${data['first_name']} ${data['last_name']}",
            loaned,
            data['phone_number'] ?? "");
      }).toList();

      // Sort loaner summaries lexicographically by loanerId
      _sortItems(summaries);

      setState(() {
        items = summaries;
        _loading = false;
      });
    } catch (e) {
      print('Error fetching loaner data: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  void _sortItems(List<LoanerEquipmentSummary> summaries) {
    if (_ascendingOrder) {
      summaries.sort((a, b) => a.loanerName.compareTo(b.loanerName));
    } else {
      summaries.sort((a, b) => b.loanerName.compareTo(a.loanerName));
    }
  }

  void _toggleSortOrder() {
    setState(() {
      _ascendingOrder = !_ascendingOrder;
      _sortItems(items);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: buttonsAppbarColors,
        title: Hero(
            tag: "loan tables",
            child: Center(child: Text('חתימות', style: labelTextStyle))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColorStyle),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(color: textColorStyle),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : HorizontalDataTable(
              leftHandSideColumnWidth: MediaQuery.sizeOf(context).width * 0.4,
              rightHandSideColumnWidth: 150.0 * equipmentNames.length,
              isFixedHeader: true,
              headerWidgets: _getTitleWidget(),
              leftSideItemBuilder: _generateFirstColumnRow,
              rightSideItemBuilder: _generateRightHandSideColumnRow,
              itemCount: items.length,
              rowSeparatorWidget: const Divider(
                color: Colors.black38,
                height: 1.0,
                thickness: 1.0,
              ),
              leftHandSideColBackgroundColor: buttonsAppbarColors,
              rightHandSideColBackgroundColor: Colors.white,
              itemExtent: 55,
            ),
    );
  }

  List<Widget> _getTitleWidget() {
    List<Widget> widgets = [
      GestureDetector(
        onLongPress: _toggleSortOrder,
        child: _getTitleItemWidget(
          'שם',
          100,
          icon: _ascendingOrder ? Icons.arrow_upward : Icons.arrow_downward,
        ),
      ),
    ];
    for (String name in equipmentNames) {
      widgets.add(_getTitleItemWidget(name, 150));
    }
    return widgets;
  }

  Widget _getTitleItemWidget(String label, double width, {IconData? icon}) {
    return Container(
      color: buttonsAppbarColors,
      width: width,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, textAlign: TextAlign.center, style: userMenuTextStyle),
          if (icon != null) ...[
            const SizedBox(width: 5),
            Icon(icon, size: 16, color: Colors.black),
          ],
        ],
      ),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
        color: buttonsAppbarColors,
        width: 100,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.center,
        child: GestureDetector(
          onLongPress: () => {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: const Text('פרטי החותם'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('שם: ${items[index].loanerName}',
                              textAlign: TextAlign.center),
                          SizedBox(height: 5),
                          Text('תעודת זהות: ${items[index].loanerId}'),
                          SizedBox(height: 5),
                          Text('טלפון: ${items[index].phone}'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('ביטול'),
                        ),
                        TextButton(
                          onPressed: () async {
                            String phone_number =
                                items[index].phone.replaceFirst('0', '+972');
                            final Uri url = Uri(
                              scheme: 'tel',
                              path: phone_number,
                            );
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              print("cannot launch");
                            }
                          },
                          child: const Text('התקשר'),
                        ),
                        TextButton(
                          onPressed: () {
                            String phone_number =
                                items[index].phone.replaceFirst('0', '+972');
                            final Uri url =
                                Uri.parse('https://wa.me/${phone_number}');
                            launchUrl(url);
                          },
                          child: const Text('וואטסאפ'),
                        ),
                      ]);
                })
          },
          child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
              child: Column(children: [
                Text(items[index].loanerName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    )),
                Text(items[index].loanerId,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )),
              ])),
        ));
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: equipmentNames.map((name) {
        int quantity = 0;

        if (items[index].loaned.containsKey(name)) {
          quantity = items[index].loaned[name]!;
        }

        return Container(
          width: 150,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          child: Text(quantity.toString(),
              style: userMenuTextStyle, textAlign: TextAlign.center),
        );
      }).toList(),
    );
  }
}
