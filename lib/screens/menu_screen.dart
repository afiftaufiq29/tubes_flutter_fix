// lib/screens/menu_screen.dart
import 'package:flutter/material.dart';
import '../services/mock_data.dart';
import '../widgets/food_card.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key, this.reservationData, this.preorder = false});

  final Map<String, dynamic>? reservationData;
  final bool preorder;

  @override
  Widget build(BuildContext context) {
    // Get arguments if coming from navigation
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final reservationData = args?['reservationData'] ?? this.reservationData;
    final preorder = args?['preorder'] ?? this.preorder;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Makanan"),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          if (reservationData != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detail Reservasi:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Nama: ${reservationData['nama']}'),
                      Text('Telepon: ${reservationData['telepon']}'),
                      Text(
                        'Tanggal: ${reservationData['tanggal'].split('T')[0]}',
                      ),
                      Text('Waktu: ${reservationData['waktu']}'),
                      if (preorder)
                        const Text(
                          'Silakan pilih makanan yang ingin dipesan:',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: MockData.foods.length,
              itemBuilder: (context, index) {
                final food = MockData.foods[index];
                return FoodCard(food: food);
              },
            ),
          ),
        ],
      ),
    );
  }
}
