import 'package:flutter/material.dart';
import '../../components/custom_appbar.dart';
import '../../components/primary_button.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;

  const PaymentScreen({super.key, required this.totalAmount});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Pembayaran'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Harga: Rp ${widget.totalAmount.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pilih metode pembayaran:',
              style: TextStyle(fontSize: 16),
            ),
            RadioListTile<String>(
              // Explicitly specify the type as String
              value: 'cash',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value ?? '';
                });
              },
              title: const Text('Bayar di Tempat'),
            ),
            RadioListTile<String>(
              // Explicitly specify the type as String
              value: 'transfer',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value ?? '';
                });
              },
              title: const Text('Transfer via M-Banking'),
            ),
            RadioListTile<String>(
              // Explicitly specify the type as String
              value: 'qris',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value ?? '';
                });
              },
              title: const Text('QRIS'),
            ),
            const Spacer(),
            PrimaryButton(
              text: 'Selesaikan Pembayaran',
              onPressed: () {
                if (selectedPaymentMethod.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Silakan pilih metode pembayaran'),
                    ),
                  );
                } else {
                  Navigator.pushNamed(context, '/payment-success');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
