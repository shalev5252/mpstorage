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
      final equipmentName =
          addNewEquipment ? _equipmentController.text : _selectedValue;
      final quantityStr = _quantityController.text;
      if (equipmentName == null || equipmentName.isEmpty) {
        setState(() {
          errorMessage = 'שם הציוד לא יכול להיות ריק';
        });
        return;
      }
      final quantity = int.tryParse(quantityStr);
      if (quantity == null || quantity < 0) {
        setState(() {
          errorMessage = 'כמות לא תקינה';
        });
        return;
      }

      Map<String, dynamic> data = {
        "quantity": FieldValue.increment(_isSwitchedOn ? -quantity : quantity),
        "current_quantity":
            FieldValue.increment(_isSwitchedOn ? -quantity : quantity)
      };
      await firestore
          .collection("equipment")
          .doc(equipmentName)
          .set(data, SetOptions(merge: true));
      _quantityController.clear();
      // Refresh the equipment names list after adding new equipment
      if (addNewEquipment) {
        _fetchEquipmentNames();
        _equipmentController.clear();
        setState(() {
          addNewEquipment = false;
          _selectedValue = null;
        });
      }

      setState(() {
        errorMessage = null;
      });
      print('Operation successful');
      showDialog (
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text('הפעולה בוצעה', style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ))),
            alignment: Alignment.center,
            content: Column(children:
              [Text('הציוד עודכן בהצלחה', style: tableTextStyle)],
            ),

            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('אישור'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
      print('Error: $e');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(child: Text('הפעולה נכשלה', style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ))),
              alignment: Alignment.center,
              content: Text('הפעולה נכשלה, נסה שנית', style: tableTextStyle),

              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('אישור'),
                ),
              ],
            );
          }
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
              child: Center(
                  child: Text('הוספת ציוד לאחסון', style: labelTextStyle))),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColorStyle),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(color: textColorStyle),
        ),
        body: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Center(
                        child: ToggleSwitch(
                            onChanged: _handleToggleSwitchChanged)),
                    // Text(_isSwitchedOn ? "הסרת ציוד" : "הוספת ציוד"),
                    const SizedBox(height: 30),
                    Container(
                        decoration: BoxDecoration(
                            color: buttonsAppbarColors,
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: DropdownMenu(
                          enableFilter: true,
                          requestFocusOnTap: true,
                          menuHeight: 300,
                          width: MediaQuery.sizeOf(context).width * 0.7,
                          label: Text("בחר אפשרות", style: labelTextStyle),
                          textStyle: labelTextStyle,

                            filterCallback: (List<DropdownMenuEntry<dynamic>> item_list, String? filter){
                              if(filter == null || filter.isEmpty){
                                return item_list;
                              }
                              List<DropdownMenuEntry<dynamic>> filtered_list = [];
                              for(DropdownMenuEntry<dynamic> item in item_list){
                                if(item.label.toString().contains(filter)){
                                  filtered_list.add(item);
                                }
                              }
                              if(filtered_list.isEmpty){
                                filtered_list.add(DropdownMenuEntry(
                                    style: MenuItemButton.styleFrom(
                                        backgroundColor: buttonsAppbarColors,
                                        textStyle: labelTextStyle,
                                        foregroundColor: textColorStyle),
                                    value: 'Other',
                                    label: 'אחר'));
                              }
                              return filtered_list;
                            },

                        dropdownMenuEntries:
                          _equipmentNames.map((String value) {
                            return DropdownMenuEntry(
                                style: MenuItemButton.styleFrom(
                                    backgroundColor: buttonsAppbarColors,
                                    textStyle: labelTextStyle,
                                    foregroundColor: textColorStyle),
                                value: value,
                                label: value);
                          }).toList() +
                              [
                                DropdownMenuEntry(
                                    style: MenuItemButton.styleFrom(
                                        backgroundColor: buttonsAppbarColors,
                                        textStyle: labelTextStyle,
                                        foregroundColor: textColorStyle),
                                    value: 'Other',
                                    label: 'אחר')
                              ],

                          onSelected: (value) {
                            setState(() {
                              _selectedValue = value;
                              addNewEquipment = value == 'Other';
                            });
                          },


                        )),
                    addNewEquipment ? SizedBox(height: 10) : SizedBox(),
                    if (addNewEquipment)
                      TextField(
                        style: inputTextStyle,
                        controller: _equipmentController,
                        decoration: InputDecoration(
                          fillColor: textColorStyle,
                          hintText: 'הכנס שם ציוד',
                          hintStyle: inputTextStyle,
                        ),
                      ),
                    const SizedBox(height: 10),
                    TextField(
                      style: inputTextStyle,
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'הכנס כמות',
                        hintStyle: inputTextStyle,
                      ),
                    ),
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(buttonsAppbarColors)),
                      onPressed: _handleSubmit,
                      child: Text('אישור',style: labelTextStyle),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
