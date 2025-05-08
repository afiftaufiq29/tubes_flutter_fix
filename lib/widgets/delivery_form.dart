// lib/widgets/delivery_form.dart

import 'package:flutter/material.dart';

class DeliveryForm extends StatefulWidget {
  const DeliveryForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DeliveryFormState createState() => _DeliveryFormState();
}

class _DeliveryFormState extends State<DeliveryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Informasi Pengantaran",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Input Nama
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Nama Lengkap",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Nama tidak boleh kosong";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Input Alamat
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: "Alamat Pengantaran",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Alamat tidak boleh kosong";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Tombol Kirim Pesanan
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Simulasi pengiriman pesanan
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Pesanan berhasil dikirim!")),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("Kirim Pesanan"),
          ),
        ],
      ),
    );
  }
}
