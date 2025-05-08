import 'package:flutter/material.dart';

class OrderStatusBadge extends StatelessWidget {
  final String status;

  const OrderStatusBadge({super.key, required this.status});

  Color _getColor() {
    switch (status) {
      case 'Dimasak':
        return Colors.orange;
      case 'Siap':
        return Colors.green;
      case 'Diantar':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: _getColor(),
      label: Text(status, style: const TextStyle(color: Colors.white)),
    );
  }
}
