// lib/widgets/payment_method_selector.dart

import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String? selectedOption;
  final Function(String?) onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pilih Metode Pembayaran:'),
        ListTile(
          title: const Text('Bayar Sekarang'),
          leading: Radio<String>(
            value: 'sekarang',
            groupValue: selectedOption,
            onChanged: onChanged,
          ),
        ),
        ListTile(
          title: const Text('Bayar Nanti'),
          leading: Radio<String>(
            value: 'nanti',
            groupValue: selectedOption,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
