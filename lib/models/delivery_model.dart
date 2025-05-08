// lib/models/delivery_model.dart

import 'package:tubes_flutter/models/food_model.dart';

class DeliveryModel {
  final String id;
  final String customerName;
  final String deliveryAddress;
  final String phoneNumber;
  final List<FoodModel> orderedItems;
  final double totalPrice;
  final DateTime orderDate;
  final String? deliveryInstructions;

  DeliveryModel({
    required this.id,
    required this.customerName,
    required this.deliveryAddress,
    required this.phoneNumber,
    required this.orderedItems,
    required this.totalPrice,
    required this.orderDate,
    this.deliveryInstructions,
  });

  // Factory method untuk membuat objek dari JSON
  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'],
      customerName: json['customerName'],
      deliveryAddress: json['deliveryAddress'],
      phoneNumber: json['phoneNumber'],
      orderedItems:
          (json['orderedItems'] as List)
              .map((item) => FoodModel.fromJson(item))
              .toList(),
      totalPrice: json['totalPrice'].toDouble(),
      orderDate: DateTime.parse(json['orderDate']),
      deliveryInstructions: json['deliveryInstructions'],
    );
  }

  // Method untuk mengonversi objek ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'deliveryAddress': deliveryAddress,
      'phoneNumber': phoneNumber,
      'orderedItems': orderedItems.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'orderDate': orderDate.toIso8601String(),
      'deliveryInstructions': deliveryInstructions,
    };
  }
}
