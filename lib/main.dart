import 'package:flutter/material.dart';

// Screens
import 'package:tubes_flutter/screens/home_screen.dart';
import 'package:tubes_flutter/screens/about_screen.dart';
import 'package:tubes_flutter/screens/register_screen.dart';
import 'package:tubes_flutter/screens/login_screen.dart';
import 'package:tubes_flutter/screens/menu_screen.dart';
import 'package:tubes_flutter/screens/reservation_screen.dart';
import 'package:tubes_flutter/screens/profile_screen.dart';
import 'package:tubes_flutter/screens/payment_screen.dart';
import 'package:tubes_flutter/screens/menu_screen_reservation.dart'
    as menu_resv;

// Models & Widgets
import 'package:tubes_flutter/models/food_model.dart';
import 'package:tubes_flutter/widgets/food_card.dart';

// Constants
import 'package:tubes_flutter/constants/app_colors.dart';
import 'package:tubes_flutter/constants/app_styles.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
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
      '/login': (context) => const LoginScreen(),
      '/register': (context) => const RegisterScreen(),
      '/home': (context) => const HomeScreen(),
      '/about': (context) => const AboutScreen(),
      '/menu': (context) => const MenuScreen(),
      '/reservation': (context) => const ReservationScreen(),
      '/profile': (context) => const ProfileScreen(),
      '/menu-reservation': (context) => const menu_resv.MenuScreenReservation(),
      '/payment': (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        if (args != null &&
            args['reservationData'] != null &&
            args['selectedItems'] != null &&
            args['totalAmount'] != null) {
          return PaymentScreen(
            reservationData: args['reservationData'],
            selectedItems: args['selectedItems'],
            totalAmount: args['totalAmount'],
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text('Kesalahan')),
            body: const Center(child: Text('Data pembayaran tidak lengkap.')),
          );
        }
      },
      '/food-cart': (context) {
        final args = ModalRoute.of(context)?.settings.arguments;
        if (args is FoodModel) {
          return Scaffold(
            appBar: AppBar(title: Text(args.name)),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FoodCard(food: args),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Data makanan diperlukan')),
          );
        }
      },
    };
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
