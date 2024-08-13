// widgets/date_picker.dart

import 'package:flutter/material.dart';

class DateOfBirthPicker extends StatefulWidget {
  final void Function(DateTime selectedDate)? onDateSelected;

  const DateOfBirthPicker({super.key, this.onDateSelected});

  @override
  _DateOfBirthPickerState createState() => _DateOfBirthPickerState();
}

class _DateOfBirthPickerState extends State<DateOfBirthPicker> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateSelected?.call(picked); // Call callback with selected date
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: () {
              _selectDate(context);
            },
            child: TextFormField(
              readOnly: true, // Prevents manual editing
              controller: TextEditingController(
                text: _selectedDate != null
                    ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : '',
              ),
              decoration: const InputDecoration(
                labelText: 'Date of Enlistment',
                hintText: 'Select Date',
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () {
            _selectDate(context);
          },
        ),
      ],
    );
  }
}
