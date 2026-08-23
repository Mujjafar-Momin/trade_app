import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trading_app/trade_app.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Market'),
            actions: [
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                tooltip: 'Debug settings',
                onPressed: () => showDebugSettingsSheet(context),
              ),
            ],
          ),
          body: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: controller.symbols.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final symbol = controller.symbols[index];
              return _MarketRow(
                symbol: symbol,
                priceRx: controller.priceRxFor(symbol),
                onTap: () => controller.onRowTap(symbol),
              );
            },
          ),
        );
      },
    );
  }
}

class _MarketRow extends StatelessWidget {
  final String symbol;
  final Rx<PriceTick> priceRx;
  final VoidCallback onTap;

  const _MarketRow({required this.symbol, required this.priceRx, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  symbol,
                  style: AppTextStyles.semibold14.copyWith(color: colors.textPrimary),
                ),
              ),
              Expanded(
                flex: 4,
                child: PriceFlashCell(
                  priceRx: priceRx,
                  builder: (context, tick, dotColor) {
                    final Color directionColor;
                    if (tick.change == Decimal.zero) {
                      directionColor = colors.neutral;
                    } else if (tick.change < Decimal.zero) {
                      directionColor = colors.error;
                    } else {
                      directionColor = colors.success;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${tick.ltp}',
                            style: AppTextStyles.semibold14.copyWith(color: colors.textPrimary),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${tick.change < Decimal.zero ? '' : '+'}${tick.change} (${tick.changePercent.toStringAsFixed(2)}%)',
                                style: AppTextStyles.regular12.copyWith(color: directionColor),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}