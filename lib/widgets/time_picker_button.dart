// lib/widgets/time_picker.dart

import 'package:flutter/material.dart';

class TimePickerWidget extends StatefulWidget {
  const TimePickerWidget({super.key});

  @override
  TimePickerWidgetState createState() => TimePickerWidgetState(); // Ubah menjadi publik
}

class TimePickerWidgetState extends State<TimePickerWidget> {
  TimeOfDay? selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime =
        selectedTime == null ? 'Pilih Waktu' : selectedTime!.format(context);
    return ElevatedButton(
      onPressed: () => _selectTime(context),
      child: Text(formattedTime),
    );
  }
}
