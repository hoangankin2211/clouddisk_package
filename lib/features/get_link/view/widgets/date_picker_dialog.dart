import 'package:flutter/material.dart';

class CustomDatePickerDialog extends StatefulWidget {
  const CustomDatePickerDialog({super.key});

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  DateTime currentDatetime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return DatePickerDialog(
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(2030),
      currentDate: currentDatetime,
    );
  }
}
