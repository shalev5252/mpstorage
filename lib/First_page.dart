import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mpstorage/widgets/animated_toggle_switch.dart';
import 'design_features.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class _FirstPageState extends State<FirstPage> {
  String dropdownValue = list.first;

  bool _isSwitchedOn = false;
  bool addNewEquipment = false;
  String? _selectedValue;
  final TextEditingController _equipmentController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String? errorMessage;
  List<String> _equipmentNames = [];

  @override
  void initState() {
    super.initState();
    _fetchEquipmentNames();
  }

  void _handleToggleSwitchChanged(bool newValue) {
    setState(() {
      _isSwitchedOn = newValue;
    });
  }

  void _fetchEquipmentNames() async {
    final firestore = FirebaseFirestore.instance;
    try {
      final querySnapshot = await firestore.collection('equipment').get();
      final names = querySnapshot.docs.map((doc) => doc.id).toList();
      setState(() {
        _equipmentNames = names;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching equipment names: $e';
      });
    }
  }

  Future<void> _handleSubmit() async {
    final firestore = FirebaseFirestore.instance;
    try {
      final equipmentName = addNewEquipment ? _equipmentController.text : _selectedValue;
      final quantityStr = _quantityController.text;
      if (equipmentName == null || equipmentName.isEmpty) {
        setState(() => errorMessage = 'שם הציוד לא יכול להיות ריק');
        return;
      }
      final quantity = int.tryParse(quantityStr);
      if (quantity == null || quantity < 0) {
        setState(() => errorMessage = 'כמות לא תקינה');
        return;
      }

      final change = FieldValue.increment(_isSwitchedOn ? -quantity : quantity);
      await firestore.collection("equipment").doc(equipmentName).set({
        "quantity": change,
        "current_quantity": change,
      }, SetOptions(merge: true));

      _quantityController.clear();
      if (addNewEquipment) {
        _fetchEquipmentNames();
        _equipmentController.clear();
        setState(() {
          addNewEquipment = false;
          _selectedValue = null;
        });
      }

      setState(() => errorMessage = null);

      // Success dialog (שומר על הסטייל שלך לטקסטים)
      // הוספתי רק רקע כהה וניגודיות טובה.
      // טיפ: אפשר לשים Theme(data: ...) סביב ה-AlertDialog אם תרצה שליטה גלובלית.
      // כאן זה מקומי כדי לא לשנות עמודים אחרים.
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Center(
            child: Text(
              'הפעולה בוצעה',
              style: labelTextStyle.copyWith(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text('הציוד עודכן בהצלחה', style: tableTextStyle.copyWith(color: Colors.white70))],
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('אישור'),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() => errorMessage = 'Error: $e');
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Center(
            child: Text(
              'הפעולה נכשלה',
              style: labelTextStyle.copyWith(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
            ),
          ),
          content: Text('הפעולה נכשלה, נסה שנית', style: tableTextStyle.copyWith(color: Colors.white70)),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('אישור'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _equipmentController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: buttonsAppbarColors,
        title: Hero(
          tag: "add storage eq",
          child: Center(child: Text('הוספת ציוד לאחסון', style: labelTextStyle)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColorStyle),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(color: textColorStyle),
      ),
      body: Container(
        // רקע גרדיאנט כהה ונעים
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          ),
        ),
        child: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      Center(child: ToggleSwitch(onChanged: _handleToggleSwitchChanged)),
                      const SizedBox(height: 24),

                      // בחירה מתוך רשימת ציוד
                      _CardShell(
                        child: DropdownMenu(
                          enableFilter: true,
                          requestFocusOnTap: true,
                          menuHeight: 300,
                          width: MediaQuery.sizeOf(context).width * 0.75,
                          label: Text("בחר אפשרות",
                              style: labelTextStyle.copyWith(color: Colors.white70)),
                          textStyle: labelTextStyle.copyWith(color: Colors.white),
                          inputDecorationTheme: const InputDecorationTheme(border: InputBorder.none),
                          filterCallback: (List<DropdownMenuEntry<dynamic>> items, String? filter) {
                            if (filter == null || filter.isEmpty) return items;
                            final filtered = items.where((e) => e.label.toString().contains(filter)).toList();
                            if (filtered.isEmpty) {
                              return [
                                DropdownMenuEntry(
                                  style: MenuItemButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    textStyle: labelTextStyle,
                                    foregroundColor: Colors.white,
                                  ),
                                  value: 'Other',
                                  label: 'אחר',
                                ),
                              ];
                            }
                            return filtered;
                          },
                          dropdownMenuEntries: _equipmentNames.map((value) {
                            return DropdownMenuEntry(
                              style: MenuItemButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                textStyle: labelTextStyle,
                                foregroundColor: Colors.white,
                              ),
                              value: value,
                              label: value,
                            );
                          }).toList()
                            ..add(
                              DropdownMenuEntry(
                                style: MenuItemButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  textStyle: labelTextStyle,
                                  foregroundColor: Colors.white,
                                ),
                                value: 'Other',
                                label: 'אחר',
                              ),
                            ),
                          onSelected: (value) {
                            setState(() {
                              _selectedValue = value;
                              addNewEquipment = value == 'Other';
                            });
                          },
                        ),
                      ),

                      if (addNewEquipment) const SizedBox(height: 12),
                      if (addNewEquipment)
                        _CardShell(
                          child: TextField(
                            style: inputTextStyle.copyWith(color: Colors.white),
                            controller: _equipmentController,
                            decoration: const InputDecoration(
                              hintText: 'הכנס שם ציוד',
                              hintStyle: TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.transparent,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white24),
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF3B82F6), width: 1.5),
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                            ),
                          ),
                        ),

                      const SizedBox(height: 12),
                      _CardShell(
                        child: TextField(
                          style: inputTextStyle.copyWith(color: Colors.white),
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'הכנס כמות',
                            hintStyle: TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.transparent,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white24),
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF3B82F6), width: 1.5),
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                          ),
                        ),
                      ),

                      if (errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                        ),
                      ],

                      const SizedBox(height: 24),
                      // כפתור אישור ברור
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            foregroundColor: Colors.white,
                            elevation: 8,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: const BorderSide(color: Colors.white24),
                            ),
                          ),
                          onPressed: _handleSubmit,
                          child: Text('אישור', style: labelTextStyle.copyWith(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// מעטפת "כרטיס" אחידה: גרדיאנט כחול מודרני + מסגרת עדינה + רדיוס
class _CardShell extends StatelessWidget {
  final Widget child;

  const _CardShell({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9, // נראה מצוין גם במסכים רחבים
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          ),
          border: Border.all(color: Colors.white24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
