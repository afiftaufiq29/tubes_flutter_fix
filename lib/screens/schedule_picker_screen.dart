import 'package:flutter/material.dart';
import '../../components/custom_appbar.dart';
import '../../components/primary_button.dart';

class SchedulePickerScreen extends StatelessWidget {
  const SchedulePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TimeOfDay selectedTime = TimeOfDay.now();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Jadwal Pengambilan'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Pilih waktu ambil atau makan di tempat:'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (picked != null) {
                  // Simpan waktu
                }
              },
              child: const Text('Pilih Jam'),
            ),
            const Spacer(),
            PrimaryButton(
              text: 'Lanjut ke Pembayaran',
              onPressed: () {
                Navigator.pushNamed(context, '/payment');
              },
            ),
          ],
        ),
      ),
    );
  }
}
