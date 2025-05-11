import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tubes_flutter/screens/home_screen.dart';
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
  final Color _primaryColor = Colors.orange[400]!;

  dynamic _findItemById(String id) {
    try {
      final food = MockData.foods.firstWhere((f) => f.id == id);
      return food;
    } catch (e) {
      try {
        final drink = MockData.drinks.firstWhere((d) => d.id == id);
        return drink;
      } catch (e) {
        return null;
      }
    }
  }

  String _formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Apakah Anda yakin pembayaran telah selesai?"),
        actions: [
          _buildDialogButton('Tidak', () => Navigator.of(context).pop(),
              isPrimary: false),
          _buildDialogButton('Ya', () {
            Navigator.of(context).pop();
            _showThankYouPopup();
          }),
        ],
      ),
    );
  }

  Widget _buildDialogButton(String text, VoidCallback onPressed,
      {bool isPrimary = true}) {
    return SizedBox(
      width: 100,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: isPrimary ? _primaryColor : Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isPrimary ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showThankYouPopup() {
    setState(() => _showThankYou = true);
    Future.delayed(const Duration(milliseconds: 3200), () {
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
    final screenHeight = MediaQuery.of(context).size.height;
    final estimatedItemHeight = 40.0;
    final estimatedHeaderHeight = 200.0;
    final estimatedTotalHeight = estimatedHeaderHeight +
        (widget.selectedItems.length * estimatedItemHeight);

    final shouldScroll = estimatedTotalHeight > screenHeight * 0.6;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Metode Pembayaran',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange[400],
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // Responsive Order Summary Card
                      Container(
                        margin: const EdgeInsets.all(16),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Ringkasan Pesanan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Item List with automatic sizing
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    return ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: screenHeight * 0.4,
                                      ),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: widget.selectedItems.length,
                                        itemBuilder: (context, index) {
                                          final item =
                                              widget.selectedItems[index];
                                          final itemModel =
                                              _findItemById(item['id']);
                                          final quantity = item['quantity'];

                                          if (itemModel == null)
                                            return const SizedBox();

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    '${itemModel.name} (${quantity}x)',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                  _formatCurrency(
                                                      (itemModel.price *
                                                              quantity)
                                                          .toInt()),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total Pembayaran',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      _formatCurrency(
                                          widget.totalAmount.toInt()),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: _primaryColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Payment Methods Section
                      _buildPaymentMethodsSection(),
                      // Spacer for bottom button
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Fixed Payment Button at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildPaymentButton(),
          ),
          if (_showThankYou) _buildThankYouPopup(),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildSectionTitle('Transfer Bank'),
          const SizedBox(height: 8),
          _buildBankOption('BCA', '1234567890'),
          _buildBankOption('Mandiri', '9876543210'),
          _buildBankOption('BRI', '5678901234'),
          _buildBankOption('BNI', '0123456789'),
          const SizedBox(height: 24),
          _buildSectionTitle('Dompet Digital'),
          const SizedBox(height: 8),
          _buildEWalletOption('GoPay', '081234567890'),
          _buildEWalletOption('OVO', '081234567891'),
          _buildEWalletOption('DANA', '081234567892'),
          _buildEWalletOption('ShopeePay', '081234567893'),
          _buildEWalletOption('LinkAja', '081234567894'),
          const SizedBox(height: 24),
          _buildSectionTitle('QRIS'),
          const SizedBox(height: 8),
          _buildPaymentOption(
            'QRIS',
            'Bayar dengan QRIS',
            Icons.qr_code,
            _showQRISDialog,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Bayar di Tempat'),
          const SizedBox(height: 8),
          _buildPaymentOption(
            'Bayar di Kasir',
            'Bayar saat sampai di restoran',
            Icons.store,
            _showCODDialog,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPaymentButton() {
    return Container(
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
        height: 60,
        child: ElevatedButton(
          onPressed: _isPaid ? () => _showConfirmationDialog(context) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isPaid ? Colors.green : _primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            _isPaid ? 'SELESAI' : 'BAYAR SEKARANG',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThankYouPopup() {
    return AnimatedOpacity(
      opacity: _showThankYou ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gunakan animasi Lottie
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Lottie.asset('assets/animations/success_check.json'),
                ),
                const SizedBox(height: 8),
                const Text(
                  'TERIMA KASIH',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pembayaran Anda telah berhasil diproses.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
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

  Widget _buildBankOption(String bankName, String accountNumber) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(Icons.account_balance, color: _primaryColor),
        title: Text(bankName),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showBankDialog(bankName, accountNumber),
      ),
    );
  }

  Widget _buildEWalletOption(String walletName, String phoneNumber) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(Icons.wallet, color: _primaryColor),
        title: Text(walletName),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showEWalletDialog(walletName, phoneNumber),
      ),
    );
  }

  Widget _buildPaymentOption(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: _primaryColor),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showBankDialog(String bankName, String accountNumber) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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
                'Total: ${_formatCurrency(widget.totalAmount.toInt())}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: _primaryColor),
                        ),
                        child: Text(
                          'TUTUP',
                          style: TextStyle(color: _primaryColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() => _isPaid = true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                        ),
                        child: const Text(
                          'SUDAH TRANSFER',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEWalletDialog(String walletName, String phoneNumber) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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
                'Total: ${_formatCurrency(widget.totalAmount.toInt())}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: _primaryColor),
                        ),
                        child: Text(
                          'TUTUP',
                          style: TextStyle(color: _primaryColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() => _isPaid = true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                        ),
                        child: const Text(
                          'SUDAH BAYAR',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQRISDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
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
                    _formatCurrency(widget.totalAmount.toInt()),
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
          SizedBox(
            width: 100,
            height: 40,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: _primaryColor),
              ),
              child: Text(
                'TUTUP',
                style: TextStyle(color: _primaryColor),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _isPaid = true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
              ),
              child: const Text(
                'SUDAH BAYAR',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCODDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bayar di Tempat'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.store, size: 50, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              'Silahkan Bayar Melalui Kasir',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
          SizedBox(
            width: 100,
            height: 40,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: _primaryColor),
              ),
              child: Text(
                'TUTUP',
                style: TextStyle(color: _primaryColor),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _isPaid = true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
              ),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  String _getExpiryTime() {
    final now = DateTime.now();
    final expiry = now.add(const Duration(minutes: 15));
    return '${expiry.hour}:${expiry.minute.toString().padLeft(2, '0')}';
  }
}
