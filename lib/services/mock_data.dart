// lib/services/mock_data.dart

import '../models/food_model.dart';
import '../models/reservation_model.dart';
import '../models/delivery_model.dart';

class MockData {
  // Data dummy untuk makanan
  static List<FoodModel> get foods => [
    FoodModel(
      id: '1',
      name: 'Rendang',
      description: 'Daging sapi bumbu rempah khas Minang',
      price: 45000,
      imageUrl: 'assets/images/food_images/rendang.jpg',
    ),
    FoodModel(
      id: '2',
      name: 'Nasi Goreng',
      description: 'Nasi goreng dengan bumbu tradisional',
      price: 30000,
      imageUrl: 'assets/images/food_images/nasi_goreng.jpg',
    ),
    FoodModel(
      id: '3',
      name: 'Sate Ayam',
      description: 'Sate ayam dengan bumbu kacang spesial',
      price: 35000,
      imageUrl: 'assets/images/food_images/sate.jpg',
    ),
    FoodModel(
      id: '4',
      name: 'Gado-Gado',
      description: 'Sayuran segar dengan saus kacang gurih',
      price: 25000,
      imageUrl: 'assets/images/food_images/gado_gado.jpg',
    ),
    FoodModel(
      id: '5',
      name: 'Soto Ayam',
      description: 'Sup ayam dengan kuah kuning hangat',
      price: 30000,
      imageUrl: 'assets/images/food_images/soto_ayam.jpg',
    ),
    FoodModel(
      id: '6',
      name: 'Bakso',
      description: 'Bakso sapi kenyal dengan kuah kaldu',
      price: 28000,
      imageUrl: 'assets/images/food_images/bakso.jpg',
    ),
    FoodModel(
      id: '7',
      name: 'Pempek',
      description: 'Ikan tenggiri dicampur sagu dengan cuko pedas',
      price: 40000,
      imageUrl: 'assets/images/food_images/pempek.jpg',
    ),
    FoodModel(
      id: '8',
      name: 'Ayam Betutu',
      description: 'Ayam panggang dengan bumbu Bali',
      price: 50000,
      imageUrl: 'assets/images/food_images/ayam_betutu.jpg',
    ),
    FoodModel(
      id: '9',
      name: 'Ketoprak',
      description: 'Tahu dan lontong dengan saus kacang',
      price: 22000,
      imageUrl: 'assets/images/food_images/ketoprak.jpg',
    ),
    FoodModel(
      id: '10',
      name: 'Rawon',
      description: 'Sup daging hitam dengan kuah kluwek',
      price: 45000,
      imageUrl: 'assets/images/food_images/rawon.jpg',
    ),
  ];

  // Data dummy untuk reservasi
  static ReservationModel get sampleReservation => ReservationModel(
    id: '123',
    name: 'John Doe',
    reservationDate: DateTime.now(),
    reservationTime: '19:00',
    numberOfGuests: 4,
    phoneNumber: '08123456789',
    specialRequest: 'Tolong tempatkan di area non-smoking.',
  );

  // Data dummy untuk pengantaran
  static DeliveryModel get sampleDelivery => DeliveryModel(
    id: '456',
    customerName: 'Jane Doe',
    deliveryAddress: 'Jl. Sudirman No. 123',
    phoneNumber: '08123456789',
    orderedItems: foods,
    totalPrice: 110000,
    orderDate: DateTime.now(),
    deliveryInstructions: 'Tinggalkan di depan pintu.',
  );
}
