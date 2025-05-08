import 'package:flutter/material.dart';
import '../../components/custom_appbar.dart';

class PreorderScreen extends StatelessWidget {
  const PreorderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Pre-Order Menu'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: Image.asset(
                'assets/images/food_images/gado_gado.jpg',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text('Menu ${index + 1}'),
              subtitle: const Text('Rp 25.000'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/menu-detail');
              },
            ),
          );
        },
      ),
    );
  }
}
