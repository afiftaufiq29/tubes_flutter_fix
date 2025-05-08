import 'package:flutter/material.dart';
import '../../components/custom_appbar.dart';
import '../../components/primary_button.dart';

class MenuDetailScreen extends StatelessWidget {
  const MenuDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Detail Menu'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset('assets/images/food_images/gado_gado.jpg', height: 180),
            const SizedBox(height: 16),
            const Text(
              'Gado-Gado Nusantara',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Rp 25.000'),
            const Spacer(),
            PrimaryButton(
              text: 'Tambahkan ke Pre-Order',
              onPressed: () {
                Navigator.pushNamed(context, '/schedule');
              },
            ),
          ],
        ),
      ),
    );
  }
}
