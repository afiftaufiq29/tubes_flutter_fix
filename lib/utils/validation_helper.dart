// validation_helper.dart
import 'package:flutter/material.dart';

class ValidationHelper {
  // Validasi Nomor Telepon dengan standardisasi format
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Nomor HP tidak boleh kosong";
    }

    String cleanNumber = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Konversi ke format +62
    if (cleanNumber.startsWith("0")) {
      cleanNumber = "62${cleanNumber.substring(1)}";
    } else if (!cleanNumber.startsWith("62")) {
      cleanNumber = "62$cleanNumber";
    }

    if (cleanNumber.length < 11 || cleanNumber.length > 14) {
      return "Format nomor tidak valid (contoh: 08123456789)";
    }

    return null;
  }

  // Validasi Password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password tidak boleh kosong";
    }
    if (value.length < 6) {
      return "Password minimal 6 karakter";
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

  // Validasi Nama
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Nama tidak boleh kosong";
    }
    if (value.length < 3) {
      return "Nama minimal 3 karakter";
    }
    return null;
  }
}
