import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../services/mock_data.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../widgets/food_card.dart';
import '../widgets/food_detail_dialog.dart'; // Pastikan import ini ada

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedIndex = 1;
  bool _showFoods = true;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        break;
      case 1:
        break;
      case 2:
        Navigator.pushNamed(context, '/about').then((_) {
          if (mounted) setState(() => _selectedIndex = 0);
        });
        break;
      case 3:
        Navigator.pushNamed(context, '/profile').then((_) {
          if (mounted) setState(() => _selectedIndex = 0);
        });
        break;
    }
  }

  void _showFoodDetail(FoodModel food) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(20), // Padding untuk dialog
        backgroundColor: Colors.transparent,
        child: FoodDetailDialog(
            food: food), // Gunakan widget dialog yang sudah ada
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Menu Kami',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange[400],
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.grey[50],
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Toggle Button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _showFoods = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _showFoods ? Colors.orange[400] : Colors.grey[300],
                      foregroundColor: _showFoods ? Colors.white : Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Makanan'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _showFoods = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          !_showFoods ? Colors.orange[400] : Colors.grey[300],
                      foregroundColor:
                          !_showFoods ? Colors.white : Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Minuman'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // GridView Menu
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemCount:
                    _showFoods ? MockData.foods.length : MockData.drinks.length,
                itemBuilder: (context, index) {
                  final item = _showFoods
                      ? MockData.foods[index]
                      : MockData.drinks[index];
                  return GestureDetector(
                    onTap: () =>
                        _showFoodDetail(item), // Panggil dialog di sini
                    child: FoodCard(food: item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
