import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tubes_flutter/screens/home_screen.dart';
import 'package:tubes_flutter/screens/menu_screen_reservation.dart';
import '../services/mock_data.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic>? reservationData;
  final List<Map<String, dynamic>> selectedItems;
  final double totalAmount;

  const PaymentScreen({
    super.key,
    required this.reservationData,
    required this.selectedItems,
    required this.totalAmount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isPaid = false;
  bool _showThankYou = false;

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Apakah Anda yakin pembayaran telah selesai?"),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Tidak"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showThankYouPopup();
            },
            child: const Text("Ya"),
          ),
        ],
      ),
    );
  }

  void _showThankYouPopup() {
    setState(() {
      _showThankYou = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metode Pembayaran',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Ringkasan Pesanan
              Card(
                margin: const EdgeInsets.all(16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ringkasan Pesanan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...widget.selectedItems.map((item) {
                        final food = MockData.foods
                            .firstWhereOrNull((f) => f.id == item['id']);
                        final drink = food == null
                            ? MockData.drinks
                                .firstWhereOrNull((d) => d.id == item['id'])
                            : null;
                        final itemModel = food ?? drink;
                        final quantity = item['quantity'];

                        if (itemModel == null) return const SizedBox();

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${itemModel.name} (${quantity}x)'),
                              Text(
                                  'Rp ${(itemModel.price * quantity).toStringAsFixed(0)}'),
                            ],
                          ),
                        );
                      }),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Pembayaran',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Rp ${widget.totalAmount.toStringAsFixed(0)}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[400])),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Metode Pembayaran
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    const SizedBox(height: 8),
                    _buildSectionTitle('Transfer Bank'),
                    const SizedBox(height: 8),
                    _buildBankOption(
                      context,
                      'BCA',
                      Icons.account_balance,
                      () => _showBankDialog(context, 'BCA', '1234567890'),
                    ),
                    _buildBankOption(
                      context,
                      'Mandiri',
                      Icons.account_balance,
                      () => _showBankDialog(context, 'Mandiri', '9876543210'),
                    ),
                    _buildBankOption(
                      context,
                      'BRI',
                      Icons.account_balance,
                      () => _showBankDialog(context, 'BRI', '5678901234'),
                    ),
                    _buildBankOption(
                      context,
                      'BNI',
                      Icons.account_balance,
                      () => _showBankDialog(context, 'BNI', '0123456789'),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Dompet Digital'),
                    const SizedBox(height: 8),
                    _buildEWalletOption(
                      context,
                      'GoPay',
                      Icons.wallet,
                      () =>
                          _showEWalletDialog(context, 'GoPay', '081234567890'),
                    ),
                    _buildEWalletOption(
                      context,
                      'OVO',
                      Icons.wallet,
                      () => _showEWalletDialog(context, 'OVO', '081234567891'),
                    ),
                    _buildEWalletOption(
                      context,
                      'DANA',
                      Icons.wallet,
                      () => _showEWalletDialog(context, 'DANA', '081234567892'),
                    ),
                    _buildEWalletOption(
                      context,
                      'ShopeePay',
                      Icons.wallet,
                      () => _showEWalletDialog(
                          context, 'ShopeePay', '081234567893'),
                    ),
                    _buildEWalletOption(
                      context,
                      'LinkAja',
                      Icons.wallet,
                      () => _showEWalletDialog(
                          context, 'LinkAja', '081234567894'),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('QRIS'),
                    const SizedBox(height: 8),
                    _buildPaymentOption(
                      context,
                      'QRIS',
                      'Bayar dengan QRIS',
                      Icons.qr_code,
                      () => _showQRISDialog(context),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Bayar di Tempat'),
                    const SizedBox(height: 8),
                    _buildPaymentOption(
                      context,
                      'Bayar di Kasir',
                      'Bayar saat sampai di restoran',
                      Icons.store,
                      () => _showCODDialog(context),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Tombol Bayar Sekarang / Selesai
              Container(
                padding: const EdgeInsets.all(16),
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
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isPaid
                        ? () {
                            _showConfirmationDialog(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor:
                          _isPaid ? Colors.green : Colors.orange[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _isPaid ? 'SELESAI' : 'BAYAR SEKARANG',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Pop-up animasi "TERIMA KASIH"
          if (_showThankYou)
            AnimatedOpacity(
              opacity: _showThankYou ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'TERIMA KASIH',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Pembayaran Anda telah berhasil diproses.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildBankOption(BuildContext context, String bankName, IconData icon,
      VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange[400]),
        title: Text(bankName),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildEWalletOption(BuildContext context, String walletName,
      IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange[400]),
        title: Text(walletName),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, String title,
      String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange[400]),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showBankDialog(
      BuildContext context, String bankName, String accountNumber) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_balance, size: 50, color: Colors.blue),
                const SizedBox(height: 16),
                Text(
                  'Transfer Bank $bankName',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text('Nomor Rekening'),
                      const SizedBox(height: 4),
                      Text(
                        accountNumber,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('a.n Restoran Sejahtera'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Total: Rp ${widget.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: Navigator.of(context).pop,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.orange[400]!),
                        ),
                        child: Text(
                          'TUTUP',
                          style: TextStyle(color: Colors.orange[400]),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _isPaid = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[400],
                        ),
                        child: const Text(
                          'SUDAH TRANSFER',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEWalletDialog(
      BuildContext context, String walletName, String phoneNumber) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wallet, size: 50, color: Colors.green[400]),
                const SizedBox(height: 16),
                Text(
                  'Dompet Digital $walletName',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text('Nomor Telepon'),
                      const SizedBox(height: 4),
                      Text(
                        phoneNumber,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('a.n Restoran Sejahtera'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Total: Rp ${widget.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: Navigator.of(context).pop,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.orange[400]!),
                        ),
                        child: Text(
                          'TUTUP',
                          style: TextStyle(color: Colors.orange[400]),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _isPaid = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[400],
                        ),
                        child: const Text(
                          'SUDAH BAYAR',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showQRISDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('QRIS Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/qr_code.png',
                      height: 200,
                      width: 200,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp ${widget.totalAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Scan QR code di atas untuk melakukan pembayaran',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Berlaku hingga: ${_getExpiryTime()}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('TUTUP'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _isPaid = true;
                });
              },
              child: const Text('SUDAH BAYAR'),
            ),
          ],
        );
      },
    );
  }

  void _showCODDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Bayar di Tempat'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.store, size: 50, color: Colors.orange),
              SizedBox(height: 16),
              Text(
                'Silahkan Bayar Melalui Kasir',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Tunjukkan bukti reservasi Anda kepada kasir',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('TUTUP'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _isPaid = true;
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _getExpiryTime() {
    final now = DateTime.now();
    final expiry = now.add(const Duration(minutes: 15));
    return '${expiry.hour}:${expiry.minute.toString().padLeft(2, '0')}';
  }
}
