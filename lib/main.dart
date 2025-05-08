import 'package:flutter/material.dart';
import 'package:tubes_flutter/models/food_model.dart';
import 'package:tubes_flutter/screens/about_screen.dart';
import 'screens/delivery_screen.dart';
import 'screens/home_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/reservation_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/preorder_screen.dart';
import 'screens/schedule_picker_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/payment_success_screen.dart';
import 'screens/order_status_screen.dart';
import 'screens/login_screen.dart';
import 'constants/app_colors.dart';
import 'constants/app_styles.dart';
import 'widgets/food_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Masakan Nusantara',
      theme: _buildTheme(),
      initialRoute: '/login',
      routes: _buildRoutes(),
      onGenerateRoute: _onGenerateRoute,
      onUnknownRoute: _onUnknownRoute,
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      fontFamily: 'Poppins',
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        titleTextStyle: AppStyles.headlineStyle.copyWith(
          color: AppColors.textColorLight,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonColorPrimary,
          foregroundColor: AppColors.textColorLight,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: AppStyles.headlineStyle,
        titleLarge: AppStyles.titleStyle,
        bodyLarge: AppStyles.bodyStyle,
        labelMedium: AppStyles.subtitleStyle,
      ),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/': (context) => const LoginScreen(),
      '/login': (context) => const LoginScreen(),
      '/home': (context) => const HomeScreen(),
      '/about': (context) => const AboutScreen(),
      '/menu': (context) {
        final args = ModalRoute.of(context)?.settings.arguments;
        return MenuScreen(
          reservationData: args is Map ? args['reservationData'] : null,
          preorder: args is Map ? args['preorder'] ?? false : false,
        );
      },
      '/reservation': (context) => const ReservationScreen(),
      '/profile': (context) => const ProfileScreen(),
      '/preorder': (context) => const PreorderScreen(),
      '/schedule-picker': (context) => const SchedulePickerScreen(),
      '/payment': (context) {
        final args = ModalRoute.of(context)?.settings.arguments;
        if (args is Map<String, dynamic> && args['totalAmount'] != null) {
          final double totalAmount = args['totalAmount'];
          return PaymentScreen(totalAmount: totalAmount);
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text('Kesalahan')),
            body: const Center(child: Text('Total pembayaran tidak tersedia.')),
          );
        }
      },
      '/payment-success': (context) => const PaymentSuccessScreen(),
      '/order-status': (context) => const OrderStatusScreen(),
      '/food-cart': (context) {
        final args = ModalRoute.of(context)?.settings.arguments;
        if (args is FoodModel) {
          return FoodCard(food: args);
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Data makanan diperlukan')),
          );
        }
      },
    };
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/delivery') {
      final FoodModel food = settings.arguments as FoodModel;
      return MaterialPageRoute(
        builder: (context) => DeliveryScreen(food: food),
      );
    }
    return null;
  }

  Route<dynamic> _onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Halaman Tidak Ditemukan'),
          backgroundColor: AppColors.errorColor,
        ),
        body: Center(
          child: Text(
            'Maaf, halaman ${settings.name} tidak ditemukan.',
            style: AppStyles.bodyStyle.copyWith(
              color: AppColors.errorColor,
            ),
          ),
        ),
      ),
    );
  }
}
