// lib/services/api_service.dart

import 'dart:async';
import 'package:flutter/foundation.dart';

import '../models/food_model.dart';
import '../models/reservation_model.dart';
import './mock_data.dart';

class ApiService {
  // Simulasi delay untuk meniru API (opsional)
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(Duration(seconds: 1));
  }

  // Fungsi untuk mendapatkan daftar makanan
  Future<List<FoodModel>> fetchFoods() async {
    try {
      await _simulateNetworkDelay();
      return MockData.foods; // Mengembalikan mock data
    } catch (e) {
      throw Exception('Gagal memuat daftar makanan');
    }
  }

  // Fungsi untuk menambahkan reservasi
  Future<void> addReservation(ReservationModel reservation) async {
    try {
      await _simulateNetworkDelay();
      // Simulasi penyimpanan reservasi (misalnya, hanya mencetak ke konsol)
      if (kDebugMode) {
        print("Reservasi berhasil ditambahkan: ${reservation.toJson()}");
      }
    } catch (e) {
      throw Exception('Gagal menambahkan reservasi');
    }
  }

  // Fungsi untuk menambahkan pesanan pengantaran
}
