import 'package:flutter/material.dart';

class ValidationHelper {
  // Validasi Nama
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Nama tidak boleh kosong";
    }
    return null;
  }

  // Validasi Nomor Telepon
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Nomor telepon tidak boleh kosong";
    }
    final numericRegex =
        RegExp(r'^\+?[0-9]{10,15}$'); // Format: +628123456789 atau 08123456789
    if (!numericRegex.hasMatch(value)) {
      return "Nomor telepon tidak valid. Contoh: +628123456789 atau 08123456789";
    }
    return null;
  }

  // Validasi Alamat
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return "Alamat tidak boleh kosong";
    }
    return null;
  }

  // Validasi Tanggal
  static String? validateDate(DateTime? value) {
    if (value == null) {
      return "Tanggal tidak boleh kosong";
    }
    if (value.isBefore(DateTime.now())) {
      return "Tanggal harus di masa depan";
    }
    return null;
  }

  // Validasi Waktu
  static String? validateTime(TimeOfDay? value) {
    if (value == null) {
      return "Waktu tidak boleh kosong";
    }
    final now = TimeOfDay.now();
    if (value.hour < now.hour ||
        (value.hour == now.hour && value.minute <= now.minute)) {
      return "Waktu harus setelah waktu saat ini";
    }
    return null;
  }

  // Validasi Email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email tidak boleh kosong";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Format email tidak valid";
    }
    return null;
  }
}
