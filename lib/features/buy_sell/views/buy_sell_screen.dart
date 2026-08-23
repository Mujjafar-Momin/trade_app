import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trading_app/trade_app.dart';

class BuySellScreen extends StatelessWidget {
  const BuySellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BuySellController>(
      builder: (controller) {
        final colors = context.appColors;

        return Scaffold(
          appBar: AppBar(title: Text(controller.symbol)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  final tick = MarketFeedService().prices[controller.symbol]!.value;
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Live Price', style: AppTextStyles.medium14.copyWith(color: colors.textSecondary)),
                        Text('₹${tick.ltp}', style: AppTextStyles.bold18.copyWith(color: colors.textPrimary)),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 12),
                Obx(() {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: colors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Available Balance', style: AppTextStyles.medium14.copyWith(color: colors.textSecondary)),
                        Text(
                          '₹${WalletService().balance.value}',
                          style: AppTextStyles.semibold14.copyWith(color: colors.textPrimary),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 20),
                Text('Side', style: AppTextStyles.medium14.copyWith(color: colors.textSecondary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _SideButton(
                        label: 'Buy',
                        selected: controller.side == OrderSide.buy,
                        selectedColor: colors.success,
                        onTap: () => controller.setSide(OrderSide.buy),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SideButton(
                        label: 'Sell',
                        selected: controller.side == OrderSide.sell,
                        selectedColor: colors.error,
                        onTap: () => controller.setSide(OrderSide.sell),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Quantity', style: AppTextStyles.medium14.copyWith(color: colors.textSecondary)),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.quantityController,
                  keyboardType: TextInputType.number,
                  onChanged: controller.onQuantityChanged,
                  decoration: const InputDecoration(hintText: 'Number of shares'),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  final tick = MarketFeedService().prices[controller.symbol]!.value;
                  final qty = int.tryParse(controller.quantityController.text) ?? 0;
                  final orderValue = tick.ltp * Decimal.fromInt(qty);
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order Value', style: AppTextStyles.medium14.copyWith(color: colors.textSecondary)),
                        Text('₹$orderValue', style: AppTextStyles.semibold16.copyWith(color: colors.textPrimary)),
                      ],
                    ),
                  );
                }),
                if (controller.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage!,
                    style: AppTextStyles.regular14.copyWith(color: colors.error),
                  ),
                ],
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isSubmitting ? null : controller.submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.side == OrderSide.buy ? colors.success : colors.error,
                    ),
                    child: controller.isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                          )
                        : Text(
                            controller.side == OrderSide.buy ? 'Buy' : 'Sell',
                            style: AppTextStyles.semibold16.copyWith(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SideButton extends StatelessWidget {
  final String label;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  const _SideButton({
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? selectedColor.withValues(alpha: .12) : colors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? selectedColor : colors.border, width: selected ? 1.5 : 1),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.semibold14.copyWith(color: selected ? selectedColor : colors.textSecondary),
          ),
        ),
      ),
    );
  }
}
