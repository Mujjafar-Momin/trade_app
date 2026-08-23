import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:trading_app/trade_app.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final Order order;

  const OrderConfirmationScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isBuy = order.side == OrderSide.buy;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                isBuy ? 'assets/jsons/success.json' : 'assets/jsons/success_red.json',
              ),
              Text(
                '${order.side.label} Order Placed',
                style: AppTextStyles.bold18.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  children: [
                    _ConfirmRow(label: 'Symbol', value: order.symbol),
                    _ConfirmRow(label: 'Quantity', value: '${order.quantity}'),
                    _ConfirmRow(label: 'Price', value: '₹${order.priceAtExecution}'),
                    _ConfirmRow(label: 'Order Value', value: '₹${order.value}'),
                    _ConfirmRow(
                      label: 'Time',
                      value: DateFormat('MMM d, y • h:mm a').format(order.timestamp),
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _ConfirmRow({required this.label, required this.value, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.regular14.copyWith(color: colors.textSecondary)),
          Text(value, style: AppTextStyles.semibold14.copyWith(color: colors.textPrimary)),
        ],
      ),
    );
  }
}
