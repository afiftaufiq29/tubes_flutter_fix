import 'package:flutter/material.dart';
import 'package:tubes_flutter/screens/payment_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/mock_data.dart';
import '../models/food_model.dart';
import 'history_screen.dart'; // Untuk model OrderHistory

// Helper function for Indonesian currency formatting
String formatCurrency(double amount) {
  return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      )}';
}

class MenuScreenReservation extends StatefulWidget {
  final Map<String, dynamic>? reservationData;
  final bool preorder;
  const MenuScreenReservation({
    super.key,
    this.reservationData,
    this.preorder = false,
  });

  @override
  State<MenuScreenReservation> createState() => _MenuScreenReservationState();
}

class _MenuScreenReservationState extends State<MenuScreenReservation> {
  Map<String, int> selectedItems = {};
  double totalAmount = 0.0;
  bool showPaymentBar = false;

  FoodModel? getItemById(String id) {
    return MockData.foods.firstWhereOrNull((f) => f.id == id) ??
        MockData.drinks.firstWhereOrNull((d) => d.id == id);
  }

  // Fungsi untuk menyimpan riwayat pesanan
  Future<void> _saveOrderHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> orderHistoryList =
        prefs.getStringList('order_history') ?? [];

    final newOrder = OrderHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date:
          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
      items: selectedItems.entries.map((entry) {
        final item = getItemById(entry.key);
        return OrderItem(
          name: item?.name ?? 'Unknown',
          quantity: entry.value,
        );
      }).toList(),
    );

    orderHistoryList.add(json.encode(newOrder.toJson()));
    await prefs.setStringList('order_history', orderHistoryList);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final effectiveReservationData =
        args?['reservationData'] ?? widget.reservationData;
    final effectivePreorder = args?['preorder'] ?? widget.preorder;

    void updateQuantity(String foodId, int quantity) {
      setState(() {
        if (quantity > 0) {
          selectedItems[foodId] = quantity;
        } else {
          selectedItems.remove(foodId);
        }

        totalAmount = 0.0;
        selectedItems.forEach((id, qty) {
          final item = getItemById(id);
          if (item != null) {
            totalAmount += item.price * qty;
          }
        });

        showPaymentBar = selectedItems.isNotEmpty;
      });
    }

    void proceedToPayment() {
      List<Map<String, dynamic>> itemsWithDetails = [];

      selectedItems.forEach((id, quantity) {
        final item = getItemById(id);
        if (item != null) {
          itemsWithDetails.add({
            'id': item.id,
            'name': item.name,
            'price': item.price,
            'quantity': quantity,
            'imageUrl': item.imageUrl,
            'isDrink': MockData.drinks.any((d) => d.id == id),
          });
        }
      });

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => PaymentSummarySheet(
          reservationData: effectiveReservationData,
          selectedItems: selectedItems,
          itemsWithDetails: itemsWithDetails,
          totalAmount: totalAmount,
          onConfirm: () async {
            await _saveOrderHistory(); // Simpan riwayat sebelum pembayaran
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Menu Makanan & Minuman",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange[400],
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          if (effectiveReservationData != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detail Reservasi:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow('Nama', effectiveReservationData['nama']),
                      _buildDetailRow(
                          'Telepon', effectiveReservationData['telepon']),
                      _buildDetailRow('Tanggal',
                          effectiveReservationData['tanggal'].split('T')[0]),
                      _buildDetailRow(
                          'Waktu', effectiveReservationData['waktu']),
                      if (effectivePreorder)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Silakan pilih makanan/minuman yang ingin dipesan:',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: MockData.foods.length + MockData.drinks.length + 1,
              itemBuilder: (context, index) {
                if (index == MockData.foods.length) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    child: const Text(
                      '--- MINUMAN ---',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                  );
                }

                final isFood = index < MockData.foods.length;
                final item = isFood
                    ? MockData.foods[index]
                    : MockData.drinks[index - MockData.foods.length - 1];
                final quantity = selectedItems[item.id] ?? 0;

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            item.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(Icons.fastfood, size: 40),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatCurrency(item.price),
                                style: TextStyle(
                                  color: Colors.orange[400],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        QuantitySelector(
                          quantity: quantity,
                          onChanged: (newQuantity) =>
                              updateQuantity(item.id, newQuantity),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const Divider(height: 0),
            ),
          ),
        ],
      ),
      bottomNavigationBar: showPaymentBar
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total: ${formatCurrency(totalAmount)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${selectedItems.length} item${selectedItems.length > 1 ? 's' : ''} dipilih',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: proceedToPayment,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      backgroundColor: Colors.orange[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Pesan Sekarang',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class PaymentSummarySheet extends StatelessWidget {
  final Map<String, dynamic>? reservationData;
  final Map<String, int> selectedItems;
  final List<Map<String, dynamic>> itemsWithDetails;
  final double totalAmount;
  final Future<void> Function()? onConfirm;

  const PaymentSummarySheet({
    super.key,
    required this.reservationData,
    required this.selectedItems,
    required this.itemsWithDetails,
    required this.totalAmount,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Ringkasan Pesanan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (reservationData != null) ...[
                _buildSummaryRow('Nama', reservationData!['nama']),
                _buildSummaryRow(
                    'Tanggal', reservationData!['tanggal'].split('T')[0]),
                _buildSummaryRow('Waktu', reservationData!['waktu']),
                const Divider(),
              ],
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: itemsWithDetails.length,
                  itemBuilder: (context, index) {
                    final item = itemsWithDetails[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              '${item['name']} (${item['quantity']}x)',
                              style: TextStyle(color: Colors.grey[700]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            formatCurrency(item['price'] * item['quantity']),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              _buildSummaryRow(
                'Total Pembayaran',
                formatCurrency(totalAmount),
                isBold: true,
                isOrange: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (onConfirm != null) {
                      await onConfirm!();
                    }
                    if (context.mounted) {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                            reservationData: reservationData,
                            selectedItems: itemsWithDetails,
                            totalAmount: totalAmount,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.orange[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'KONFIRMASI PEMBAYARAN',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isBold = false, bool isOrange = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isOrange ? Colors.orange : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final Function(int) onChanged;
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove, size: 20),
          onPressed: quantity > 0 ? () => onChanged(quantity - 1) : null,
          style: IconButton.styleFrom(
            backgroundColor:
                quantity > 0 ? Colors.orange[100] : Colors.grey[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            quantity.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add, size: 20),
          onPressed: () => onChanged(quantity + 1),
          style: IconButton.styleFrom(
            backgroundColor: Colors.orange[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

extension ListExtensions on List<FoodModel> {
  FoodModel? firstWhereOrNull(bool Function(FoodModel) test) {
    for (var item in this) {
      if (test(item)) return item;
    }
    return null;
  }
}
