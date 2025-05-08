import 'package:flutter/material.dart';
import '../../components/custom_appbar.dart';

class OrderStatusScreen extends StatelessWidget {
  const OrderStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String status = "Dimasak"; // Simulasi status

    return Scaffold(
      appBar: const CustomAppBar(title: 'Status Pesanan'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.kitchen, size: 80, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              'Pesanan Anda sedang $status',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text('Kami akan beri tahu jika sudah siap 🙌'),
          ],
        ),
      ),
    );
  }
}
