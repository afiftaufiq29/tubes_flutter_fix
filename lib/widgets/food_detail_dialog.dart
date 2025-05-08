import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/food_model.dart';

class FoodDetailDialog extends StatelessWidget {
  final FoodModel food;

  const FoodDetailDialog({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    // Deskripsi menggoda berdasarkan nama makanan
    String foodDescription = food.description;

    switch (food.name.toLowerCase()) {
      case 'nasi goreng':
        foodDescription =
            'Nasi goreng khas Indonesia yang gurih dan kaya rasa, dimasak dengan bumbu rempah dan kecap manis, disajikan panas dengan telur dan kerupuk.';
        break;
      case 'sate ayam':
        foodDescription =
            'Sate ayam empuk yang dibakar sempurna, disiram bumbu kacang gurih dan kecap manis, cocok disantap bersama lontong.';
        break;
      case 'rendang':
        foodDescription =
            'Rendang daging sapi khas Minang yang dimasak lama hingga empuk, berbalut bumbu rempah yang kaya dan pedas.';
        break;
      case 'gado-gado':
        foodDescription =
            'Gado-gado segar dengan campuran sayuran rebus, tahu, tempe, dan telur, disiram saus kacang kental yang lezat.';
        break;
      case 'soto ayam':
        foodDescription =
            'Soto ayam berkuah kuning yang harum dan gurih, berisi ayam suwir, telur, dan soun, cocok disantap hangat-hangat.';
        break;
      case 'bakso':
        foodDescription =
            'Bakso daging sapi kenyal dalam kuah kaldu gurih, disajikan dengan mie, tahu, dan taburan bawang goreng.';
        break;
      case 'pempek':
        foodDescription =
            'Pempek Palembang yang renyah di luar dan lembut di dalam, disajikan dengan kuah cuko pedas manis yang khas.';
        break;
      case 'ayam betutu':
        foodDescription =
            'Ayam Betutu khas Bali yang dimasak dengan bumbu rempah lengkap, disajikan utuh dan sangat menggugah selera.';
        break;
      case 'ketoprak':
        foodDescription =
            'Ketoprak khas Betawi dengan bihun, tahu, dan lontong disiram saus kacang kental, disajikan dengan kerupuk renyah.';
        break;
      case 'rawon':
        foodDescription =
            'Rawon daging sapi berkuah hitam dari kluwek, aromatik dan lezat, disajikan dengan nasi, sambal, dan telur asin.';
        break;
    }

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      backgroundColor: Colors.white.withOpacity(0.85),
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      food.imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    food.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    foodDescription,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Rp ${food.price}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text("Tutup"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
