// lib/screens/order_screen.dart

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../constants/app_strings.dart';
import '../widgets/custom_app_bar.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.deliveryTitle),
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Text(
          "Halaman Pemesanan Makanan",
          style: AppStyles.headlineStyle,
        ),
      ),
    );
  }
}
